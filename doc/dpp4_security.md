# B-Tocs Container Service Farm DPP

B-Tocs Container Service Farm based on Debian, Podman, Portainer.
This is a reference container host stack to demonstrate B-Tocss container scenarios.

## 4. Security

### 4.1 Published ports = Security risk

- in the current situation all containers have a direct connection to the internet
- https are not available, except for portainer
- many possibilities for attackers

```mermaid
flowchart TD

        subgraph Podman-Host
            
            subgraph External Net
                port_22["22 - ssh"]
                port_9443["9443 - portainer admin"]
                port_5000["5000 - LibreTranslate"]
                port_8080["8080 - Stirling PDF"]
                port_8069["8069 - Odoo"]
            end

            subgraph Podman
                portainer((Portainer))
                net_intern{{Internal Net}}

                subgraph stack_spdf
                    container1_1(("Stirling PDF"))
                end
                port_8080-->container1_1

                subgraph stack_libre
                    container2_1(("LibreTranslate"))
                end
                port_5000-->container2_1
                container2_1-->net_intern

                subgraph stack_odoo
                    container3_1(("Odoo UI"))
                    container3_2(("Odoo DB"))
                end
                container3_1-->container3_2
                port_8069-->container3_1
                container3_1-->net_intern
            end
        end

        port_9443-->portainer
```


### 4.2 Hide services ports

In this step the ports of the container services are hidden. In die next steps we build a new way to reach this ports.

#### 4.2.1 hide the s-pdf container

- Go to the portainer stack `spdf` and open the stack config
- The current config should be this:

```yaml
version: '3.3'
services:
  stirling-pdf:
    image: frooodle/s-pdf:latest
    ports:
      - '8080:8080'
    volumes:
      - /location/of/trainingData:/usr/share/tesseract-ocr/5/tessdata #Required for extra OCR languages
      - /location/of/extraConfigs:/configs
#      - /location/of/customFiles:/customFiles/
#      - /location/of/logs:/logs/
    environment:
      - DOCKER_ENABLE_SECURITY=false
```

- add the `networks` section at the beginning for the external network `intern`
- disable the service `ports` section 
- add a service `expose` section
- add a service `networks` section to link the container to the external defined network `intern`
- the new config should be this:

```yaml
version: '3.3'

networks:
  intern:
    external: true

services:
  stirling-pdf:
    image: frooodle/s-pdf:latest
    #ports:
    #  - '8080:8080'
    expose:
      - "8080"
    networks:
      - intern
    volumes:
      - /location/of/trainingData:/usr/share/tesseract-ocr/5/tessdata #Required for extra OCR languages
      - /location/of/extraConfigs:/configs
#      - /location/of/customFiles:/customFiles/
#      - /location/of/logs:/logs/
    environment:
      - DOCKER_ENABLE_SECURITY=false
```

- deploy the changes
- see the portainer container list: there are no published ports for the container `spdf-stirling-pdf-1`

#### 4.2.2 hide the s-pdf container

- Go to the portainer stack `libre` and open the stack config
- The current config should be this:

```yaml
version: "3"

networks:
  default:
    internal: true
  intern:
    external: true
  extern:
    external: true

volumes:
  libre_db:
  libre_home:

services:
  libre: 
    image: libretranslate/libretranslate:latest
    restart: unless-stopped
    networks:
      - intern
      - extern
    ports:
      - "5000:5000"
    expose:
      - "5000"
    environment:
      #- LT_DEBUG=True
      - LT_FRONTEND_LANGUAGE_SOURCE=de
      - LT_FRONTEND_LANGUAGE_TARGET=en
      #- LT_API_KEYS=True
    volumes:
      - libre_db:/app/db
      - libre_home:/home/libretranslate
```

- The service is already linked to the external networks: `intern` and `extern`
- The external network is required for downloading machine learning files
- disable the service `ports` section to hide port `5000`
- the new config should be this:

```yaml
version: "3"

networks:
  default:
    internal: true
  intern:
    external: true
  extern:
    external: true

volumes:
  libre_db:
  libre_home:

services:
  libre: 
    image: libretranslate/libretranslate:latest
    restart: unless-stopped
    networks:
      - intern
      - extern
    #ports:
    #  - "5000:5000"
    expose:
      - "5000"
    environment:
      #- LT_DEBUG=True
      - LT_FRONTEND_LANGUAGE_SOURCE=de
      - LT_FRONTEND_LANGUAGE_TARGET=en
      #- LT_API_KEYS=True
    volumes:
      - libre_db:/app/db
      - libre_home:/home/libretranslate
```

- deploy the changes
- see the portainer container list: there are no published ports for the container `libre-libre-1`

#### 4.2.3 hide the odoo containers

- Go to the portainer stack `odoo` and open the stack config
- The current config should be this:

```yaml
version: '3'

networks:
  default:
    internal: true
  intern:
    external: true
  extern:
    external: true

volumes:
  odoo_web_data:
  odoo_web_config:
  odoo_web_addons:
  odoo_db_data:

services:
  db:
    image: postgres:16
    restart: unless-stopped    
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - odoo_db_data:/var/lib/postgresql/data/pgdata
    networks:
      - default
    expose:
      - "5432"
    #ports:
    #  - "5432:5432"

  web:
    image: odoo:17
    restart: unless-stopped
    depends_on:
      - db
    environment:
      - HOST=db
      - USER=${POSTGRES_USER}
      - PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - odoo_web_data:/var/lib/odoo
      - odoo_web_config:/etc/odoo
      - odoo_web_addons:/mnt/extra-addons
    networks:
      - default
      - intern
      - extern
    expose:
      - "8069"
    ports:
      - "8069:8069"
```

- The service `db` is only linked to an own network `default` and publish no ports 
- The service `web` is already linked to the external networks: `defdault`, `intern` and `extern`
- The external network is required for downloading odoo extensions and updates - this is outbound traffic and allowed
- Direct inbound network traffic to the odoo service should be blocked
- disable the service `ports` section to hide port `5000`
- the new config should be this:

```yaml
version: '3'

networks:
  default:
    internal: true
  intern:
    external: true
  extern:
    external: true

volumes:
  odoo_web_data:
  odoo_web_config:
  odoo_web_addons:
  odoo_db_data:

services:
  db:
    image: postgres:16
    restart: unless-stopped    
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - odoo_db_data:/var/lib/postgresql/data/pgdata
    networks:
      - default
    expose:
      - "5432"
    #ports:
    #  - "5432:5432"

  web:
    image: odoo:17
    restart: unless-stopped
    depends_on:
      - db
    environment:
      - HOST=db
      - USER=${POSTGRES_USER}
      - PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - odoo_web_data:/var/lib/odoo
      - odoo_web_config:/etc/odoo
      - odoo_web_addons:/mnt/extra-addons
    networks:
      - default
      - intern
      - extern
    expose:
      - "8069"
    #ports:
    #  - "8069:8069"
```

- deploy the changes
- see the portainer container list: there are no published ports for the container `odoo-web-1`


#### 4.2.5 New port status

- All ports of the services are deactivated now
- There are no way to reach the tack services from the outside 

```mermaid
flowchart TD

        subgraph Podman-Host
            
            subgraph External Net
                port_22["22 - ssh"]
                port_9443["9443 - portainer admin"]
            end

            subgraph Podman
                portainer((Portainer))
                net_intern{{Internal Net}}

                subgraph stack_spdf
                    container1_1(("Stirling PDF"))
                end
                container1_1-->net_intern

                subgraph stack_libre
                    container2_1(("LibreTranslate"))
                end
                container2_1-->net_intern

                subgraph stack_odoo
                    container3_1(("Odoo UI"))
                    container3_2(("Odoo DB"))
                end
                container3_1-->container3_2
                container3_1-->net_intern
            end
        end

        port_9443-->portainer
```


## 4.3 Nginx Proxy Manager

### 4.3.1 Prepare domain names

- For the next steps a name resolution is required
- The best option is an external or internal DNS and new hostnames for the our services
- The following names are required: spdf, translate, odoo, npm
- As a workaround the local hosts file can be changed to sinmulate DNS resolution

