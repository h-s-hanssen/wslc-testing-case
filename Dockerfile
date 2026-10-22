# Works unchanged with: wslc image build, docker build, podman build
FROM alpine:3.20
ARG GREETING="hello from wslc-testing-case"
ENV GREETING=${GREETING}
LABEL org.opencontainers.image.title="wslc-testing-case"
WORKDIR /app
COPY app/hello.sh /app/hello.sh
RUN chmod +x /app/hello.sh
EXPOSE 8080
ENTRYPOINT ["/app/hello.sh"]
CMD ["world"]
