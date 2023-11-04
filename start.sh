#!/bin/bash
gunicorn app:app --workers 1 --threads 1 --bind 0.0.0.0:$PORT --timeout 86400 & rclone serve http --addr=0.0.0.0:$PORT --config=rclone.conf $DRIVE_NAME: & python3 update.py & python3 main.py
