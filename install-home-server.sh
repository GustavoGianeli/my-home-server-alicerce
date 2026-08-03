#!/bin/bash
 #---------------- paleta de cores ----------------
CYAN_NEON='\033[1;36m' 
MAGENTA_NEON='\033[1;35m'
RED_NEON='\033[1;31m'
BLUE_NEON='\033[1;36m' 
PINK_NEON='\033[1;35m'
CLR_RESET='\033[0m'
YELLOW_NEON='\033[1;33m'
GREEN_NEON='\033[1;32m'


# ==============================================================================
# LOG DE INSTALAÇÃO E REDIRECIONAMENTO DE SAÍDA
# ==============================================================================
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED_NEON}[!] Por favor, execute este script como root (usando sudo).${CLR_RESET}"
  exit 1
fi


# Identifica o usuário comum real que chamou o sudo e sua home
USUARIO_REAL="${SUDO_USER:-$USER}"
HOME_USUARIO=$(eval echo "~$USUARIO_REAL")

# Garante a criação da pasta de logs do sistema
LOG_DIR="/var/log/my-home-server"
mkdir -p "$LOG_DIR"
ARQUIVO_LOG="$LOG_DIR/install_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Redireciona stdout e stderr para o terminal E para o arquivo de log simultaneamente
exec > >(tee -a "$ARQUIVO_LOG") 2>&1

echo -e "${CYAN_NEON}[+] Registro de instalação iniciado em: $ARQUIVO_LOG${CLR_RESET}"


 #-----------------cabecalho----------------
echo -e "${PINK_NEON}┌──────────────────────────────────────────────────────────────────────────────┐${CLR_RESET}"
echo -e "${PINK_NEON}│                                                                              │${CLR_RESET}"
echo -e "${PINK_NEON}│              ${MAGENTA_NEON}𝚒 𝚗 𝚜 𝚝 𝚊 𝚕 𝚊 𝚍 𝚘 𝚛   𝚖 𝚢   𝚑 𝚘 𝚖 𝚎   𝚜 𝚎 𝚛 𝚟 𝚎 𝚛${CLR_RESET}${PINK_NEON}               │${CLR_RESET}"
echo -e "${PINK_NEON}│                                                                              │${CLR_RESET}"
echo -e "${PINK_NEON}│                  ${CYAN_NEON}Framework de Infraestrutura e Automação${CLR_RESET}${PINK_NEON}                     │${CLR_RESET}"
echo -e "${PINK_NEON}│                                                                              │${CLR_RESET}"
echo -e "${PINK_NEON}└──────────────────────────────────────────────────────────────────────────────┘${CLR_RESET}"
echo -e "${RED_NEON}V 1.0 ${CLR_RESET}"
echo ""
echo -e "${RED_NEON}By: 𝕿𝖍𝖊 𝖘𝖊𝖛𝖊𝖓𝖙𝖍${CLR_RESET}"
echo ""
echo ""
echo -e "${CYAN_NEON}Iniciando o processo de instalação do My Home Server...${CLR_RESET}"
echo -e "${BLUE_NEON}Atenção esse script de instalação vai fazer a instalação basica e configuração basica de rede domestica...${CLR_RESET}"
sleep 2 
#----------------------------------------------------------------------------------- atualizacao do sistema
echo ""
read -rp "Deseja prosseguir? (s/n): " RESPOSTA
echo ""
case "$RESPOSTA"
    in
    [sS]|[sS][iI][mM])
        echo -e "${BLUE_NEON}[+] Iniciando processo de instalação...${CLR_RESET}"
        sleep 0.7
        echo -e "${CYAN_NEON}[1/5] Atualizando pacotes e repositórios do sistema base...${CLR_RESET}"
        apt update -y && apt upgrade -y
        ;;
    [nN]|[nN][ãA][oO])
        echo -e "${MAGENTA_NEON}Obrigado por usar o serviço de instalação!${CLR_RESET}"
        exit 0
        ;;
    *)
        echo -e "${RED_NEON}[!] Opção inválida / comando não encontrado. Encerrando por segurança.${CLR_RESET}"
        exit 1
        ;;
esac
echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
#----------------------------------------------------------------------------------- pacotes dev 
echo ""
echo -e "\n${CYAN_NEON}Verificando e instalando dependências de Kernel e Compilação...${CLR_RESET}"

