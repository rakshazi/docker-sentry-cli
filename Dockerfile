FROM alpine:latest

ENV SENTRY_VERSION="1.20.0"

RUN apk add --no-cache --virtual .build-deps \
		build-base \
		cargo \
		cmake \
		curl \
		curl-dev \
		file \
		gcc \
		openssl \
		openssl-dev \
		rust \
	&& cd /tmp \
	&& curl -LO https://github.com/getsentry/sentry-cli/archive/$SENTRY_VERSION.tar.gz \
	&& tar -xzf $SENTRY_VERSION.tar.gz \
	&& cargo build --manifest-path sentry-cli-$SENTRY_VERSION/Cargo.toml --release \
	&& mv sentry-cli-$SENTRY_VERSION/target/release/sentry-cli /usr/local/bin \
	&& rm -rf /tmp/* \
	&& rm -rf /root/.cargo \
	&& apk del .build-deps \
	&& apk add --no-cache curl llvm-libunwind openssl

CMD ["/usr/local/bin/sentry-cli"]
