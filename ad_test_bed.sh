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