PACOTES_DEV=(
    "build-essential"
    "gcc"
    "make"
    "git"
    "dkms"
    "linux-headers-$(uname -r)"
)

PACOTES_PARA_INSTALAR=()

for pkg in "${PACOTES_DEV[@]}"; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
        echo -e "${BLUE_NEON}  [✓] $pkg já está instalado.${CLR_RESET}"
    else
        echo -e "${YELLOW_NEON}  [!] $pkg não encontrado. Marcando para instalação...${CLR_RESET}"
        PACOTES_PARA_INSTALAR+=("$pkg")
    fi
done

if [ ${#PACOTES_PARA_INSTALAR[@]} -gt 0 ]; then
    echo -e "${CYAN_NEON}[+] Instalando pacotes dev ausentes...${CLR_RESET}"
    apt install -y "${PACOTES_PARA_INSTALAR[@]}"
    echo -e "${BLUE_NEON}[✓] Ambiente de desenvolvimento e Kernel configurados com sucesso!${CLR_RESET}"
else
    echo -e "${BLUE_NEON}[✓] Todos os pacotes de desenvolvimento já estão presentes no Debian.${CLR_RESET}"
fi
echo ""
echo -e "${PINK_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
sleep 1
#----------------------------------------------------------------------------------- serviços basicos 
echo -e "\n${CYAN_NEON}[3/5] Verificando e instalando utilitários e serviços do servidor...${CLR_RESET}"


PACOTES_SISTEMA=(
    "curl"
    "wget"
    "net-tools"
    "htop"
    "lm-sensors"
    "fastfetch"        # Substituto moderno do neofetch no Debian
    "openssh-server"
    "samba"
    "ufw"
    "gufw"
    "timeshift"
    "cron"
)

PACOTES_SISTEMA_FALTANTES=()

for pkg in "${PACOTES_SISTEMA[@]}"; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
        echo -e "${GREEN_NEON}  [✓] $pkg já está instalado.${CLR_RESET}"
    else
        echo -e "${YELLOW_NEON}  [!] $pkg não encontrado. Marcando para instalação...${CLR_RESET}"
        PACOTES_SISTEMA_FALTANTES+=("$pkg")
    fi
done

if [ ${#PACOTES_SISTEMA_FALTANTES[@]} -gt 0 ]; then
    echo -e "${CYAN_NEON}[+] Instalando utilitários faltantes...${CLR_RESET}"
    apt install -y "${PACOTES_SISTEMA_FALTANTES[@]}"
    echo -e "${GREEN_NEON}[✓] Utilitários e serviços instalados com sucesso!${CLR_RESET}"
else
    echo -e "${GREEN_NEON}[✓] Todos os utilitários do sistema já estão presentes.${CLR_RESET}"
fi
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
#----------------------------------------------------------------------------------- docker

echo -e "\n${CYAN_NEON}[4/5] Verificando e configurando o ambiente Docker...${CLR_RESET}"
sleep 1
PACOTES_DOCKER=(
    "docker.io"
    "docker-compose-v2"
)

PACOTES_DOCKER_FALTANTES=()

for pkg in "${PACOTES_DOCKER[@]}"; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
        echo -e "${GREEN_NEON}  [✓] $pkg já está instalado.${CLR_RESET}"
    else
        echo -e "${YELLOW_NEON}  [!] $pkg não encontrado. Marcando para instalação...${CLR_RESET}"
        PACOTES_DOCKER_FALTANTES+=("$pkg")
    fi
done

if [ ${#PACOTES_DOCKER_FALTANTES[@]} -gt 0 ]; then
    echo -e "${CYAN_NEON}[+] Instalando Docker via repositório Main...${CLR_RESET}"
    apt install -y "${PACOTES_DOCKER_FALTANTES[@]}"
fi

# Configuração e inicialização do serviço Docker
echo -e "${CYAN_NEON}[+] Garantindo inicialização e permissões do serviço Docker...${CLR_RESET}"
systemctl enable --now docker

# Adiciona o usuário comum (que invocou o sudo) ao grupo docker, se aplicável
if [ -n "$SUDO_USER" ]; then
    usermod -aG docker "$SUDO_USER"
    echo -e "${GREEN_NEON}[✓] Usuário '$SUDO_USER' adicionado ao grupo Docker.${CLR_RESET}"
fi

echo -e "${GREEN_NEON}[✓] Ambiente Docker configurado com sucesso!${CLR_RESET}"

echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"

###### proxima etapa de instalação ------------------------------------------------------------------------------
echo ""
#ETAPA 5: ESTRUTURA, PERMISSÕES, FIREWALL E CRONTAB -------------------------
echo -e "\n${CYAN_NEON}[5/5] Finalizando instalação dos scripts, permissões e agendamento...${CLR_RESET}"
sleep 1
# 1. Criação do diretório central no /etc/ e de logs
mkdir -p /etc/my-home-server
mkdir -p /var/log/my-home-server
echo -e "${GREEN_NEON}  [✓] Diretórios /etc/my-home-server e /var/log/my-home-server criados.${CLR_RESET}"

# 2. Movimentação dos scripts e atribuição de permissão 755
if [ -f "./my-home-server.sh" ] && [ -f "./task-crontab-home-server.sh" ]; then
    cp ./my-home-server.sh /etc/my-home-server/
    cp ./task-crontab-home-server.sh /etc/my-home-server/
    
    chmod 755 /etc/my-home-server/my-home-server.sh
    chmod 755 /etc/my-home-server/task-crontab-home-server.sh
    
    # Cria atalho global no sistema para abrir o painel facilmente
    ln -sf /etc/my-home-server/my-home-server.sh /usr/local/bin/myhomeserver
    echo -e "${GREEN_NEON}  [✓] Scripts movidos para /etc/my-home-server/ com permissão 755.${CLR_RESET}"
else
    echo -e "${RED_NEON}  [!] AVISO: Os scripts secundários não foram encontrados na pasta atual.${CLR_RESET}"
fi

# 3. Configuração do Firewall (UFW)-----------------------------------------------------------------------------------------
echo -e "${CYAN_NEON}[+] Aplicando regras do Firewall UFW (SSH, Samba, Tailscale, Docker e Nextcloud)...${CLR_RESET}"
sleep 1

# Política Padrão (Bloqueia entrada / Libera saída)
ufw default deny incoming > /dev/null 2>&1
ufw default allow outgoing > /dev/null 2>&1


ufw allow 22/tcp comment 'SSH Access' > /dev/null 2>&1
ufw allow in on tailscale0 comment 'Tailscale Network' > /dev/null 2>&1

ufw allow 445/tcp comment 'Samba Share' > /dev/null 2>&1
ufw allow 139/tcp comment 'Samba NetBIOS' > /dev/null 2>&1


ufw allow 80/tcp comment 'Nextcloud HTTP' > /dev/null 2>&1
ufw allow 443/tcp comment 'Nextcloud HTTPS' > /dev/null 2>&1
ufw allow 8080/tcp comment 'Docker Web Services' > /dev/null 2>&1

# Ativa e recarrega o UFW sem pedir confirmação manual
echo "y" | ufw enable > /dev/null 2>&1
ufw reload > /dev/null 2>&1

echo -e "${GREEN_NEON}  [✓] Firewall UFW ativo (SSH, Samba, Tailscale, HTTP 80, HTTPS 443 e 8080 liberados).${CLR_RESET}"

echo -e "${CYAN_NEON}[+] Agendando rotina de manutenção no Crontab (Segunda-feira às 02:00)...${CLR_RESET}"
CRON_JOB="0 2 * * 1 /etc/my-home-server/task-crontab-home-server.sh > /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo -e "${GREEN_NEON}  [✓] Cron configurado para rodar o task-crontab-home-server.sh como root.${CLR_RESET}"

echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
echo -e "${RED_NEON}Configurações de firewall aplicadas, todas podem ser revertidas no painel de controle posteriormente${CLR_RESET}" 
echo -e "${RED_NEON}Use o comando my-home-server no terminal ou app para acessar o painel de controle${CLR_RESET}" 
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
sleep 2 
echo ""

# CONFIGURAÇÃO DO SAMBA--------------------------------------------------------------------------------------------
echo -e "\n${CYAN_NEON}[+] Configuração de Compartilhamento de Rede (Samba)${CLR_RESET}"

# Identifica o usuário comum e seu diretório Home
USUARIO_REAL="${SUDO_USER:-$USER}"
HOME_USUARIO=$(eval echo "~$USUARIO_REAL")
NET_HOSTNAME="${USUARIO_REAL}-my-home-server"

while true; do
    echo -e "${YELLOW_NEON}Como você deseja configurar o acesso do Samba na sua rede local?${CLR_RESET}"
    echo "  [1] Compartilhar APENAS as pastas de Mídia (Imagens, Músicas, Vídeos, Downloads) - Mais Seguro"
    echo "  [2] Compartilhar TODA a pasta /home (Aplica permissão 774 na raiz do usuário) - Menos Seguro"
    echo "  [3] Pular configuração do Samba (Não compartilhar nada na rede)"
    read -rp "Digite a opção desejada (1, 2 ou 3): " OPCAO_SAMBA

    case $OPCAO_SAMBA in
        1)
            echo -e "${CYAN_NEON}[+] Configurando Samba restrito às pastas de mídia...${CLR_RESET}"
            
            for PASTA in "Imagens" "Vídeos" "Música" "Downloads" "Pictures" "Videos" "Music"; do
                mkdir -p "$HOME_USUARIO/$PASTA"
                chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/$PASTA"
                chmod 755 "$HOME_USUARIO/$PASTA"
            done

            [ -f /etc/samba/smb.conf ] && cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

            cat << EOF > /etc/samba/smb.conf
            [global]
            workgroup = WORKGROUP
            netbios name = $NET_HOSTNAME
            server string = $NET_HOSTNAME (My Home Server)
            security = user
            map to guest = Bad User
            guest account = $USUARIO_REAL
            log file = /var/log/samba/log.%m
            max log size = 1000
            hosts allow = 192.168. 10. 127.0.0.1
            hosts deny = ALL

            [Imagens]
            path = $HOME_USUARIO/Imagens
            browseable = yes
            read only = no
            guest ok = yes
            force user = $USUARIO_REAL

            [Videos]
            path = $HOME_USUARIO/Vídeos
            browseable = yes
            read only = no
            guest ok = yes
            force user = $USUARIO_REAL

            [Musicas]
            path = $HOME_USUARIO/Música
            browseable = yes
            read only = no
            guest ok = yes
            force user = $USUARIO_REAL

            [Downloads]
            path = $HOME_USUARIO/Downloads
            browseable = yes
            read only = no
            guest ok = yes
            force user = $USUARIO_REAL
EOF
            systemctl restart smbd nmbd > /dev/null 2>&1
            echo -e "${GREEN_NEON}  [✓] Samba configurado APENAS para as pastas de Mídia!${CLR_RESET}"
            break
            ;;
            
        2)
            echo -e "${CYAN_NEON}[+] Configurando Samba para TODA a /home (Atenção aos riscos aplicando chmod 774)...${CLR_RESET}"
            
            chmod 774 "$HOME_USUARIO"
            
            [ -f /etc/samba/smb.conf ] && cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

            cat << EOF > /etc/samba/smb.conf
            [global]
            workgroup = WORKGROUP
            netbios name = $NET_HOSTNAME
            server string = $NET_HOSTNAME (My Home Server)
            security = user
            map to guest = Bad User
            guest account = $USUARIO_REAL
            log file = /var/log/samba/log.%m
            max log size = 1000
            hosts allow = 192.168. 10. 127.0.0.1
            hosts deny = ALL

            [Home_$USUARIO_REAL]
            comment = Home Completa (Acesso Total 774)
            path = $HOME_USUARIO
            browseable = yes
            read only = no
            guest ok = yes
            force user = $USUARIO_REAL
EOF
            systemctl restart smbd nmbd > /dev/null 2>&1
            echo -e "${GREEN_NEON}  [✓] Samba configurado liberando TODA a pasta Home!${CLR_RESET}"
            break
            ;;
            
        3)
            echo -e "${YELLOW_NEON}  [-] Configuração do Samba ignorada pelo usuário. Seguindo com a instalação...${CLR_RESET}"
            break
            ;;
            
        *)
            
            echo -e "\n${RED_NEON}  [!] Opção inválida! Por favor, digite apenas 1, 2 ou 3.${CLR_RESET}\n"
            sleep 1
            ;;
    esac
done
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
sleep 1

# CONFIGURAÇÃO DO TIMESHIFT (BACKUP RSYNC DO SISTEMA)----------------------------------------------------------------------------
echo -e "\n${CYAN_NEON}[+] Configuração de Backup e Restauração (Timeshift)${CLR_RESET}"

# Verifica e instala o timeshift caso não esteja no sistema
if ! command -v timeshift &> /dev/null; then
    echo -e "${YELLOW_NEON}  [*] Instalando Timeshift...${CLR_RESET}"
    apt-get install -y timeshift > /dev/null 2>&1
fi

while true; do
    echo -e "${YELLOW_NEON}Deseja configurar a rotina automática de backups do Timeshift?${CLR_RESET}"
    echo "  [1] Sim - 2x por semana (Quarta e Sábado às 03:00 - Mantém 2 backups)"
    echo "  [2] Sim - 1x por semana (Apenas Sábado às 03:00 - Mantém 1 backup)"
    echo "  [3] Não - Pular configuração do Timeshift"
    read -rp "Digite a opção desejada (1, 2 ou 3): " OPCAO_TS_FREQ

    case $OPCAO_TS_FREQ in
        1)
            TS_WEEKLY_COUNT="2"
            TS_CRON_SCHEDULE="0 3 * * 3,6" # 3 = Quarta, 6 = Sábado
            break
            ;;
        2)
            TS_WEEKLY_COUNT="1"
            TS_CRON_SCHEDULE="0 3 * * 6" # 6 = Sábado
            break
            ;;
        3)
            echo -e "${YELLOW_NEON}  [-] Configuração do Timeshift pulada pelo usuário. Seguindo com a instalação...${CLR_RESET}"
            break
            ;;
        *)
           
            echo -e "\n${RED_NEON}  [!] Opção inválida! Por favor, digite uma opção válida (1, 2 ou 3).${CLR_RESET}\n"
            sleep 1
            ;;
    esac
