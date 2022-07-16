FROM debian:stable-slim
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-gpsprune"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG VERSION=19.2
ENV VERSION ${VERSION}
ARG FILE_SHA256SUM=e9714513b9f90318917bbabc6c1bfb8fa0893442bb4e777aa0699503e7bc53e0
ENV FILE_URL https://activityworkshop.net/software/gpsprune/gpsprune_${VERSION}.jar

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* default-jre=* && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	wget -O /gpsprune.jar -q $FILE_URL && \
	sha256sum /gpsprune.jar && \
	echo "${FILE_SHA256SUM}  /gpsprune.jar"| sha256sum -c - && \
	export uid=${PUID} gid=${PGID} && \
	mkdir -p /home/developer/kml/ && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown "${uid}:${gid}" -R /home/developer

USER developer
VOLUME /home/developer/kml
WORKDIR /home/developer/kml

USER developer
ENTRYPOINT [ "java", "-jar", "/gpsprune.jar" ]
