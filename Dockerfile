# Use an official Ubuntu 18.04 runtime as a parent image
FROM ubuntu:18.04

# Set the maintainer label
LABEL maintainer="donaldflynn@hotmail.co.uk"

# Set environment variables to make the container non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system-wide dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    build-essential \
    gcc \
    make \
    screen \
    libgl1-mesa-glx \
    && apt-get clean

# Install Anaconda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/anaconda \
    && rm ~/anaconda.sh
ENV PATH=/opt/anaconda/bin:${PATH}

COPY environment.yml ./app/environment.yml

# Install wine
RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y wine64 wine32

# Set the working directory to /app
WORKDIR /app

# Create the environment using the environment.yml file
RUN conda env create -f environment.yml

# Set up trainingdata-tool
COPY /ImportantTools/trainingdata-tool.sh /bin/trainingdata-tool
RUN chmod +x /bin/trainingdata-tool

# Set up pgn-extract tool
COPY /ImportantTools/pgn-extract-22-11.tgz /app/ImportantTools/pgn-extract-22-11.tgz
RUN cd /app/ImportantTools && \
    tar -xvzf pgn-extract-22-11.tgz && \
    cd pgn-extract/ && \
    make && \
    cp pgn-extract /bin

RUN apt-get install -y screen

COPY src .

RUN python setup.py install


# The code to run when container is started
#ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "transfer_chess", "python", "2-training/train_transfer.py", "2-training/final_config.yaml"]
