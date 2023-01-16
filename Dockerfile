FROM registry.altlinux.org/egori/p10-aflplusplus:latest

ARG cuid=500
ARG cgid=500
ARG cuidname=user
ARG cgidname=docker

USER root

# Match host and container uid/gid
RUN groupmod -g $cgid $cgidname && \
    usermod -u $cuid -g $cgid -s /bin/bash $cuidname

RUN apt-get update -y && \
    apt-get install -y tcl libpq-devel libpqxx-devel libsqlite3-devel

USER $cuidname
WORKDIR /home/$cuidname/


COPY --chown=$cuid:$cgid ./assets/ /home/$cuidname/

RUN ./build.sh

CMD ./fuzz.sh
