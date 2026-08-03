#!/bin/bash

#---------------- Paleta de Cores ----------------
CYAN_NEON='\033[1;36m' 
MAGENTA_NEON='\033[1;35m'
RED_NEON='\033[1;31m'
PINK_NEON='\033[1;35m'
CLR_RESET='\033[0m'
YELLOW_NEON='\033[1;33m'
GREEN_NEON='\033[1;32m'



if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW_NEON}[!] O Painel de Controle exige permissões de administrador (root).${CLR_RESET}"
    echo -e "${GREEN_NEON}[+] Solicitando elevação de privilégios via sudo...${CLR_RESET}"
    echo ""
    exec sudo "$0" "$@"
fi

#---------------- Cabeçalho do Menu ----------------
menu_cabecalho() {
    clear
    echo -e "${PINK_NEON}================================================================================${CLR_RESET}"
    echo ""
    echo -e "${CYAN_NEON}          ███╗   ███╗██╗   ██╗    ██╗  ██╗ ██████╗ ███╗   ███╗███████╗          ${CLR_RESET}"
    echo -e "${CYAN_NEON}          ████╗ ████║╚██╗ ██╔╝    ██║  ██║██╔═══██╗████╗ ████║██╔════╝          ${CLR_RESET}"
    echo -e "${CYAN_NEON}          ██╔████╔██║ ╚████╔╝     ███████║██║   ██║██╔████╔██║█████╗            ${CLR_RESET}"
    echo -e "${CYAN_NEON}          ██║╚██╔╝██║  ╚██╔╝      ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝            ${CLR_RESET}"
    echo -e "${CYAN_NEON}          ██║ ╚═╝ ██║   ██║       ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗          ${CLR_RESET}"
    echo -e "${CYAN_NEON}          ╚═╝     ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝          ${CLR_RESET}"
    echo ""
    echo -e "${CYAN_NEON}               ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗               ${CLR_RESET}"
    echo -e "${CYAN_NEON}               ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗              ${CLR_RESET}"
    echo -e "${CYAN_NEON}               ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝              ${CLR_RESET}"
    echo -e "${CYAN_NEON}               ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗              ${CLR_RESET}"
    echo -e "${CYAN_NEON}               ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║              ${CLR_RESET}"
    echo -e "${CYAN_NEON}               ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝              ${CLR_RESET}"
    echo ""
    echo -e "${MAGENTA_NEON}                     Painel Interativo de Controle e Gestão                     ${CLR_RESET}"
    echo ""
    echo -e "${PINK_NEON}================================================================================${CLR_RESET}"
    echo ""
    echo -e "${RED_NEON}=======================> V: 1.0  ${CLR_RESET}${RED_NEON}By: 𝕿𝖍𝖊 𝖘𝖊𝖛𝖊𝖓𝖙𝖍  <============================${CLR_RESET}"
    echo ""
    echo -e "${CYAN_NEON}================================================================================${CLR_RESET}"
    echo ""
    echo -e "${YELLOW_NEON}=========================> Menu de Opções <==========================${CLR_RESET}"
    echo ""
    echo ""


}

pausa_retorno() {
    echo ""
    read -n 1 -s -r -p $'\e[1;36m[+] Pressione qualquer tecla para voltar ao menu principal...\e[0m'
    echo -e "${CYAN_NEON}================================================================================${CLR_RESET}"

}

#---------------- Funções do Menu ---------------------------------------------------------

