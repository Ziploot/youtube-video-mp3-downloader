#!/bin/bash
# ZipLoot YT Downloader — 1-Click Deployment (Linux)

echo "========================================================"
echo "  ZipLoot YouTube Downloader 1-Click Deployment (Linux) "
echo "========================================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python3 is not installed!"
    echo "Please install Python3 using your package manager (e.g., sudo apt install python3)"
    exit 1
fi

# Check if python3-venv is installed (Debian/Ubuntu specific check)
if command -v apt-get &> /dev/null; then
    if ! dpkg -l | grep -q "python3-venv"; then
        echo "[INFO] Installing python3-venv package..."
        sudo apt-get update && sudo apt-get install -y python3-venv
    fi
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "[INFO] Creating Python Virtual Environment (venv)..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment!"
        exit 1
    fi
fi

# Activate virtual environment and install dependencies
echo "[INFO] Activating virtual environment..."
source venv/bin/activate

echo "[INFO] Upgrading pip..."
python3 -m pip install --upgrade pip >/dev/null 2>&1

echo "[INFO] Installing required dependencies (Flask, yt-dlp nightly)..."
pip3 install -U -r requirements.txt --pre
if [ $? -ne 0 ]; then
    echo "[ERROR] Dependency installation failed!"
    exit 1
fi

# Install FFmpeg if not present on system
if ! command -v ffmpeg &> /dev/null; then
    echo "[WARNING] FFmpeg is not installed on your system! Audio/Video merging will not work."
    if command -v apt-get &> /dev/null; then
        echo "[INFO] Attempting to install FFmpeg automatically..."
        sudo apt-get update && sudo apt-get install -y ffmpeg
    else
        echo "Please install FFmpeg manually using your distribution's package manager."
    fi
fi

echo ""
echo "========================================================"
echo "  [SUCCESS] Deployment complete! Launching server...    "
echo "  Open: http://localhost:5000 in your browser.          "
echo "========================================================"
echo ""

# Open browser if graphical interface is available
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:5000 &
fi

python3 app.py
