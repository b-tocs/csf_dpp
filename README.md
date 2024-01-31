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
- Enter `Images`

#### 2.3 Load container image

- Go to the [Docker Hub](https://hub.docker.com)
- Search for `froodle s-pdf` 
- Select `froodle/s-pdf` or open [direct...](https://hub.docker.com/r/frooodle/s-pdf)  
- Copy pull command `docker pull frooodle/s-pdf`
- Enter Portainer ´Images´ section
- Enter for `Image`: `frooodle/s-pdf` (without `docker pull`)
- Select `Pull the image` and wait
- See the details for the new image


#### 2.4 Start first container
- Go to portainer section `container`
- select `Add container`
- Enter `spdf` as name
- Enter `frooodle/s-pdf` in field `Image`
- Open `Manual network port publishing`
- Enter `8080` in the left field and `8080` in the right field
- See the areas `Volumes`, `Network` and others..-
- Under `Network` select `extern`
- Under `Restart policy` choose `Unless stopped`
- Select `Deploy the container` and wait
- check the new container `spdf` in `Containers`
- check column `Published Ports`: Port 8080 is open the the internet!
- Open http://<yourip>:8080 and see `Stirling PDF` Web toolbox



#### 2.5 Stop and backup data

If you want to make a manually backup the container should be stopped before.

```bash
podman stop portainer
tar cvzf ~/backup_portainer_data.tgz /var/lib/containers/storage/volumes/portainer*
podman start portainer
```


#### 2.6 Portainer update

- check the current portainer version - left bottom
- run the portainer update script 

```bash
cd ~
./portainer_update.sh
podman ps
```

- check if portainer is running
- check the current portainer version



#### 2.7 Reboot and check again
```bash
apt-get update && apt-get upgrade -y
reboot
```

After reboot login again and check if portainer is running.





### 3. Configure container stacks

### 4. Secure the server