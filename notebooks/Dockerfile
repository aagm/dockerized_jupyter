FROM --platform=linux/x86_64 mambaorg/micromamba:0.27-bullseye-slim AS base

USER root
RUN apt-get update && \
    apt-get install -y \
        vim \
        make \
        git \
        python3-rtree \
        software-properties-common \
        graphviz \
        sudo \
        tini \
        wget \
        ca-certificates \
        build-essential \
        sqlite3 \
        libsqlite3-dev \
        zlib1g-dev \
        manpages-dev \
        curl \
        tzdata \
        unzip \
        xclip \
        libedit-dev \
        g++ && export CXX=g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

USER $MAMBA_USER

FROM base AS build

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.conda-lock.yaml /tmp/environment.conda-lock.yaml

RUN micromamba install -n base --yes --file /tmp/environment.conda-lock.yaml && \
    micromamba clean --all --yes

# Otherwise python will not be found
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Jupyter with Docker Compose
EXPOSE 8888
WORKDIR /home/$MAMBA_USER

FROM build AS dev

USER root
RUN git clone https://github.com/mapbox/tippecanoe.git && \
	cd tippecanoe && \
	make -j && make install && cd ..
USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER jupyter_server_config.py /home/$MAMBA_USER/.jupyter/jupyter_server_config.py
# Legacy for Jupyter Notebook Server, see: [#1205](https://github.com/jupyter/docker-stacks/issues/1205)
RUN sed -re "s/c.ServerApp/c.NotebookApp/g" \
    /home/$MAMBA_USER/.jupyter/jupyter_server_config.py > /home/$MAMBA_USER/.jupyter/jupyter_notebook_config.py

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "jupyter", "lab", "--ip=0.0.0.0","--allow-root", "--no-browser"]