# 1 Checar Internet --------------------------------------------------------------------------------
checar_internet() {
    echo ""
    echo -e "${CYAN_NEON}>>> Testando conexão de rede, espelho da distro e latência (ms)...${CLR_RESET}\n"
    echo ""
    echo -e "${CYAN_NEON}[1/2] Localizando repositório oficial da distribuição...${CLR_RESET}"
    echo ""
    MIRROR=$(grep -rh -E 'https?://' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null \
        | grep -v '^\s*#' \
        | grep -oE 'https?://[^/ ]+' \
        | head -n 1 \
        | sed -E 's#https?://##')

    # Fallback de segurança se não encontrar nenhum mirror no APT
    if [ -z "$MIRROR" ]; then
        MIRROR="deb.debian.org"
    fi

    echo -e "Espelho detectado: ${YELLOW_NEON}${MIRROR}${CLR_RESET}"
    echo -e "Enviando 3 pings (Limite de espera: 13 segundos)..."
    echo ""

    if ping -c 3 -w 13 "$MIRROR"; then
        echo -e "\n${GREEN_NEON}[✔] Comunicação com o espelho (${MIRROR}) realizada com sucesso!${CLR_RESET}"
    else
        echo -e "\n${RED_NEON}[!] Falha na resposta do espelho (${MIRROR}).${CLR_RESET}"
    fi

    echo -e "\n--------------------------------------------------------------------------------\n"
    echo -e "${CYAN_NEON}[2/2] Testando conexão com a Internet via Google (8.8.8.8)...${CLR_RESET}"
    echo -e "Enviando 3 pings (Limite de espera: 13 segundos)..."
    echo ""

    if ping -c 3 -w 13 8.8.8.8; then
        echo -e "\n${GREEN_NEON}[✔] Conexão com a Internet ativa e estável!${CLR_RESET}"
    else
        echo -e "\n${RED_NEON}[!] Sem resposta da Internet (8.8.8.8). Verifique sua interface de rede.${CLR_RESET}"
    fi

    pausa_retorno
}

# 2 Checar Disco --------------------------------------------------------------------------------
checar_disco() {
    echo ""
    echo -e "${CYAN_NEON}>>> Verificando Espaço em Todos os Discos do Sistema...${CLR_RESET}\n"
    echo ""
    if ! df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay -x efivarfs 2>/dev/null; then
        
        df -h
    fi

    echo -e "\n${PINK_NEON}--------------------------------------------------------------------------------${CLR_RESET}"

    RESUMO_TOTAL=$(df -h --total -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null | awk '/total/ {print "Espaço Total: " $2 " | Usado: " $3 " | Livre: " $4 " (" $5 " em uso)"}')

    if [ -n "$RESUMO_TOTAL" ]; then
        echo -e "${GREEN_NEON}📊 Resumo Geral (Todos os Discos): ${RESUMO_TOTAL}${CLR_RESET}"
    fi

    pausa_retorno
}

# 3  Checar RAM --------------------------------------------------------------------------------
checar_ram() {
    echo ""
    echo -e "${CYAN_NEON}>>> Monitorando Memória RAM...${CLR_RESET}"
    free -h
    pausa_retorno
}


# 4  Verificar Logs --------------------------------------------------------------------------
verificar_logs() {
    echo ""
    LOG_DIR="/var/log/my-home-server/tasks"
    echo -e "${CYAN_NEON}>>> Lendo o último log gerado no sistema...${CLR_RESET}"
    if [ -d "$LOG_DIR" ]; then
        # Usa 'find' + timestamp de modificação (%T@) para ordenar com segurança total
        ULTIMO_LOG=$(find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)
        
        if [ -n "$ULTIMO_LOG" ] && [ -f "$ULTIMO_LOG" ]; then
            echo -e "${GREEN_NEON}Abrindo: $ULTIMO_LOG${CLR_RESET}\n"
            cat "$ULTIMO_LOG"
        else
            echo -e "${YELLOW_NEON}Nenhum arquivo de log encontrado em $LOG_DIR.${CLR_RESET}"
        fi
    else
        echo -e "${RED_NEON}O diretório de logs ainda não existe.${CLR_RESET}"
    fi
    pausa_retorno
}

# 5  Timeshift -----------------------------------------------------------------------------
verificar_timeshift() {
    echo ""
    echo -e "${CYAN_NEON}>>> Verificando Backups do Timeshift...${CLR_RESET}"
    timeshift --list
    pausa_retorno
}