#### Workaround Windows local hosts
- The windows hosts file is located in C:\Windows\System32\drivers\etc
- Modify this file as administrator and add a few lines at the end

```cfg
# B-Tocs Container Service Farm Demo
<your_ip>	  mycsf
<your_ip>		translate.mycsf
<your_ip>		spdf.mycsf
<your_ip>		odoo.mycsf
<your_ip>		npm.mycsf 
```

<yourip> has to be replaced with the IP of your server, e.g. "192.168.0.100".



### 4.3.2 New stack 'nginxpm' for Nginx Proxy Manager
- Go to [NginxPM docker home](https://hub.docker.com/r/jc21/nginx-proxy-manager)
- Login to portainer 
- Add a new portainer stack `nginxpm`
- Copy the following compose template and paste it to your stack

```yaml
version: "3"

networks:
  default:
    internal: true
  intern:
    external: true
  extern:
    external: true

volumes:
  nginxpm_data:
  nginxpm_letsencrypt: 

services:
  ui:
    image: jc21/nginx-proxy-manager
    restart: unless-stopped
    networks:
      - intern
      - extern
    ports:
      - "80:80"
      - "443:443"
      - "9081:81"
    expose:
      - "80"
      - "81"
      - "443" 
    volumes:
      - nginxpm_data:/data
      - nginxpm_letsencrypt:/etc/letsencrypt 
```

- Deploy the stack
- The new stack has two new volumes "nginxpm*" relevant for backup
- See the new stack and the published ports 80, 443, 9081
- Go to portainer container section and see all open ports


```mermaid
flowchart TD

        subgraph Podman-Host
            
            subgraph External Net
                port_22["22 - ssh"]
                port_80["80 - http"]
                port_443["443 - https"]
                port_9081["9081 - nginxpm admin"]
                port_9443["9443 - portainer admin"]
            end

            subgraph Podman
                portainer((Portainer))
                net_intern{{Internal Net}}

                subgraph stack_spdf
                    container1_1(("Stirling PDF"))
                end
                container1_1-->net_intern
                subgraph stack_libre
                    container2_1(("LibreTranslate"))
                end
                container2_1-->net_intern

                subgraph stack_odoo
                    container3_1(("Odoo UI"))
                    container3_2(("Odoo DB"))
                end
                container3_1-->container3_2
                container3_1-->net_intern

                subgraph stack_nginxpm
                    container4_1(("NginxPM"))
                end
                container4_1-->net_intern
                

            end
        end

        port_9443-->portainer
        port_9081-->container4_1
        port_443-->container4_1
        port_80-->container4_1        
```

- From a theoretical point of view there is a way from the outside internet to the stack services through the NginxPM container
- NginxPM is a reverse proxy and works as a firewall - without configuration no access

### 4.3.3 First Login to NginxPM

- The setup information for the Nginx Proxy Manager can be found [here](https://nginxproxymanager.com/setup/)
- Open http://<yourip>:9081 or http://mycsf:9081 with a web browser
- Enter `admin@example.com` as email address and `changeme` for password
- In the following popup enter at least a new email
- In the next popup "Change Password" enter `changeme` as old password and a strong new password
- Save
- Go to `Settings` and change "Default Site" to option "404 page"

### 4.3.4 Add proxy hosts for services

#### 4.3.4.1 Stack spdf

- Within the NginxPM UI to to "Hosts" and "Proxy Hosts"
- Select "Add Proxy Host"
- Enter the following information in area "Details"

|Field                    | Value                | Remarks                                  |
| ----                    | ----                 | ----                                     |
| Domain Names            | spdf.mycsf           | depends on 4.3.1, use your name instead  |
| Schheme                 | http                 |                                          |
| Forward Hostname / IP   | spdf-stirling-pd     | = the hostname of the container          |
| Forward Port            | 8080                 | = the exposed port of the container      |
| Cache Assets            | activated            | optional                                 |
| Block Common Exploits   | activated            | optional                                 |
| Websockets support      | activated            | optional                                 | 
| Access List             | Publicity Accessible | can be changed later                     |

- Open http://spdf.mycsf/ or your dns name for spdf service in a browser
- The Stirling PDF UI should appear.


