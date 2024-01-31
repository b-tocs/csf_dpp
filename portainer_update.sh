podman pull docker.io/portainer/portainer-ce
podman stop portainer
podman rm portainer
podman run -d -p 9443:9443 --privileged --restart=always -v portainer_data:/data -v /run/podman/podman.sock:/var/run/docker.sock:Z --name portainer portainer/portainer-ce