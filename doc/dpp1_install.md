# B-Tocs Container Service Farm DPP

B-Tocs Container Service Farm based on Debian, Podman, Portainer.
This is a reference container host stack to demonstrate B-Tocss container scenarios.


## 1. Installation

###  1.1 First ssh login

Login as root to a new installed Debian 12 Linux Server.

```bash
apt-get update && apt-get upgrade -y
```

If popups appear - select new versions of the maintainers.

### 1.2 Install git

```bash
apt-get install git -y
```

### 1.3 Clone csf_dpp repository
```bash
cd ~
git clone https://github.com/b-tocs/csf_dpp.git
```

### 1.4 Copy Scripts

```bash
cd csf_dpp
cp *.sh ~
```

### 1.5 Make scripts executable
```bash
cd ~
chmod +x *.sh
```

### 1.6 Install this DPP container service stack
```bash
cd ~
./install_dpp.sh
```

You will be asked for a Fullname of the new user `container`. Enter "Container" and leave the other fields empty.
Confirm with `Y`.

### 1.7 check portainer is running
```bash
podman ps
```

 A portainer instance should be running now.

### 1.8 Check Portainer 

- Open https://YOUR_IP:9443 with a browser
- Confirm unsecure connection

