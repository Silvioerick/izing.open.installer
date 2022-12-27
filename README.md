Interactive CLI tool for installing and updating Izing.io

### download & setup

Firstly, you need to download it:


```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
git clone https://github.com/Silvioerick/izing.io-installer.git
```

Now, all you gotta do is making it executable:

```bash
sudo chmod +x ./izing.io-installer/izing
```

### usage

After downloading and making it executable, you need to **navigate into** the installer directory and **run the script with sudo**:

```bash
cd ./izing.io-installer
```

```bash
sudo ./izing
```
