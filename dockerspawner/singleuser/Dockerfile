# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

#FROM jupyter/scipy-notebook
FROM jupyter/all-spark-notebook

MAINTAINER Project Jupyter <jupyter@googlegroups.com>

EXPOSE 8888

USER root
# fetch juptyerhub-singleuser entrypoint
RUN wget -q https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.6.1/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser
RUN conda install -c conda-forge jupyterlab && \
    conda install jupyter_client && \
    jupyter serverextension enable --py jupyterlab --sys-prefix

ADD singleuser.sh /srv/singleuser/singleuser.sh
USER jovyan
# smoke test that it's importable at least
RUN sh /srv/singleuser/singleuser.sh -h
CMD ["sh", "/srv/singleuser/singleuser.sh"]