done

# Só pergunta sobre os filtros se o usuário NÃO escolheu pular (opção 3)
if [ "$OPCAO_TS_FREQ" != "3" ]; then
    
    while true; do
        echo -e "\n${YELLOW_NEON}O que você deseja incluir no backup (Modo RSYNC)?${CLR_RESET}"
        echo "  [1] Apenas o Padrão do Sistema (Exclui tudo da /root e da /home)"
        echo "  [2] Padrão + Arquivos Ocultos (Salva configurações da /root e /home)"
        echo "  [3] TUDO (Backup completo do Sistema + Todos os arquivos da /root e /home)"
        read -rp "Digite a opção desejada (1, 2 ou 3): " OPCAO_TS_FILTRO

        case $OPCAO_TS_FILTRO in
            1)
                # Exclui pastas home e root (Padrão do Timeshift)
                TS_FILTROS='"exclude" : [
                    "- /home/**",
                    "- /root/**"
                ]'
                break
                ;;
            2)
                # Inclui arquivos/pastas ocultas (dotfiles) e exclui o resto
                TS_FILTROS='"exclude" : [
                    "+ /home/*/.*",
                    "- /home/**",
                    "+ /root/.*",
                    "- /root/**"
                ]'
                break
                ;;
            3)
                TS_FILTROS='"exclude" : []'
                break
                ;;
            *)
                echo -e "\n${RED_NEON}  [!] Opção inválida! Por favor, digite uma opção válida (1, 2 ou 3).${CLR_RESET}\n"
                sleep 1
                ;;
        esac
    done

    echo -e "${CYAN_NEON}[+] Aplicando configurações no Timeshift e no Cron...${CLR_RESET}"

    # Gera o arquivo de configuração do Timeshift
    cat << EOF > /etc/timeshift/timeshift.json
{
  "backup_device_uuid" : "",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "false",
  "include_btrfs_home_for_backup" : "false",
  "include_btrfs_home_for_restore" : "false",
  "stop_cron_emails" : "true",
  "btrfs_use_qgroup" : "true",
  "schedule_monthly" : "false",
  "schedule_weekly" : "false",
  "schedule_daily" : "false",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "0",
  "count_weekly" : "$TS_WEEKLY_COUNT",
  "count_daily" : "0",
  "count_hourly" : "0",
  "count_boot" : "0",
  "snapshot_size" : "0",
  "snapshot_count" : "0",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  $TS_FILTROS,
  "exclude-apps" : []
}
EOF
    
    # 1. Limpa possíveis agendamentos antigos do Timeshift no Cron root para não duplicar
    crontab -l 2>/dev/null | grep -v "timeshift --create" | crontab -
    
    # 2. Adiciona o novo agendamento com os dias exatos
    CRON_TS="$TS_CRON_SCHEDULE /usr/bin/timeshift --create --tags W --scripted > /dev/null 2>&1"
    (crontab -l 2>/dev/null; echo "$CRON_TS") | crontab -
    
    # Executa o check do Timeshift silenciosamente
    timeshift --check > /dev/null 2>&1
    
    echo -e "${GREEN_NEON}  [✓] Timeshift configurado! O Backup vai rodar de acordo com a opção escolhida.${CLR_RESET}"
