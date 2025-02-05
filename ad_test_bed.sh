#!/bin/bash

# Display ip address info
echo "==================================================="
echo "=====> Finding IP     (1)"
echo "==================================================="
ip a

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

# Now creating project.yml file
echo ""
echo "==================================================="s
echo "=====> Create project.yml file    (7)"
echo "==================================================="
nvflare provision

# Now modify project.yml file
echo ""
echo "==================================================="s
echo "=====> Modify project.yml file    (8)"
echo "==================================================="
# Path to the project.yml file
PROJECT_YML="project.yml"

# Step 1: Prompt for the project name
read -p "What is the project name that you want: " project_name

# Step 2: Modify the project name dynamically using the input
sed -i "s/name: example_project/name: $project_name/" "$PROJECT_YML"

# Step 3: Modify admin section (name, type, and org)
read -p "What is the admin name you want(default: admin@nvidia.com) : " admin_name
sed -i "s/name: admin@nvidia.com/name: $admin_name/" "$PROJECT_YML"
read -p "What is the server name you want(example: wormbat35) : " server_host
sed -i "s/server1/$server_host/" "$PROJECT_YML"

read -p "What is the organization name you want(default: nvdia) : " org
sed -i "s/org: nvidia/org: $org/" "$PROJECT_YML"

# Step 4: Ask how many additional clients to create (starting from site-3)
read -p "How many additional clients do you want? " CLIENT_COUNT

# Step 5: Add clients starting from site-3
for i in $(seq 3 $((2 + CLIENT_COUNT))); do
    CLIENT_NAME="site-$i"
    sed -i "/participants:/a \ \ - name: $CLIENT_NAME\n\ \ \ \ type: client\n\ \ \ \ org: ornl" "$PROJECT_YML"
done

read -p "What is the port to client (default:8002) : " p_c
sed -i "s/8002/$p_c/" "$PROJECT_YML"
read -p "What is the port to admin (default:8003) : " p_a
sed -i "s/8003/$p_a/" "$PROJECT_YML"

echo "Changes made to $PROJECT_YML"

# Now create start-up kit
echo ""
echo "==================================================="s
echo "=====> Do provision, generate startup kit    (9)"
echo "==================================================="

nvflare provision -p project.yml
echo ""
echo "==================================================="
echo "=====> All file/ startup kit is generated, please  "
echo "=====> tell admin, client, server to get file      "  
echo "==================================================="
