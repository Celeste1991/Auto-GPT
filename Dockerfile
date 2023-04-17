# Use an official Python base image from the Docker Hub
FROM python:3.11-slim

# Install git
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list 
RUN sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list 
RUN apt-get update && apt-get upgrade
RUN apt-get -y install git chromium-driver

# Set environment variables
ENV PIP_NO_CACHE_DIR=yes \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create a non-root user and set permissions
RUN useradd --create-home appuser
WORKDIR /home/appuser
RUN chown appuser:appuser /home/appuser
USER appuser

# Copy the requirements.txt file and install the requirements
COPY --chown=appuser:appuser requirements-docker.txt .
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --no-cache-dir --user -r requirements-docker.txt 

# Copy the application files
COPY --chown=appuser:appuser autogpt/ ./autogpt

# Set the entrypoint
ENTRYPOINT ["python", "-m", "autogpt"]