fi
sleep 1
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""

# CRIAÇÃO DO ATALHO GRÁFICO (DESKTOP ENTRY)
echo -e "${CYAN_NEON}[+] Configurando atalho gráfico do My Home Server...${CLR_RESET}"

APPLOCAL_DIR="$HOME_USUARIO/.local/share/applications"
mkdir -p "$APPLOCAL_DIR"

# Copia o ícone para a pasta central do sistema junto com o script
if [ -f "./icone-my-home-server.png" ]; then
    cp ./icone-my-home-server.png /etc/my-home-server/
    chmod 644 /etc/my-home-server/icone-my-home-server.png
fi

# Gera o arquivo .desktop apontando para os caminhos corretos
cat << EOF > "$APPLOCAL_DIR/my-home-server.desktop"
[Desktop Entry]
Type=Application
Version=1.0
Name=My Home Server
GenericName=System server protocol
Comment=Gerenciador do Servidor Doméstico
Exec=/usr/local/bin/myhomeserver
Icon=/etc/my-home-server/icone-my-home-server.png
Terminal=true
Categories=System;Utility;
Keywords=debian;servidor;myserver;home-server
StartupNotify=true
EOF

chown "$USUARIO_REAL:$USUARIO_REAL" "$APPLOCAL_DIR/my-home-server.desktop"
chmod 755 "$APPLOCAL_DIR/my-home-server.desktop"

