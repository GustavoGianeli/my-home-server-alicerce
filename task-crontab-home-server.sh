#!/bin/bash 
#---------------- Paleta de Cores ----------------
CYAN_NEON='\033[1;36m' 
MAGENTA_NEON='\033[1;35m'
RED_NEON='\033[1;31m'
BLUE_NEON='\033[1;36m' 
PINK_NEON='\033[1;35m'
CLR_RESET='\033[0m'
YELLOW_NEON='\033[1;33m'
GREEN_NEON='\033[1;32m'

# Bloqueia qualquer tela rosa/azul do debconf pedindo interação
export DEBIAN_FRONTEND=noninteractive

DPKG_OPTS=(
    "-o" "Dpkg::Options::=--force-confdef"
    "-o" "Dpkg::Options::=--force-confold"
)

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED_NEON}[!] Este script de manutenção precisa ser executado como root.${CLR_RESET}"
  exit 1
fi

# 1. CONFIGURAÇÃO DE LOGS ROTATIVOS (MANTÉM APENAS OS 7 MAIS RECENTES)
LOG_DIR="/var/log/my-home-server/tasks"
mkdir -p "$LOG_DIR"

# Gera o nome do log atual com Timestamp
ARQUIVO_LOG="$LOG_DIR/task_$(date +'%Y-%m-%d_%H-%M-%S').log"

exec > >(tee -a "$ARQUIVO_LOG") 2>&1

find "$LOG_DIR" -maxdepth 1 -type f -name "task_*.log" -print0 | \
  sort -zr | \
  tail -zn +8 | \
  xargs -0 -r rm -f --

#---------------- Cabeçalho Visual ----------------
echo -e "${BLUE_NEON}Arquivos de da manutenção do alicerce do servidor${CLR_RESET}"
echo -e "${YELLOW_NEON}Iniciando Rotina de atualização${CLR_RESET}"
echo ""
echo -e "${MAGENTA_NEON}V: 1.0  By: The Seventh ${CLR_RESET}"

echo -e "${CYAN_NEON}[+] Início da execução: $(date +'%d/%m/%Y às %H:%M:%S')${CLR_RESET}"
echo -e "${CYAN_NEON}[+] Arquivo de log atual: $ARQUIVO_LOG${CLR_RESET}"
echo -e "${GREEN_NEON}[✓] Rotação de logs concluída (mantendo até 7 históricos na pasta).${CLR_RESET}"
echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""

# 2. atualização
echo -e "${CYAN_NEON}[+] Iniciando verificações de segurança pré-atualização...${CLR_RESET}"
sleep 1

# --- VERIFICAÇÃO 1: CONECTIVIDADE COM A INTERNET ---
echo -e "${CYAN_NEON}[+] Verificando conexão de rede (Opção 1: Espelhos locais do repositório)...${CLR_RESET}"

# Extrai automaticamente o domínio do seu espelho atual (ex: deb.debian.org ou espelhos do Brasil)
MIRROR=$(awk '/^deb / {print $2}' /etc/apt/sources.list | head -n 1 | awk -F/ '{print $3}')
[ -z "$MIRROR" ] && MIRROR="deb.debian.org"

# Opção 1: Ping no espelho (3 pacotes, espera máxima de 13 segundos)
if ping -c 3 -w 13 "$MIRROR" > /dev/null 2>&1; then
    echo -e "${GREEN_NEON}[✓] Conexão OK na Opção 1 (Mirror: $MIRROR).${CLR_RESET}"
else
    echo -e "${YELLOW_NEON}[!] Falha na Opção 1. Tentando Opção 2: Ping no site do Debian...${CLR_RESET}"
    
    # Opção 2: Ping direto no debian.org (3 pacotes, espera máxima de 13 segundos)
    if ping -c 3 -w 13 debian.org > /dev/null 2>&1; then
        echo -e "${GREEN_NEON}[✓] Conexão OK na Opção 2 (debian.org).${CLR_RESET}"
    else
        echo -e "${RED_NEON}[!] Sem conexão nas duas opções após 13 segundos. Abortando manutenção.${CLR_RESET}"
        exit 1 # Encerra o script com erro
    fi