# 6  Firewall Seguros ------------------------------------------------------------------
gerenciar_firewall() {
    echo ""
    echo -e "${CYAN_NEON}>>> Gerenciador do UFW Firewall...${CLR_RESET}"
    ufw status verbose
    echo ""
    echo -e "   ${CYAN_NEON}[ A ]${CLR_RESET} Ativar regras padrão de segurança"
    echo -e "   ${CYAN_NEON}[ B ]${CLR_RESET} Desativar Firewall"
    echo -e "   ${CYAN_NEON}[ C ]${CLR_RESET} Abrir Interface Gráfica (GUFW)"
    echo -e "   ${CYAN_NEON}[ S ]${CLR_RESET} Voltar ao menu principal"
    echo ""
    read -rp "   Escolha uma opção [A/B/C/S]: " fw_op
    
    case "$fw_op" in
        [Aa]* ) 
            # Políticas Padrão
            ufw default deny incoming > /dev/null 2>&1
            ufw default allow outgoing > /dev/null 2>&1

            # Acesso Remoto e VPN
            ufw allow 22/tcp comment 'SSH Access' > /dev/null 2>&1
            ufw allow in on tailscale0 comment 'Tailscale Network' > /dev/null 2>&1

            # Compartilhamento de Arquivos (Samba TCP + UDP)
            ufw allow 445/tcp comment 'Samba Share' > /dev/null 2>&1
            ufw allow 139/tcp comment 'Samba NetBIOS' > /dev/null 2>&1
            ufw allow 137/udp comment 'Samba NetBIOS Name' > /dev/null 2>&1
            ufw allow 138/udp comment 'Samba NetBIOS Datagram' > /dev/null 2>&1

            # Serviços Web e Containers
            ufw allow 80/tcp comment 'Nextcloud HTTP' > /dev/null 2>&1
            ufw allow 443/tcp comment 'Nextcloud HTTPS' > /dev/null 2>&1
            ufw allow 8080/tcp comment 'Docker Web Services' > /dev/null 2>&1

            # Ativação do Firewall
            ufw --force enable
            echo -e "\n${GREEN_NEON}[✔] Firewall ativado com regras de segurança aplicadas!${CLR_RESET}"
            ;;
        [Bb]* ) 
            ufw --force disable
            echo -e "\n${YELLOW_NEON}[!] Firewall desativado! (ATENÇÃO: Servidor desprotegido)${CLR_RESET}"
            ;;
        [Cc]* )
           
            if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
                echo -e "\n${RED_NEON}[!] Erro: Nenhum ambiente gráfico detectado nesta sessão.${CLR_RESET}"
                echo -e "${YELLOW_NEON}[i] Se você está em uma sessão SSH, abra a interface diretamente no desktop local.${CLR_RESET}"
            else
                # Trava de Segurança 2: Instala o GUFW dinamicamente caso ainda não exista
                if ! command -v gufw >/dev/null 2>&1; then
                    echo -e "\n${CYAN_NEON}[+] GUFW não encontrado. Instalando pacotes...${CLR_RESET}"
                    apt-get update -qq && apt-get install -y gufw
                fi
                
                echo -e "\n${GREEN_NEON}[+] Inicializando a interface gráfica GUFW...${CLR_RESET}"
                gufw >/dev/null 2>&1 &
            fi
            ;;
        * ) 
            echo -e "\n${CYAN_NEON}[i] Nenhuma alteração foi realizada no Firewall.${CLR_RESET}" 
            echo -e "${CYAN_NEON}[i] Retornando ao menu principal...${CLR_RESET}"
            ;;
    esac
    pausa_retorno
}

# 7  htop
abrir_htop() {
    htop
}

