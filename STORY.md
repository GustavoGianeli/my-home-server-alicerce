<img src="https://flagcdn.com/16x12/us.png" alt="US"> [English (US)](README.en-us.md) | <img src="https://flagcdn.com/16x12/br.png" alt="BR">   [Português (BR)](README.md)    
# 📖 A História por Trás do Alicerce: Do Guarda-Roupa ao Servidor (alicerce) 

"Por que pagar mensalidade de nuvem se a gente pode construir nossa própria infraestrutura em casa?"

Toda grande ferramenta nasce de uma necessidade real. O **My Home Server (Alicerce)** não surgiu de uma aula teórica ou de um tutorial genérico da internet — ele nasceu de uma conversa de família, um desabafo sobre custos de armazenamento e uma pilha de peças de computador antigas que ganharam uma segunda vida.

---

## 1: O "Servidor Frankenstein" e a Nuvem do Meu Tio

Tudo começou quando meu tio me perguntou sobre planos do Google Drive. Ele estava ficando sem espaço, as mensalidades estavam cada vez mais caras e ele avaliava assinar um plano maior para guardar seus arquivos.

Minha resposta foi imediata:  
*— "Pô, mano, com o valor que você vai gastar em mensalidade ao longo do tempo, a gente consegue montar um servidor na sua casa!"*

Minha ideia inicial era reaproveitar dois computadores antigos que eu tinha guardados em casa. Abri os gabinetes para analisar o hardware e me deparei com placas-mãe antigas com placas de rede de 100 Mbps. Mesmo com a distribuição Linux mais enxuta do mundo, a rede gargalaria qualquer transferência de arquivos pesados.

<img width="4000" height="3000" alt="1 pc" src="https://github.com/user-attachments/assets/b3c296c7-5873-460e-a25c-73d3b210d223" /> 


<img width="4000" height="3000" alt="2 pc" src="https://github.com/user-attachments/assets/13b8fb91-4d81-421a-9dc6-44b0226f0b2a" />


### A solução? O reaproveitamento inteligente.
Desmontei os computadores, tirei todos os discos rígidos e resgatei mais um HD do meu notebook antigo. Comprei uma placa-mãe usada mais moderna, um processador **Intel Core i5 de 3ª geração**, **12GB de RAM** e suporte a **Rede Gigabit (1 Gbps)**. 

<img width="4000" height="3000" alt="3 pc" src="https://github.com/user-attachments/assets/de950c28-66d9-4b69-9a95-14860ff83449" />

<img width="4000" height="3000" alt="4pc" src="https://github.com/user-attachments/assets/8277a2f0-6d67-4795-84a4-b66bafc3a763" />

Montei o meu próprio "servidor Frankenstein" com o que eu tinha à disposição:
- 💾 **1x SSD NVMe** de 120GB (para o sistema base)
- 💾 **1x SSD SATA** de 256GB (com adaptador)
- 💾 **1x HD de Desktop** de 256GB
- 💾 **1x HD de Notebook** de 1TB
- 💾 **1x HD Externo** de 2TB (conectado via USB)

<img width="4000" height="3000" alt="montagem 1 " src="https://github.com/user-attachments/assets/4da6c023-9233-478b-bdf6-2cf86e16b53e" />


Escolhi o **Debian** pela sua estabilidade lendária. Para resolver o problema do meu tio, configurei uma pilha Docker isolada com **Nextcloud** e **Tailscale**, direcionada exclusivamente para o HD de 1TB de notebook. Assim, ele ganhou uma nuvem privada, acessível de qualquer lugar, enquanto eu mantive a gestão root de todo o hardware.

Nenhuma solução pronta no mercado (como CasaOS ou distros de NAS pré-configuradas) me daria a liberdade e o controle granular para gerenciar essa salada de discos e permissões do jeito que eu precisava. E para manter tudo isso rodando sem virar um escravo da manutenção, o servidor precisava ser **inteligente e autônomo**.

---

## 2: A Filosofia e o Nome "Alicerce"

O nome **Alicerce** vem exatamente da sua função na construção civil: a estrutura invisível que fica por baixo de tudo, garantindo que a casa não caia, não importa o peso do telhado.

O projeto foi pensado para ser a base de sustentação do hardware. Ele assume o trabalho pesado e chato de manutenção:
- Cida da saúde do gerenciador de pacotes (`APT`).
- Gerencia o espaço em disco para não estourar a capacidade.
- Executa reboots de forma segura (sem derrubar transferências ativas).
- Mantém o backup em dia (`Timeshift`) e o compartilhamento local de pé (`Samba`).

Se o usuário quiser apenas um servidor de arquivos simples, o Alicerce entrega pronto. Se ele quiser instalar um CasaOS, Plex ou uma pilha gigante de Docker por cima, o Alicerce continua atuando por baixo, de forma transparente e não invasiva.

<img width="4000" height="3000" alt="montagem 2" src="https://github.com/user-attachments/assets/feab8c5b-20cf-49f5-acc1-e473d8da7075" />

<img width="4000" height="3000" alt="montagem 3" src="https://github.com/user-attachments/assets/032d4bdc-7b88-4057-b38c-0e2bbee28e41" />

---

<img width="4000" height="3000" alt="codando 1" src="https://github.com/user-attachments/assets/592c35a6-968a-463b-b8c7-449c6e20d15a" />

<img width="4000" height="3000" alt="codando 2" src="https://github.com/user-attachments/assets/1e0802b9-92a4-4d4e-b302-df29a03cb39c" />

<img width="1040" height="1396" alt="codando 3" src="https://github.com/user-attachments/assets/810fa5f6-a6e1-41de-9abf-cb7a9ebf8597" />

---

## 3: O Futuro, Notificações no Telegram ou Outro meio 

Como sou o primeiro e principal usuário do Alicerce (assim como de outros projetos meus, como o `arch-update-full`), o desenvolvimento segue a filosofia *dogfooding*: eu evoluo o código conforme sinto necessidade no meu uso diário.


### Próximos Passos no Roadmap:
1. **Polimento e Tratamento de Erros:** Correção contínua de bugs, melhorias em casos de borda e relatórios da comunidade.
2. **Sistema de Alertas via Telegram:** Implementar um módulo de notificação automática. Se o script rodar às 2h da manhã de uma segunda-feira e encontrar uma falha de conexão ou erro crítico no `APT`, ele enviará uma mensagem direta no Telegram do usuário com o resumo do log e o local exato do erro.

---
## ** Meu servidor debian rodando com nextcloud**
<img width="1067" height="492" alt="nextclaud 1" src="https://github.com/user-attachments/assets/08ba3273-348b-45aa-824e-d9db06c0559d" />

<img width="1082" height="512" alt="nextclaud 2" src="https://github.com/user-attachments/assets/785a0d4f-41e9-4261-9940-a1f7a8cf63ff" />



**Desenvolvido com orgulho por:** Gustavo Gianeli (The Seventh)  
*Estudante de Ciência da Computação & Entusiasta de Infraestrutura Linux.*
