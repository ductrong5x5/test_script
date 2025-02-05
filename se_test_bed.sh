#!/bin/bash
read -p "Enter server hostname:" server_host

read -p "Enter admin hostname:" admin_host
read -p "Enter admin IP address:" admin_ip
# Display ip address info
echo "==================================================="
echo "=====> Finding IP     (1)"
echo "==================================================="
ip a
nc -zv $admin_ip 22
nc -zv $admin_host 22

# Check if python3 is installed
echo ""
echo "==================================================="
echo "=====> Checking python3     (2)"
echo "==================================================="
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Installing.."
    
else
    echo "Python3 is installed"
fi

echo ""
echo "==================================================="
echo "=====> Checking python3-venv     (3)"
echo "==================================================="
    echo "python3-venv is already installed. Skipping installation."
    
echo ""
echo "==================================================="
echo "=====> Creating environment     (4)"
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
echo "=====> Activate environment     (5)"
echo "==================================================="
source nvflare-env/bin/activate

export PS1="(nvflare-env) $PS1"

# Install nvflare
echo ""
echo "==================================================="
echo "=====> Install nvflare     (6)"
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
read -p "7/Enter foldername of nvflare admin create :" it_fol
#read -p "Enter project name :" project_name
scp -r "$admin_host:/home/server/$it_fol"/workspace/test/prod_00/$server_host .

# Now connecting to server
echo ""
echo "==================================================="
echo "=====> Connecting to server    (10)"
echo "==================================================="
./$server_host/startup/start.sh
