### 📡 PXE Boot Server – Ansible + Docker Compose

This project provisions a PXE boot server using Ansible and modern Docker Compose (v2). It supports booting Proxmox VE on bare-metal machines (e.g. Lenovo M92) without requiring local installation media or direct input devices.

---

### 🛠️ Features

- 📁 Folder structure for `http` and `tftp`
- 📦 iPXE bootloaders (`undionly.kpxe`, `ipxe.efi`) from [boot.ipxe.org](https://boot.ipxe.org/)
- 🖥️ PXE boot menu with:
  - Proxmox VE install
  - Rescue Shell
- 🧩 Dockerized `httpd` and `tftp` containers
- 🪄 Fully automated via Ansible

---

### 🚀 Quick Start

```bash
ansible-playbook ansible/playbook.yml
```

---

### 🧰 Requirements

- WSL or native Linux
- Docker + Docker Compose v2
- Ansible 2.15+
- Internet access to download PXE bootloaders

---

### 🌐 Network Notes

- The PXE HTTP server runs on port `8080`
- The TFTP server runs on port `69/udp`
- You must configure your DHCP server (e.g. UDM Pro) to serve:
  - BIOS clients: `undionly.kpxe`
  - UEFI clients: `ipxe.efi`
  - 