echo -e "${GREEN_NEON}  [✓] Atalho gráfico criado com sucesso no menu de aplicativos!${CLR_RESET}"

echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
sleep 1

IP_LOCAL=$(hostname -I | awk '{print $1}')
[ -z "$IP_LOCAL" ] && IP_LOCAL="Não detectado"

curl -fsSL https://tailscale.com/install.sh | sh
sudo ufw allow in on tailscale0
sudo ufw allow 22/tcp comment 'SSH Access'
sudo ufw reload

echo -e "\n${PINK_NEON}┌──────────────────────────────────────────────────────────────────────────────┐${CLR_RESET}"
echo -e "${PINK_NEON}│                                                                              │${CLR_RESET}"
echo -e "${PINK_NEON}│          ${GREEN_NEON}✔  A L I C E R C E   I N S T A L A D O   C O M   S U C E S S O !${CLR_RESET}${PINK_NEON}     │${CLR_RESET}"
echo -e "${PINK_NEON}│                                                                              │${CLR_RESET}"
echo -e "${PINK_NEON}└──────────────────────────────────────────────────────────────────────────────┘${CLR_RESET}"
echo -e ""
echo -e "➔ IP Local do Servidor: ${CYAN_NEON}$IP_LOCAL${CLR_RESET}"
echo -e "➔ Acesso SSH: ${CYAN_NEON}ssh $(whoami)@$IP_LOCAL${CLR_RESET}"
echo -e "➔ Painel do Servidor: Digite ${CYAN_NEON}'myhomeserver'${CLR_RESET} no terminal a qualquer momento."
echo -e "➔ O arquivo ${YELLOW_NEON}install-home-server.sh${CLR_RESET} cumpriu sua missão e pode ser apagado."
echo -e ""
sudo tailscale up
echo ""
sleep 1.5 

