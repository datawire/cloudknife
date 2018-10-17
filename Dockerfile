FROM alpine:3.7

ENV CLOUD_SDK_VERSION 214.0.0
ENV PATH /usr/local/google-cloud-sdk/bin:$PATH

RUN apk add --no-cache \
        bash \
		bind-tools \
		curl \
		docker \
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
	&& apk del build-deps \
	&& wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/bin/cloud_sql_proxy \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && mv /google-cloud-sdk /usr/local \
    && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && ln -s /lib /lib64 \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set metrics/environment github_docker_image \
    && gcloud --version \
	&& chmod +x /usr/bin/cloud_sql_proxy

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "trap : TERM INT; sleep 2147483647 & wait"]
