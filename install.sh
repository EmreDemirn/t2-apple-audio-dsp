#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team

# Determine if running from source or installed package
if [ -d "config" ] && [ -d "firs" ]; then
    # Running from source directory
    CONFIG_DIR="config"
    FIRS_DIR="firs"
elif [ -d "/usr/share/t2-apple-audio-dsp/config" ] && [ -d "/usr/share/t2-apple-audio-dsp/firs" ]; then
    # Running from installed package
    CONFIG_DIR="/usr/share/t2-apple-audio-dsp/config"
    FIRS_DIR="/usr/share/t2-apple-audio-dsp/firs"
else
    echo "Error: Could not find config or firs directories"
    echo "Please run this script from the source directory or install the package"
    exit 1
fi

# List of supported models (space-separated)
# Add more models here as they become available
SUPPORTED_MODELS="MacBookPro16_1"

# Detect computer model
MODEL=$(cat /sys/class/dmi/id/product_name 2>/dev/null)

if [ -z "$MODEL" ]; then
    echo "Error: Could not detect computer model"
    exit 1
fi

# Convert comma to underscore in model name (e.g., MacBookPro16,1 -> MacBookPro16_1)
MODEL_DIR=$(echo "$MODEL" | tr ',' '_')

# Check if model is supported (compare with converted model name)
MODEL_SUPPORTED=false
for supported_model in $SUPPORTED_MODELS; do
    if [ "$MODEL_DIR" = "$supported_model" ]; then
        MODEL_SUPPORTED=true
        break
    fi
done

if [ "$MODEL_SUPPORTED" = false ]; then
    echo "Error: Model '${MODEL}' is not supported"
    echo "Supported models:"
    for supported_model in $SUPPORTED_MODELS; do
        echo "  - ${supported_model}"
    done
    exit 1
fi

if [ ! -d "${CONFIG_DIR}/${MODEL_DIR}" ]; then
    echo "Error: Configuration not found for model: ${MODEL}"
    echo "Available models:"
    ls -d ${CONFIG_DIR}/*/ 2>/dev/null | sed 's|.*/||' || echo "  (none found)"
    exit 1
fi

echo "Detected model: ${MODEL} (using directory: ${MODEL_DIR})"
echo "Installing DSP config for ${MODEL}"
echo "Copying speakers config and mic config to /etc/pipewire/pipewire.conf.d"
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo cp ${CONFIG_DIR}/${MODEL_DIR}/*.conf /etc/pipewire/pipewire.conf.d
echo "Copying FIRs to /usr/share/pipewire/devices/${MODEL_DIR}"
sudo mkdir -p /usr/share/pipewire/devices/${MODEL_DIR}
sudo cp ${FIRS_DIR}/${MODEL_DIR}/*.wav /usr/share/pipewire/devices/${MODEL_DIR}/ 2>/dev/null
sudo chmod o+r /usr/share/pipewire/devices/${MODEL_DIR}/*.wav 2>/dev/null
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."