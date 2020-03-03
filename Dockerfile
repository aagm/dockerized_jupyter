FROM jupyter/datascience-notebook

SHELL [ "/bin/bash", "-l", "-c" ]

USER root
ENV NVM_DIR /usr/local/nvm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-rtree \
    graphviz \
    ca-certificates \
    curl && \
	pip install jupyter_contrib_nbextensions version_information jupyterlab
RUN jupyter contrib nbextension install --sys-prefix
RUN mkdir -p "$NVM_DIR"; \
    curl -o- \
        "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | \
        bash \
    ; \
    source $NVM_DIR/nvm.sh; \
    nvm install --lts --latest-npm
RUN npm install @mapbox/mapbox-gl-style-spec --global
# Add requirements file 
ADD requirements.txt /app/
Run pip install -r /app/requirements.txt
RUN jupyter nbextension install --sys-prefix --py vega && jupyter nbextension enable vega --py --sys-prefix && jupyter nbextension enable --py --sys-prefix ipyleaflet
 
# Jupyter with Docker Compose
EXPOSE 8888