# 8  Latência de Rede Lógica dos 10s --------------------------------------------------------------
verificar_rede() {
    echo ""
    echo -e "${CYAN_NEON}>>> Analisando tráfego RX/TX da rede principal (10 segundos)...${CLR_RESET}"
    
    INTERFACE=$(ip route | awk '/default/ {print $5}' | head -n 1)
    
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED_NEON}[!] Erro: Nenhuma interface de rede com rota padrão foi detectada.${CLR_RESET}"
        pausa_retorno
        return 1
    fi

    RX_ANTES=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes 2>/dev/null)
    TX_ANTES=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes 2>/dev/null)
    
    sleep 10
    
    RX_DEPOIS=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes 2>/dev/null)
    TX_DEPOIS=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes 2>/dev/null)
    
    RX_DIFF=$((RX_DEPOIS - RX_ANTES))
    TX_DIFF=$((TX_DEPOIS - TX_ANTES))
    
    echo "Download (RX) nos últimos 10s: $((RX_DIFF / 1024)) KB"
    echo "Upload (TX) nos últimos 10s: $((TX_DIFF / 1024)) KB"
    
    if [ "$RX_DIFF" -gt 5242880 ] || [ "$TX_DIFF" -gt 5242880 ]; then
        echo -e "${YELLOW_NEON}Status: Rede em ALTO USO no momento.${CLR_RESET}"
    else
        echo -e "${GREEN_NEON}Status: Rede OCIOSA/Estável.${CLR_RESET}"
    fi
    pausa_retorno
}

# 9  Task Crontab (Manutenção)---------------------------------------------------------------------------------
rodar_manutencao() {
    echo ""
    echo -e "${CYAN_NEON}>>> Iniciando script de manutenção e atualização...${CLR_RESET}"
    if [ -f "/etc/my-home-server/task-crontab-home-server.sh" ]; then
        bash /etc/my-home-server/task-crontab-home-server.sh
    else
        echo -e "${RED_NEON}Arquivo de manutenção não encontrado!${CLR_RESET}"
    fi
    pausa_retorno
}

