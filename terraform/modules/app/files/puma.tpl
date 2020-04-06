[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=mikh_androsov
Environment=DATABASE_URL=${mongo_ip}
WorkingDirectory=/home/mikh_androsov/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