fi

echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
sleep 1
#verificando espaço-----------------------------------------------

echo -e "${CYAN_NEON}[+] Verificando espaço em disco na partição raiz (Mínimo de 5GB)...${CLR_RESET}"

# df -BG pega o espaço em Gigabytes / NR==2 pula o cabeçalho / print $4 pega a coluna de "Livre" / sed tira a letra "G"
ESPACO_LIVRE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

if [ "$ESPACO_LIVRE" -ge 5 ]; then
    echo -e "${GREEN_NEON}[✓] Espaço adequado: ${ESPACO_LIVRE}GB disponíveis. Prosseguindo...${CLR_RESET}"
else
    echo -e "${RED_NEON}[!] Espaço insuficiente! Apenas ${ESPACO_LIVRE}GB disponíveis. O mínimo exigido é 5GB.${CLR_RESET}"
    echo -e "${RED_NEON}[!] Atualização abortada por segurança para evitar quebra do sistema.${CLR_RESET}"
    exit 1 # Encerra o script com erro
fi

echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""

#atualizando ----------------------------------------

echo -e "${CYAN_NEON}executando atualizaçao de repositorios${CLR_RESET}" 
apt-get update -y 
echo ""
echo -e "${GREEN_NEON}executado update com sucesso${CLR_RESET}" 
echo ""

echo -e "${CYAN_NEON}iniciando upgrade${CLR_RESET}"
sleep 1
if ! apt-get upgrade -y "${DPKG_OPTS[@]}"; then
        echo ""
        echo -e "${YELLOW_NEON}[!] Erro detectado no upgrade! Acionando modo de correção...${CLR_RESET}"
        
        dpkg --configure -a > /dev/null 2>&1
        apt-get install -f -y > /dev/null 2>&1
        
        echo -e "${CYAN_NEON}[+] Tentando retomar o upgrade após a correção...${CLR_RESET}"
        sleep 1
        
        if apt-get upgrade -y "${DPKG_OPTS[@]}"; then
            echo ""
            echo -e "${GREEN_NEON}executado upgrade com sucesso após autorreparo!${CLR_RESET}"
        else
            echo ""
            echo -e "${RED_NEON}[!] Falha crítica: O sistema não conseguiu resolver o conflito.${CLR_RESET}"
        fi
    else
        echo ""
        echo -e "${GREEN_NEON}executado upgrade com sucesso${CLR_RESET}"
    fi

echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
#-------------------------------------------------------------------------------------------------------------------
sleep 1
echo -e "${CYAN_NEON}[+] Procurando pacotes obsoletos e limpando o sistema...${CLR_RESET}"
apt-get autoremove -y > /dev/null 2>&1
apt-get autoclean -y > /dev/null 2>&1
echo -e "${GREEN_NEON}[✓] Limpeza do APT concluída.${CLR_RESET}" 
echo "" 
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo "" 
echo -e "${CYAN_NEON}[+] Iniciando limpeza de cache e containers do Docker...${CLR_RESET}"

if docker system prune -f > /dev/null 2>&1; then
    echo -e "${GREEN_NEON}[✓] Limpeza de lixo do Docker concluída com sucesso.${CLR_RESET}"
else
    echo -e "${YELLOW_NEON}[!] Aviso: Não foi possível executar a limpeza do Docker (Serviço parado?).${CLR_RESET}"
fi
#------------------------------------------------------------------------------------------------------------------------
echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
echo -e "${CYAN_NEON}[+] Começando a varredura de status dos serviços...${CLR_RESET}"
echo ""
echo -e "${CYAN_NEON}[+] Verificando status dos serviços essenciais...${CLR_RESET}"

# Array com os serviços vitais do seu servidor baseados na instalação
SERVICOS=("docker" "smbd" "ssh")

