# Use an official Ubuntu 18.04 runtime as a parent image
FROM ubuntu:18.04

# Set the maintainer label
LABEL maintainer="donaldflynn@hotmail.co.uk"

# Set environment variables to make the container non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install system-wide dependencies
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        build-essential \
        gcc \
        make \
        libgl1-mesa-glx \
        wine64 \
        wine32 \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Anaconda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/anaconda \
    && rm ~/anaconda.sh \
    && echo 'export PATH="/opt/anaconda/bin:$PATH"' >> ~/.bashrc

# Create a new environment based on the environment.yml file
COPY environment.yml /tmp/environment.yml
RUN /opt/anaconda/bin/conda env create -f /tmp/environment.yml && \
    rm /tmp/environment.yml

# Set up trainingdata-tool
COPY src/ImportantTools/trainingdata-tool.sh /bin/trainingdata-tool
RUN chmod +x /bin/trainingdata-tool

# Set up pgn-extract tool
COPY src/ImportantTools/pgn-extract-22-11.tgz /tmp/pgn-extract.tgz
RUN mkdir -p /opt/pgn-extract && \
    tar -xzf /tmp/pgn-extract.tgz -C /opt/pgn-extract --strip-components=1 && \
    rm /tmp/pgn-extract.tgz && \
    cd /opt/pgn-extract && \
    make && \
    ln -s /opt/pgn-extract/pgn-extract /usr/local/bin/pgn-extract

# Set the working directory to /app
WORKDIR /app

# Copy the project files
COPY src .

# Install the Python package
RUN /opt/anaconda/bin/python setup.py install

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    screen && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY /scripts/entrypoint.sh /app/entrypoint.sh
# Set the entrypoint command to run the script
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
