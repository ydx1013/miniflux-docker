FROM alpine:3.7
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV VER 2.0.2

RUN apk --no-cache add ca-certificates curl expect
RUN curl -L -H "Cache-Control: no-cache" -o miniflux https://github.com/miniflux/miniflux/releases/download/$VER/miniflux-linux-amd64
RUN chmod 777 miniflux && mv miniflux /usr/local/bin
ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