for servico in "${SERVICOS[@]}"; do
    if systemctl is-active --quiet "$servico"; then
        echo -e "${GREEN_NEON}  [✓] Serviço '$servico' está RODANDO normalmente.${CLR_RESET}"
    else
        echo -e "${RED_NEON}  [!] ALERTA: Serviço '$servico' está PARADO ou falhou!${CLR_RESET}"
        echo -e "${YELLOW_NEON}      Tentando reinicialização de emergência...${CLR_RESET}"
        
        # Tenta dar um tranco no serviço
        systemctl restart "$servico" > /dev/null 2>&1
        
        # Verifica se o tranco funcionou
        if systemctl is-active --quiet "$servico"; then
            echo -e "${GREEN_NEON}      [+] Serviço '$servico' recuperado com sucesso.${CLR_RESET}"
        else
            echo -e "${RED_NEON}      [!] Falha ao recuperar '$servico'. Exige revisão manual.${CLR_RESET}"
        fi
    fi
done

echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
#check de reboot----------------------------------------
echo -e "${CYAN_NEON}[+] Verificando necessidade de reinicialização (Kernel/Mesa Drivers)...${CLR_RESET}"


if [ -f /var/run/reboot-required ]; then
    echo -e "${YELLOW_NEON}[!] Atualização crítica detectada. O sistema precisa ser reiniciado.${CLR_RESET}"
    echo -e "${CYAN_NEON}[+] Iniciando monitoramento de rede para evitar queda de conexões...${CLR_RESET}"

    # Descobre a interface de rede principal (ex: eth0, enp3s0) dinamicamente
    INTERFACE=$(ip route | awk '/default/ {print $5}' | head -n 1)
    
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED_NEON}[!] Interface de rede não detectada. Abortando reboot por segurança.${CLR_RESET}"
    else
        # Função interna para pegar o total de tráfego (Download + Upload) em bytes
        get_trafego_total() {
            local RX
            local TX
            
            # Atribuição separada da declaração para não mascarar o exit status do 'cat'
            RX=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
            TX=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)
            
            echo $((RX + TX))
        }

        # --- ETAPA 1: TESTE DE 10 SEGUNDOS ---
        echo -e "${CYAN_NEON}  [*] Iniciando timer de 10 segundos para medir oscilação...${CLR_RESET}"
        BYTES_INICIAL=$(get_trafego_total)
        sleep 10
        BYTES_FINAL=$(get_trafego_total)
        DIFERENCA=$((BYTES_FINAL - BYTES_INICIAL))

        
        if [ "$DIFERENCA" -gt 2000000 ]; then
            echo -e "${RED_NEON}  [!] ALERTA: Alto tráfego detectado na rede! Alguém está usando o servidor.${CLR_RESET}"
            echo -e "${RED_NEON}  [!] Reinicialização CANCELADA. O sistema será reiniciado na próxima janela.${CLR_RESET}"
        else
            echo -e "${GREEN_NEON}  [✓] Rede ociosa na primeira checagem. Efetuando contra-prova...${CLR_RESET}"
            
            # --- ETAPA 2: TESTE DE 5 SEGUNDOS (A CONTRA-PROVA) ---
            echo -e "${CYAN_NEON}  [*] Iniciando timer de 5 segundos adicionais...${CLR_RESET}"
            BYTES_INICIAL_2=$(get_trafego_total)
            sleep 5
            BYTES_FINAL_2=$(get_trafego_total)
            DIFERENCA_2=$((BYTES_FINAL_2 - BYTES_INICIAL_2))

            
            if [ "$DIFERENCA_2" -gt 1000000 ]; then
                echo -e "${RED_NEON}  [!] ALERTA: Tráfego detectado na contra-prova! Reinicialização CANCELADA.${CLR_RESET}"
            else
                echo -e "${GREEN_NEON}  [✓] Servidor totalmente ocioso.${CLR_RESET}"
                echo ""
                
                sleep 2
                echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
                echo -e "${CYAN_NEON}[+] Rotina de manutenção semanal finalizada com sucesso em: $(date +'%d/%m/%Y às %H:%M:%S')${CLR_RESET}"
                reboot
                exit 0 
            fi
        fi
    fi
else
    echo -e "${GREEN_NEON}[✓] Nenhuma atualização de Kernel/Mesa exige reboot no momento.${CLR_RESET}"
fi

echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo -e "${CYAN_NEON}[+] Rotina de manutenção semanal finalizada com sucesso em: $(date +'%d/%m/%Y às %H:%M:%S')${CLR_RESET}"

