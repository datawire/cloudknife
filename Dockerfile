FROM alpine:3.7

RUN apk add --no-cache \
        bash \
		bind-tools \
		curl \
		netcat-openbsd \
		python3 \
		python3-dev \
        postgresql-dev \
		socat \
		wget \
    && apk add --no-cache --virtual build-deps \
        build-base \
	&& python3 -m ensurepip \
	&& rm -r /usr/lib/python*/ensurepip \
	&& pip3 install --upgrade pip setuptools \
	&& if [[ ! -e /usr/bin/pip ]]; then ln -s pip3 /usr/bin/pip; fi \
	&& if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
	&& pip install redis pgcli \
	&& rm -rf /root/.cache \
	&& apk del build-deps

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "trap : TERM INT; sleep 2147483647 & wait"]
