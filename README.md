Interactive CLI tool for installing and updating Izing.io

### download & setup

Firstly, you need to download it:


```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
git clone https://github.com/Silvioerick/izing.io.installer-master.git
```

Now, all you gotta do is making it executable:

```bash
sudo chmod +x ./izing.io.installer-master/izing
```

### usage

After downloading and making it executable, you need to **navigate into** the installer directory and **run the script with sudo**:

```bash
cd ./izing.io.installer-master
```

```bash
sudo ./izing
```

### manual modifications

Nginx configuration

/etc/nginx/sites-available/izing.io-frontend

line 13 include:

    try_files  $uri $uri/ /index.html;

### Comments

redis and postgresql password: password
Rabbitmq password: guest / guest
User: Deploy Password: password

