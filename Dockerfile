FROM alpine:3.7

RUN apk add --no-cache \
		bind-tools \
                curl \
		netcat-openbsd \
		python3 \
		python3-dev \
                socat \
		wget && \
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	if [[ ! -e /usr/bin/pip ]]; then ln -s pip3 /usr/bin/pip; fi && \
	if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
	rm -r /root/.cache && \
	pip install redis

ENTRYPOINT ["/bin/sh"]