# 4. Captura de Dados da Rede
IP_LOCAL=$(hostname -I | awk '{print $1}')
[ -z "$IP_LOCAL" ] && IP_LOCAL="Não detectado"

# 5. Criador de Atalhos de Acesso (Home & Documentos)

USUARIO_REAL="${SUDO_USER:-$USER}"
HOME_USUARIO=$(eval echo "~$USUARIO_REAL")
echo ""
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"

# Conteúdo do arquivo de atalho
CONTEUDO_ATALHO="=====================================================
    MY HOME SERVER - DADOS DE ACESSO LOCAL
=====================================================

➔ IP Local do Servidor: $IP_LOCAL
➔ Comando de Acesso SSH: ssh $USUARIO_REAL@$IP_LOCAL
➔ Compartelhamento Samba: \\\\$IP_LOCAL (Windows) ou smb://$IP_LOCAL (Linux)
➔ Painel CLI: Digite 'myhomeserver' no terminal

Gerado em: $(date '+%d/%m/%Y às %H:%M:%S')
====================================================="

# Cria o arquivo na raiz da Home do usuário
echo "$CONTEUDO_ATALHO" > "$HOME_USUARIO/ACESSO_SERVIDOR.txt"
chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/ACESSO_SERVIDOR.txt"

# Cria o arquivo na pasta Documentos (se a pasta existir)
if [ -d "$HOME_USUARIO/Documentos" ]; then
    echo "$CONTEUDO_ATALHO" > "$HOME_USUARIO/Documentos/ACESSO_SERVIDOR.txt"
    chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/Documentos/ACESSO_SERVIDOR.txt"
