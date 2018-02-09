FROM golang:1.9.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV DIS yulahuyed

RUN apk --no-cache add ca-certificates git expect
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/$DIS/miniflux
RUN apk del git

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
