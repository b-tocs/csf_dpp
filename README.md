# B-Tocs Container Service Farm DPP

B-Tocs Container Service Farm based on Debian, Podman, Portainer.
This is a reference container host stack to demonstrate B-Tocss container scenarios.


## Installation

### 1. Prepare server

####  1.1 First ssh login

Login as root to a new installed Debian 12 Linux Server.

```bash
apt-get update && apt-get upgrade -y
```

If popups appear - select new versions of the maintainers.

#### 1.2 Install git

```bash
apt-get install git -y
```

#### 1.3 Clone csf_dpp repository
```bash
cd ~
git clone https://github.com/b-tocs/csf_dpp.git
```

#### 1.4 Copy Scripts

```bash
cd csf_dpp
cp *.sh ~
```

#### 1.5 Make scripts executable
```bash
cd ~
chmod +x *.sh
```

#### 1.6 Install this DPP container service stack
```bash
cd ~
./install_dpp.sh
```

You will be asked for a Fullname of the new user `container`. Enter "Container" and leave the other fields empty.
Confirm with `Y`.

#### 1.7 check portainer is running
```bash
podman ps
```

 A portainer instance should be running now.

### 1.8 Check Portainer 

- Open https://<yourip>:9443 with a browser
- Confirm unsecure connection


### 2. Portainer

#### 2.1 First login

- Open https://<yourip>:9443 with a browser
- Confirm unsecure connection
- Enter a new administrator email and a strong password
- Create User
- Select `Get Started`
- Select the displayed environment

#### 2.2 Check volumes and networks
- Enter `Volumes`
    - Select `portainer_data` 
    - Check the storage location: `/var/lib/containers/storage/volumes/portainer_data`
- Enter `Networks` and check the networks `intern` and `extern`

#### 2.3 Portainer update

```bash
cd ~
./portainer_update.sh
podman ps
```

Your portainer should be running.

#### 2.4 Stop and backup data

If you want to make a manually backup the container should be stopped before.

```bash
podman stop portainer
tar cvzf ~/backup_portainer_data.tgz /var/lib/containers/storage/volumes/portainer*
podman start portainer
```


#### 2.5 Reboot and check again
```bash
apt-get update && apt-get upgrade -y
reboot
```

After reboot login again and check if portainer is running.



### 2. Configure Containers and stacks

### 3. Secure the server