# 10 Reset de Fábrica ---------------------------------------------------------------------------------------
reset_fabrica() {
    echo ""
    echo -e "${YELLOW_NEON}>>> ATENÇÃO: Reativar configurações padrão (Samba, SSH, Cron, Timeshift, UFW e Docker).${CLR_RESET}"
    
    # Valida a senha do Sudo diretamente na condicional
    if sudo -v; then
        echo -e "${RED_NEON}O processo iniciará em 7 segundos. Pressione Ctrl+C para CANCELAR!${CLR_RESET}"
        for i in {7..1}; do
            echo -ne "Iniciando em $i... \r"
            sleep 1
        done
        echo -e "\n${GREEN_NEON}Aplicando configurações padrão...${CLR_RESET}"
        
        # Variáveis globais do usuário
        USUARIO_REAL="${SUDO_USER:-$USER}"
        HOME_USUARIO=$(eval echo "~$USUARIO_REAL")
        NET_HOSTNAME="${USUARIO_REAL}-my-home-server"

        # 1. DOCKER
        echo -e "${CYAN_NEON}[+] Redefinindo configurações do Docker...${CLR_RESET}"
        systemctl enable --now docker > /dev/null 2>&1
        usermod -aG docker "$USUARIO_REAL"

        
        # 2. FIREWALL (UFW)
        
        echo -e "${CYAN_NEON}[+] Redefinindo regras padrão do Firewall UFW...${CLR_RESET}"
        ufw --force reset > /dev/null 2>&1
        ufw default deny incoming > /dev/null 2>&1
        ufw default allow outgoing > /dev/null 2>&1
        
        ufw allow 22/tcp comment 'SSH Access' > /dev/null 2>&1
        ufw allow in on tailscale0 comment 'Tailscale Network' > /dev/null 2>&1
        ufw allow 445/tcp comment 'Samba Share' > /dev/null 2>&1
        ufw allow 139/tcp comment 'Samba NetBIOS' > /dev/null 2>&1
        ufw allow 80/tcp comment 'Nextcloud HTTP' > /dev/null 2>&1
        ufw allow 443/tcp comment 'Nextcloud HTTPS' > /dev/null 2>&1
        ufw allow 8080/tcp comment 'Docker Web Services' > /dev/null 2>&1
        
        echo "y" | ufw enable > /dev/null 2>&1
        ufw reload > /dev/null 2>&1

        # 3. CRONTAB (Script de Manutenção)
        
        echo -e "${CYAN_NEON}[+] Redefinindo Cron de Manutenção...${CLR_RESET}"
        CRON_JOB="0 2 * * 1 /etc/my-home-server/task-crontab-home-server.sh > /dev/null 2>&1"
        crontab -l 2>/dev/null | grep -v "task-crontab-home-server.sh" | crontab -
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

        # 4. SAMBA (Padrão de Fábrica: Pastas de Mídia Seguras)
        
        echo -e "${CYAN_NEON}[+] Redefinindo Samba (Padrão: Pastas de Mídia)...${CLR_RESET}"
        for PASTA in "Imagens" "Vídeos" "Música" "Downloads" "Pictures" "Videos" "Music"; do
            mkdir -p "$HOME_USUARIO/$PASTA"
            chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_USUARIO/$PASTA"
            chmod 755 "$HOME_USUARIO/$PASTA"
        done

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

        # 5. TIMESHIFT (Menu Interativo de Backup)
        
        echo -e "${CYAN_NEON}[+] Redefinindo Timeshift (Frequência: 2x na semana)...${CLR_RESET}"
        
        echo -e "\n${YELLOW_NEON}Como você deseja configurar o escopo do backup no Timeshift?${CLR_RESET}"
        echo "  [1] Apenas Padrão (Exclui pastas /root e /home)"
        echo "  [2] Padrão + /root (Inclui todos os arquivos da /root, inclusive ocultos)"
        echo "  [3] TUDO (Backup Completo: Sistema + /root + /home com ocultos)"
        
        while true; do
            read -rp "  Digite a opção desejada [1/2/3]: " OPCAO_TS_FILTRO
            case $OPCAO_TS_FILTRO in
                1)
                    # Exclui root e home (comportamento padrão do sistema)
                    TS_FILTROS='"exclude" : [
    "- /home/**",
    "- /root/**"
  ]'
                    echo -e "${GREEN_NEON}  [✓] Selecionado: Apenas Padrão do Sistema.${CLR_RESET}"
                    break
                    ;;
                2)
                    # Exclui apenas a home, deixando o root entrar no backup
                    TS_FILTROS='"exclude" : [
    "- /home/**"
  ]'
                    echo -e "${GREEN_NEON}  [✓] Selecionado: Padrão + /root.${CLR_RESET}"
                    break
                    ;;
                3)
                    # Não exclui nada, backup 100% completo
                    TS_FILTROS='"exclude" : []'
                    echo -e "${GREEN_NEON}  [✓] Selecionado: Backup Completo (TUDO).${CLR_RESET}"
                    break
                    ;;
                *)
                    # Tratamento firme contra erros
                    echo -e "${RED_NEON}  [!] Opção inválida! Por favor, preste atenção e digite 1, 2 ou 3.${CLR_RESET}"
                    ;;
            esac
        done

        TS_WEEKLY_COUNT="2"
        TS_CRON_SCHEDULE="0 3 * * 3,6"

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
        # Limpa o cron antigo do Timeshift e reinsere a regra
        crontab -l 2>/dev/null | grep -v "timeshift --create" | crontab -
        CRON_TS="$TS_CRON_SCHEDULE /usr/bin/timeshift --create --tags W --scripted > /dev/null 2>&1"
        (crontab -l 2>/dev/null; echo "$CRON_TS") | crontab -

        echo -e "\n${GREEN_NEON}Configurações restauradas com sucesso! Seu ambiente voltou à estabilidade padrão.${CLR_RESET}"
    else
        echo -e "${RED_NEON}Falha na autenticação Sudo. Abortando.${CLR_RESET}"
    fi
    pausa_retorno
}

# 11 Sair Limpo ---------------------------------------------------------------------------------------
sair_painel() {
    echo ""
    echo -e "${CYAN_NEON}Saindo do painel de controle!...${CLR_RESET}"
    echo ""
    echo ""
    exit 0 
}

