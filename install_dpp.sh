
# ========= prepare server - update, install
# update and install tools
echo "Update and prepare server..."
apt-get update && apt-get upgrade -y
apt-get install btop slirp4netns -y
echo "Server prepared."

# ========= prepare and install podman
echo "Install podman ..."
# create a container user for uid/gid 1000/1000
addgroup --gid 1000 container
adduser --uid 1000 --gid 1000 --disabled-login container

# install newest podman version (workaround)
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg] https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Testing/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:unstable.list > /dev/null

apt-get -y install podman
echo "podman installed"
podman --version


# ========== install portainer
echo "Install podman ..."
podman pull portainer/portainer-ce
podman volume create portainer_data

podman run -d -p 9443:9443 --privileged --restart=always -v portainer_data:/data -v /run/podman/podman.sock:/var/run/docker.sock:Z --name portainer portainer/portainer-ce

echo "portainer installed."
podman ps
