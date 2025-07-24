# FROM python:3.9-alpine

# RUN adduser -D admin
# RUN apk update && apk add bash python3-dev gcc g++ libc-dev

# WORKDIR /home/qrater

# COPY requirements.txt requirements.txt
# RUN python -m venv env
# RUN env/bin/pip install --upgrade pip
# RUN env/bin/pip install -r requirements.txt

# COPY app app
# COPY migrations migrations
# COPY qrater.py config.py boot.sh ./
# RUN chmod +x boot.sh

# ENV FLASK_APP qrater.py

# RUN chown -R admin ./
# USER admin

# EXPOSE 5000
# ENTRYPOINT ["./boot.sh"]

FROM mambaorg/micromamba:2.3.0

WORKDIR /home/qrater
USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER qrater.yml /tmp/env.yaml
RUN --mount=type=cache,target=/opt/conda/pkgs \
    micromamba install -y -n base -f /tmp/env.yaml

RUN micromamba clean --all --yes && \
    rm -f /tmp/env.yaml

# not available in micromamba
# RUN pip install --no-cache-dir \
#     sqlalchemy-datatables

COPY --chown=$MAMBA_USER:$MAMBA_USER app app
COPY --chown=$MAMBA_USER:$MAMBA_USER migrations migrations
COPY --chown=$MAMBA_USER:$MAMBA_USER qrater.py config.py boot.sh ./

RUN chmod +x boot.sh
RUN chown -R $MAMBA_USER ./

ENV FLASK_APP=qrater.py

EXPOSE 5000

SHELL ["/usr/local/bin/_dockerfile_shell.sh"]

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "./boot.sh"]
