# 🏛️ ***My Home Server (Alicerce)***
---

🛠️ O **My Home Server (Alicerce)** foi idealizado para resolver a lacuna de manutenção e estabilidade do sistema base em servidores domésticos. Em vez de impor um ecossistema engessado, o projeto atua como um **alicerce resiliente e autônomo**: ele cuida da saúde do sistema, segurança de rede e integridade de hardware/software, permitindo que você rode o que quiser por cima (Docker, CasaOS, servidores de mídia, etc.) com total paz de espírito.

---
## Principais Funcionalidades !

- **📋 Infraestrutura & Instalação**
- **Instalador Modular:** Preparação automática do ambiente base, instalação de dependências essenciais e organização dos scripts de sistema.
- **Painel CLI Interativo:** Interface centralizada e leve via terminal para controle visual de serviços, execução manual de rotinas e diagnósticos rápidos.
  
- **🔄 Manutenção Autônoma & Auto-Reparo**
- **Auto-Recuperação do APT:** Rotina de detecção e correção automática para dependências quebradas, pacotes órfãos e remoção de travas de execução do gerenciador de pacotes.
- **Limpeza de Resíduos e Cache:** Purga periódica de fragmentos desnecessários do sistema para otimização de espaço e performance.
  
- **🛡️ Salvaguardas Críticas & Prevenção de Inoperância**
- **Algoritmo de Reboot Seguro (Contra-Prova de Rede):** Antes de autorizar qualquer reinicialização automática do sistema, o script executa uma checagem dupla de tráfego de rede (teste de 10s + contra-prova de 5s). Se houver transferência ativa de arquivos ou uso de banda, o reboot é abortado.
- **Reserva Mínima de Armazenamento:** Monitoramento do ponto de montagem principal (`/`). O sistema exige e garante no mínimo **5GB livres em disco** para evitar travamentos ou corrupção de dados por esgotamento de armazenamento.
- **Rotação de Logs em Ciclo FIFO:** Gerenciamento autônomo dos arquivos de log do servidor, mantendo apenas os registros recentes para evitar o inchaço discreto da partição raiz.
  
- **🌐 Serviços de Rede & Compartilhamento**
- **Configuração Simplificada de Rede & Firewall:** Integração direta com o **UFW** para gerenciamento e liberação de portas vitais de forma simplificada.
- **Compartilhamento Samba (NAS Doméstico):** Módulo para subida e gerenciamento facilitado de pastas compartilhadas na rede local.
 
- **🧱 Arquitetura Não-Intrusiva (Base Alicerce)**
- **Zero Interferência:** Não impõe contêineres forçados nem altera o funcionamento padrão do seu ecossistema. Funciona perfeitamente como suporte para quem deseja utilizar **CasaOS, Portainer, Docker Standalone ou Mídia Server**.

- **Código 100% Auditado no ShellCheck✅:** Todos os scripts de automação passam por análise estática rigorosa para garantir zero falhas de sintaxe, máxima segurança de execução e adesão estrita às melhores práticas do Shell.

---

## **Pré-requisitos**

- Sistema Operacional baseado em **Debian / Ubuntu** (recomendado em instalações *minimal/server*).
- Usuário com privilégios de `sudo` ou acesso como `root`.
- Conexão com a internet para sincronização de repositórios.

---

🚀 Instalação Rápida (One-Liner)

Para clonar o repositório, conceder permissão de execução e iniciar a instalação automatizada, abra o terminal do seu servidor e cole o comando abaixo:

```bash
sudo apt update && sudo apt install -y git &&
git clone https://github.com/GustavoGianeli/my-home-server-alicerce.git &&
cd my-home-server-alicerce &&
chmod +x install-home-server.sh &&
sudo ./install-home-server.sh
```
---

### **𝓓𝓮𝓿𝓮𝓵𝓸𝓹𝓮𝓭 𝓫𝔂 𝓖𝓾𝓼𝓽𝓪𝓿𝓸 𝓖𝓲𝓪𝓷𝓮𝓵𝓲  (𝓣𝓱𝓮_ 𝓢𝓮𝓿𝓮𝓷𝓽𝓱)**  

**" 𝓓𝓮𝓿𝓮𝓵𝓸𝓹𝓮𝓭 𝓫𝔂 𝓣𝓱𝓮_ 𝓢𝓮𝓿𝓮𝓷𝓽𝓱 — 𝓦𝓱𝓮𝓻𝓮 𝓲𝓷𝓽𝓮𝓰𝓻𝓲𝓽𝔂 𝓶𝓮𝓮𝓽𝓼 𝓹𝓮𝓻𝓯𝓸𝓻𝓶𝓪𝓷𝓬𝓮. "**

---

## **Conceito de Arquitetura**
<img width="459" height="208" alt="arquitetura" src="https://github.com/user-attachments/assets/69916c65-a4de-4937-8e52-674b012f58bc" />

## **Prints do sistema em funcionamento** 
<img width="1273" height="537" alt="instalação do servidor" src="https://github.com/user-attachments/assets/9eb28988-803c-4146-a533-fdba03211cdf" />

<img width="1375" height="939" alt="1" src="https://github.com/user-attachments/assets/f45dbe46-41df-45c3-8cf2-a2f0189c4d06" />

<img width="1375" height="939" alt="2" src="https://github.com/user-attachments/assets/e6937431-d826-460f-84ce-526a6029eb16" />

<img width="1375" height="939" alt="4" src="https://github.com/user-attachments/assets/74ac429f-f72a-4bea-b98e-2e0d7ff7fe68" />

<img width="1375" height="939" alt="3" src="https://github.com/user-attachments/assets/2beb286b-dc65-4396-a7c2-754986146b81" />

<img width="1375" height="939" alt="5" src="https://github.com/user-attachments/assets/d265ac7e-57f6-4ca7-bc0e-79124aa0e32b" />

<img width="1375" height="939" alt="6" src="https://github.com/user-attachments/assets/9643ef00-295a-4a5f-a06e-8e15acda7cda" />

<img width="1165" height="1263" alt="menu painel de controle" src="https://github.com/user-attachments/assets/644f9183-3450-481e-829f-1486e7a7310a" />

---
## **Icone do Sistema**
<img width="512" height="512" alt="icone-my-home-server" src="https://github.com/user-attachments/assets/ba8c920f-3665-4df4-b25d-b96ffa430712" />

---
## **Video de aprensentação**

https://github.com/user-attachments/assets/0d0d069d-4e2d-4eef-abab-73f59b5440cf

---


Este projeto está sob a licença MIT - veja o arquivo LICENSE para mais detalhes.

Desenvolvido por: Gustavo Gianeli (The Seventh)

Estudante de Ciência da Computação & Entusiasta de Infraestrutura Linux.
