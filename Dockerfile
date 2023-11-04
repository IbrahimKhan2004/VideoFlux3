FROM python:3.9

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -qq update && apt -qq install -y ffmpeg wget unzip p7zip-full curl busybox aria2

COPY . /app
WORKDIR /app
RUN chmod 777 /app

RUN wget https://rclone.org/install.sh
RUN chmod 777 ./install.sh
RUN bash install.sh

RUN pip3 install --no-cache-dir -r requirements.txt

ENV PORT=8080
EXPOSE 8080

# Add the commands directly here
CMD ["gunicorn", "app:app", "--workers", "1", "--threads", "1", "--bind", "0.0.0.0:$PORT", "--timeout", "86400", "&", "rclone", "serve", "http", "--addr=0.0.0.0:$PORT", "--config=rclone.conf", "$DRIVE_NAME:", "&", "python3", "update.py", "&", "python3", "main.py"]
