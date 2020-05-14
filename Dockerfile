FROM jupyter/datascience-notebook

SHELL [ "/bin/bash", "-l", "-c" ]

USER root
ENV NVM_DIR /usr/local/nvm
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV GEOS_VERSION 3.8.0
ENV PROJ4_VERSION 6.3.1
ENV GDAL_VERSION 3.0.4
ENV ENCODING UTF-8
ENV LOCALE en_US

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-rtree \
    software-properties-common \
    graphviz \
    ca-certificates \
    build-essential \
    libsqlite3-dev \
    zlib1g-dev \
    manpages-dev \
    curl && \   
    add-apt-repository -y ppa:ubuntugis/ppa && add-apt-repository ppa:nextgis/ppa && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt update -q -y && \
    apt install -q -y  gdal-bin python3-gdal python-gdal libgdal-dev g++ g++-5 && export CXX=g++-5 && \
	pip install jupyter_contrib_nbextensions version_information jupyterlab

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal && export C_INCLUDE_PATH=/usr/include/gdal

RUN jupyter contrib nbextension install --sys-prefix
RUN mkdir -p "$NVM_DIR"; \
    curl -o- \
        "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | \
        bash \
    ; \
    source $NVM_DIR/nvm.sh; \
    nvm install --lts --latest-npm
RUN npm install @mapbox/mapbox-gl-style-spec --global

Run git clone https://github.com/mapbox/tippecanoe.git && \
	cd tippecanoe && \
	make -j && make install && cd ..
RUN export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# Having to install gdal through conda gaves me chills; trying intalling it through pip is failing badly. no time to dig depply on what is going on probably issues with path.
RUN conda install -c conda-forge gdal
# Add requirements file 
ADD requirements.txt /app/
Run pip install wheel -r /app/requirements.txt


RUN jupyter nbextension install --sys-prefix --py vega && jupyter nbextension enable vega --py --sys-prefix && jupyter nbextension enable --py --sys-prefix ipyleaflet
 
# Jupyter with Docker Compose
EXPOSE 8888