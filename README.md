# B-Tocs Container Service Farm - Debian, Podman, Portainer

Container Service Farm based on Debian, Podman, Portainer


## Installation

### 1. Login as root to a new installed Debian 12 Linux Server

```bash
apt-get update && apt-get upgrade -y
```

If a popup appears - select install new version of maintainer.

### 2. Install git

```bash
apt-get install git -y
```

### 3. Clone csf_dpp repository
```bash
cd ~
git clone https://github.com/b-tocs/csf_dpp.git
```

### 4. Copy Scripts

```bash
cd csf_dpp
cp *.sh ~
```

### 5. Make scripts executable
```bash
cd ~
chmod +x *.sh
```

### 6. Install this DPP container service stack
```bash
cd ~
./install_dpp.sh
```

You will be asked for a Fullname of the new user `container`. Enter "Container" and leave the other fields empty.
Confirm with `Y`.

### 7. check portainer is running
```bash
podman ps
```

### 8. Login to portainer and set new password

- Open https://<yourip>:9443 with a browser
- Enter a new administrator email and a strong password

### 9. Reboot and check
```bash
apt-get update && apt-get upgrade -y
reboot
```

### 10. Work with the stack

Your server is ready for serving cool container stuff. Enjoy!