# 12 Desinstalar Tudo ---------------------------------------------------------------------------------------
desinstalar_tudo() {
    echo ""
    echo -e "${YELLOW_NEON}=====================================================${CLR_RESET}"
    echo -e "${YELLOW_NEON}  PERIGO: DESINSTALAÇÃO COMPLETA         ${CLR_RESET}"
    echo -e "${YELLOW_NEON}=====================================================${CLR_RESET}"
    read -rp "Você tem CERTEZA que deseja remover todo o servidor? (s/N): " conf1
    if [[ "$conf1" == "s" || "$conf1" == "S" ]]; then
        read -rp "ÚLTIMO AVISO. Digite 'DELETAR' para confirmar: " conf2
        if [[ "$conf2" == "DELETAR" ]]; then
            echo -e "${RED_NEON}Iniciando desinstalação...${CLR_RESET}"
            echo -e "\nIniciando a remoção do My Home Server..."
            sleep 1

            # 1. Remover o atalho global
            echo "[1/3] Removendo o atalho global..."
            sudo rm -f /usr/local/bin/myhomeserver

            # 2. Limpar o agendamento do Crontab
            echo "[2/3] Removendo a rotina automática do Crontab..."
            sudo crontab -l | grep -v '/etc/my-home-server/task-crontab-home-server.sh' | sudo crontab -

            # 3. Remover os diretórios do script (arquivos e logs)
            echo "[3/3] Apagando pastas, scripts e arquivos de log..."
            sudo rm -rf /etc/my-home-server/
            sudo rm -rf /var/log/my-home-server/

            echo -e "\nDesinstalação concluída com sucesso! Todos os rastros da ferramenta foram apagados."
            echo "Nota: Se você instalou o Samba ou o GUFW pelo painel, os pacotes continuam no sistema para não quebrar outros serviços. Se quiser removê-los no futuro, use 'sudo apt remove samba gufw'."
            sleep 2
            echo "Sistema limpo."
            exit 0
        else
            echo "Desinstalação abortada."
        fi
    else
        echo "Desinstalação abortada."
    fi
    pausa_retorno
}

while true; do
    menu_cabecalho
    
    echo -e "   ${CYAN_NEON}[ 1 ]${CLR_RESET} Checar Conexão com a Internet (Ping)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 2 ]${CLR_RESET} Checar Espaço em Disco Disponível"
    echo ""
    echo -e "   ${CYAN_NEON}[ 3 ]${CLR_RESET} Monitorar Memória RAM (Livre/Usada)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 4 ]${CLR_RESET} Verificar e Abrir o Último Log do Sistema"
    echo ""
    echo -e "   ${CYAN_NEON}[ 5 ]${CLR_RESET} Verificar Status dos Backups (Timeshift)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 6 ]${CLR_RESET} Gerenciar Firewall (Ativar/Desativar UFW)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 7 ]${CLR_RESET} Abrir Gerenciador de Processos (htop)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 8 ]${CLR_RESET} Verificar Tráfego de Rede (10s Ociosidade)"
    echo ""
    echo -e "   ${CYAN_NEON}[ 9 ]${CLR_RESET} Rodar Manutenção/Atualização do Servidor"
    echo ""
    echo -e "   ${CYAN_NEON}[ 10 ]${CLR_RESET} Reativar Configurações Padrão (Factory Reset)"
    echo ""
    echo -e "   ${YELLOW_NEON}[ 11 ]${CLR_RESET} Sair do Painel de Controle"
    echo ""
    echo ""
    echo -e "   ${RED_NEON}[ 12 ] DESINSTALAR TUDO DO SERVIDOR ${CLR_RESET}"
    echo ""
    read -rp "   Escolha uma opção: " opcao
    echo ""
    case $opcao in
        1) checar_internet ;;
        2) checar_disco ;;
        3) checar_ram ;;
        4) verificar_logs ;;
        5) verificar_timeshift ;;
        6) gerenciar_firewall ;;
        7) abrir_htop ;;
        8) verificar_rede ;;
        9) rodar_manutencao ;;
        10) reset_fabrica ;;
        11) sair_painel ;;
        12) desinstalar_tudo ;;
        *) 
            echo -e "\n${RED_NEON}[!] Opção inválida! Escolha um número de 1 a 12.${CLR_RESET}"
            pausa_retorno
            ;;
    esac
done