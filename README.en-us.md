 <img src="https://flagcdn.com/16x12/us.png" alt="US"> [English (US)](README.en-us.md) | <img src="https://flagcdn.com/16x12/br.png" alt="BR">   [Português (BR)](README.md)

 # 🏛️ ***My Home Server (Alicerce) V:1.0***

[History of the foundation](STORY.md) 

---

🛠️ **My Home Server (Alicerce)** was built to solve the maintenance and stability headaches of home server base systems. Instead of forcing a rigid ecosystem on you, it acts as a **resilient, self-managing foundation**: handling system health, network security, and core stability under the hood, so you can run whatever you want on top (Docker, CasaOS, media servers, etc.) with total peace of mind.

---
## Key Features

- **📋 Infrastructure & Setup**
  - **Modular Installer:** Automatic base environment setup, essential dependency installation, and system script management.
  - **Interactive CLI Dashboard:** A lightweight terminal interface to monitor services, run routines manually, and get quick diagnostics.
  
- **🔄 Automated Maintenance & Self-Healing**
  - **APT Self-Healing:** Automated detection and fixing for broken dependencies, orphan packages, and stuck package manager locks.
  - **Junk & Cache Cleanup:** Periodic cleanup of system clutter to keep things fast and free up disk space.
  
- **🛡️ Safety Guards & Downtime Prevention**
  - **Smart Reboot Safety (Network Verification):** Before allowing any auto-reboot, the script double-checks active network traffic (a 10s check followed by a 5s re-check). If active file transfers or bandwidth usage are detected, the reboot is safely canceled.
  - **Minimum Storage Buffer:** Constant monitoring of the main partition (`/`). Keeps at least **5GB of free disk space** guaranteed to prevent system crashes or data corruption from full drives.
  - **FIFO Log Rotation:** Automated log management that keeps only fresh records, preventing log files from silently eating up root space.
  
- **🌐 Networking & Sharing Services**
  - **Simplified Firewall Setup:** Direct UFW integration to easily manage and open essential network ports.
  - **Samba File Sharing (Home NAS):** Built-in module to quickly set up and manage local network shares.
 
- **🧱 Non-Intrusive Architecture**
  - **Zero Interference:** No forced containers or system hacks. Works smoothly alongside **CasaOS, Portainer, standalone Docker, or media servers**.
  - **100% ShellCheck Verified ✅:** All automation scripts undergo static code analysis to guarantee clean syntax, safe execution, and strict adherence to Shell best practices.

---

## **Prerequisites**

- A **Debian / Ubuntu** based OS (*minimal/server* installations recommended).
- A user account with `sudo` privileges or `root` access.
- An active internet connection to update and sync repositories.

---

## 🚀 Quick Install (One-Liner)

To clone the repository, set execution permissions, and kick off the automated setup, open your server terminal and paste the command below:

```bash
sudo apt update && sudo apt install -y git &&
git clone [https://github.com/GustavoGianeli/my-home-server-alicerce.git](https://github.com/GustavoGianeli/my-home-server-alicerce.git) &&
cd my-home-server-alicerce &&
chmod +x install-home-server.sh &&
sudo ./install-home-server.sh
```
---

### **𝓓𝓮𝓿𝓮𝓵𝓸𝓹𝓮𝓭 𝓫𝔂 𝓖𝓾𝓼𝓽𝓪𝓿𝓸 𝓖𝓲𝓪𝓷𝓮𝓵𝓲  (𝓣𝓱𝓮_ 𝓢𝓮𝓿𝓮𝓷𝓽𝓱)**  

**" 𝓓𝓮𝓿𝓮𝓵𝓸𝓹𝓮𝓭 𝓫𝔂 𝓣𝓱𝓮_ 𝓢𝓮𝓿𝓮𝓷𝓽𝓱 — 𝓦𝓱𝓮𝓻𝓮 𝓲𝓷𝓽𝓮𝓰𝓻𝓲𝓽𝔂 𝓶𝓮𝓮𝓽𝓼 𝓹𝓮𝓻𝓯𝓸𝓻𝓶𝓪𝓷𝓬𝓮. "**

---

## **Architecture Concept**
<img width="459" height="208" alt="arquitetura" src="https://github.com/user-attachments/assets/20c1b644-e692-4fd3-af39-d5f3e8c89125" />

--- 
## **System in Action**
<img width="1273" height="537" alt="instalação do servidor" src="https://github.com/user-attachments/assets/59589a2e-d8d0-4867-bc61-88f141aef48a" />

<img width="1375" height="939" alt="1" src="https://github.com/user-attachments/assets/0151d596-11c6-4d13-a176-83f3cee7cfa8" />

<img width="1375" height="939" alt="2" src="https://github.com/user-attachments/assets/c3897319-6a42-4451-a6f9-c07fa252f7a3" />

<img width="1375" height="939" alt="4" src="https://github.com/user-attachments/assets/418e0038-75a2-45f9-a45a-38a558987538" />

<img width="1375" height="939" alt="3" src="https://github.com/user-attachments/assets/b566081e-78b2-4724-972d-33bc4853de08" />

<img width="1375" height="939" alt="5" src="https://github.com/user-attachments/assets/41bbb988-152f-41b5-8124-3e62d205fefd" />

<img width="1375" height="939" alt="6" src="https://github.com/user-attachments/assets/76f436dd-e169-45a5-8bb7-ce58e6e46c29" />

<img width="1165" height="1263" alt="menu painel de controle" src="https://github.com/user-attachments/assets/ee8a41b9-e5fb-4ffb-8ce4-85669a842f56" />

--- 
## **System Icon**
<img width="512" height="512" alt="icone-my-home-server" src="https://github.com/user-attachments/assets/d79adc2f-86ac-42e7-b968-48683b0992ab" />

--- 
## **Demo Video**
https://github.com/user-attachments/assets/67c7bafd-6ae3-43d5-9a70-fcb66f7af01f

---
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Developed by: **Gustavo Gianeli (The Seventh)**

*Computer Science Student & Linux Infrastructure Enthusiast.*

⚠️ ​Language & Transparency Log: This documentation was originally created by me in Portuguese. Since I am a Computer Science student and currently an English beginner, about 80% of this README was translated and verified with AI assistance, then fully reviewed and adjusted by myself. Using technology every day to reach a global audience !⚠️
