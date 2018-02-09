FROM golang:1.9.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV DIS yulahuyed

RUN apk --no-cache add ca-certificates git expect make
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/$DIS/miniflux
RUN cd $GOPATH/src/github.com/$DIS/miniflux && make linux
RUN mv miniflux-linux-amd64 /usr/local/bin/miniflux
RUN apk del git make

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
