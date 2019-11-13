FROM jupyter/datascience-notebook

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-rtree  && \
	pip install jupyter_contrib_nbextensions version_information jupyterlab
RUN jupyter contrib nbextension install --sys-prefix
# Add requirements file 
ADD requirements.txt /app/
Run pip install -r /app/requirements.txt
RUN jupyter nbextension install --sys-prefix --py vega && jupyter nbextension enable vega --py --sys-prefix
 
# Jupyter with Docker Compose
EXPOSE 8888