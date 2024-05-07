# Use an official Ubuntu 18.04 runtime as a parent image
FROM ubuntu:18.04

# Set the maintainer label
LABEL maintainer="you@example.com"

# Set environment variables to make the container non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system-wide dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    build-essential \
    curl \
    git-core \
    htop \
    pkg-config \
    unzip \
    gcc \
    g++ \
    make \
    libgl1-mesa-glx \
    && apt-get clean

# Install Anaconda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/anaconda \
    && rm ~/anaconda.sh
ENV PATH=/opt/anaconda/bin:${PATH}

COPY ./environment.yml ./app/environment.yml

# Set the working directory to /app
WORKDIR /app

# Create the environment using the environment.yml file
RUN conda env create -f environment.yml

# Copy the current directory contents (where the Dockerfile lives) into the container at /app
COPY . .




# Make RUN commands use the new environment
SHELL ["/opt/anaconda/bin/conda", "run", "-n", "transfer_chess", "/bin/bash", "-c"]

RUN python setup.py install

# The code to run when container is started
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "transfer_chess", "python", "2-training/train_transfer.py", "2-training/final_config.yaml"]
