# fusioncloud-infra
# PXE Boot Server for Proxmox Provisioning

This PXE server allows headless, automated Proxmox installs via LAN.

## Setup

1. Download and extract `proxmox-ve.iso` into `http/` and `tftp/boot/`
2. Update `pxelinux.cfg/default` with PXE Server's IP
3. Run Ansible:
```bash
ansible-playbook ansible/playbook.yml
```
4. Boot your Proxmox node via network (PXE/Legacy BIOS)