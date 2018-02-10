FROM golang:1.9.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123

RUN apk --no-cache add ca-certificates expect git
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/miniflux/miniflux
RUN rm $GOPATH/src/github.com/miniflux/miniflux/template/html/common/layout.html
ADD layout.html $GOPATH/src/github.com/miniflux/miniflux/template/html/common/layout.html
RUN cd $GOPATH/src/github.com/miniflux/miniflux && go generate && GOOS=linux GOARCH=amd64 go build && mv miniflux /usr/local/bin
RUN apk del git

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
