#!/bin/bash

read -p "Enter server hostname:" server_host

read -p "Enter IT lead hostname:" it_host
read -p "Enter IT lead IP address:" it_ip

read -p "Enter admin hostname:" admin_host
read -p "Enter admin IP address:" admin_ip

# Display ip address info
echo "==================================================="
echo "=====> Finding IP     (1)"
echo "==================================================="
ih=$(hostname -I | awk '{print $1}')
echo "hostname: $server_host"
echo "IP Address: $ih"
nc -zv $it_ip 22
nc -zv $it_host 22
#nc -zv $admin_ip 22
#nc -zv $admin_host 22

# Check if python3 is installed
echo ""
echo "==================================================="
echo "=====> Checking python3     (2)"
echo "==================================================="
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Installing.."
    sudo apt update && sudo apt install -y python3
else
    echo "Python3 is installed"
fi

# Update apt
echo ""
echo "==================================================="
echo "=====> Update apt     (3)"
echo "==================================================="
sudo apt update

# Check if python3-venv is installed
echo ""
echo "==================================================="
echo "=====> Checking python3-venv     (4)"
echo "==================================================="
if ! dpkg -l | grep -q python3-venv; then
    echo "python3-venv is not installed. Installing.."
    sudo apt-get install python3-venv -y
else
    echo "python3-venv is already installed. Skipping installation."
fi

# Create the Python3 virtual environment for nvflare
echo ""
echo "==================================================="
echo "=====> Creating environment     (5)"
echo "==================================================="
if [ ! -d "nvflare-env" ]; then
    echo "Creating Python virtual environment 'nvflare-env'..."
    python3 -m venv nvflare-env
else
    echo "Virtual environment already exists."
fi

# Activate the environment
echo ""
echo "==================================================="
echo "=====> Activate environment     (6)"
echo "==================================================="
source nvflare-env/bin/activate

export PS1="(nvflare-env) $PS1"

# Check if pip is up-to-date before upgrading
echo ""
echo "==================================================="
echo "=====> Checking pip and setuptools     (7)"
echo "==================================================="

python3 -m pip install -U pip 
python3 -m pip install -U setuptools  

# Install nvflare
echo ""
echo "==================================================="
echo "=====> Install nvflare     (8)"
echo "==================================================="

# Check if nvflare is installed and is the latest version
if pip show nvflare &> /dev/null; then
    echo "nvflare is already installed. Checking for updates..."
    python3 -m pip install -U nvflare
else
    echo "nvflare is not installed. Installing..."
    python3 -m pip install nvflare
fi

# Copy folder from admin client
echo ""
echo "==================================================="
echo "=====> Copy folder from admin client    (9)"
echo "==================================================="
read -p "7/Enter foldername of nvflare IT lead create :" it_fol
read -p "Enter project name :" project_name
scp -r "$it_host:/home/server/$it_fol"/workspace/$project_name/prod_00/$server_host .

# Now connecting to server
echo ""
echo "==================================================="
echo "=====> Connecting to server    (10)"
echo "==================================================="
./$server_host/startup/start.sh