elif [ -d "$HOME_USUARIO/Documents" ]; then
    echo "$CONTEUDO_ATALHO" > "$HOME_USUARIO/Documents/ACESSO_SERVIDOR.txt"
    chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/Documents/ACESSO_SERVIDOR.txt"
fi

echo -e "${GREEN_NEON}  [✓] Arquivos 'ACESSO_SERVIDOR.txt' criados na Home e em Documentos!${CLR_RESET}"
echo -e "${CYAN_NEON}  [i] Verifique os arquivos para obter informações de acesso ao servidor.${CLR_RESET}"
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
sleep 1.5

# Cópias do arquivo de log da instalação para a pasta Documentos do usuário---------------------------------
if [ -f "$ARQUIVO_LOG" ]; then
    if [ -d "$HOME_USUARIO/Documentos" ]; then
        cp "$ARQUIVO_LOG" "$HOME_USUARIO/Documentos/LOG_INSTALACAO_SERVIDOR.log"
        chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/Documentos/LOG_INSTALACAO_SERVIDOR.log"
    elif [ -d "$HOME_USUARIO/Documents" ]; then
        cp "$ARQUIVO_LOG" "$HOME_USUARIO/Documents/LOG_INSTALACAO_SERVIDOR.log"
        chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/Documents/LOG_INSTALACAO_SERVIDOR.log"
    fi
    echo -e "${GREEN_NEON}  [✓] Log de instalação salvo em Documentos/LOG_INSTALACAO_SERVIDOR.log!${CLR_RESET}"
fi

echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
echo ""
echo -e "${RED_NEON}[!] ATENÇÃO. os ip local do servidor foram salvos em $HOME_USUARIO/ACESSO_SERVIDOR.txt e em documentos !!!.${CLR_RESET}"
echo ""
echo -e "${CYAN_NEON}-----------------------------------------------------------------------------------------------------${CLR_RESET}"
sleep 1.5

echo -e "\n${CYAN_NEON}[+] Instalação e configurações concluídas com sucesso!${CLR_RESET}"

while true; do
    echo -e "${YELLOW_NEON}Deseja fechar esta janela do terminal agora?${CLR_RESET}"
    echo "  [S/s/Y/y] - Sim, fechar o terminal imediatamente"
    echo "  [N/n]     - Não, manter o terminal aberto para leitura do log"
    read -rp "Digite sua opção [S/N]: " OPCAO_FECHAR

    case $OPCAO_FECHAR in
        [SsYy])
            echo -e "\n${GREEN_NEON}[✓] Encerrando o instalador e fechando o terminal... Até mais!${CLR_RESET}"
            sleep 2
            # Descobre o PID do processo pai (Terminal) e força o encerramento da janela
            TERMINAL_PID=$(ps -o ppid= -p $$ | tr -d ' ')
            kill -9 "$TERMINAL_PID" 2>/dev/null || exit 0
            break
            ;;
            
        [Nn])
            echo -e "\n${GREEN_NEON}[✓] Processo finalizado! O terminal continuará aberto em modo leitura.${CLR_RESET}"
            echo -e "${CYAN_NEON}Pressione qualquer tecla ou feche a janela quando terminar a leitura.${CLR_RESET}\n"
            exit 0
            ;;
            
        *)
            # Por segurança, o wildcard (*) trata entradas inválidas mantendo o terminal aberto em modo leitura
            echo -e "\n${YELLOW_NEON}[!] Opção não reconhecida. Por segurança, o processo foi encerrado e o terminal mantido aberto.${CLR_RESET}\n"
            exit 0
            ;;
    esac
done