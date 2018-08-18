FROM golang:1.10-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV ITEM_PER_PAGE 20

RUN apk --no-cache add ca-certificates expect git curl
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/miniflux/miniflux
RUN rm $GOPATH/src/github.com/miniflux/miniflux/template/html/common/layout.html
RUN rm $GOPATH/src/github.com/miniflux/miniflux/ui/static/css/common.css
ADD common.css $GOPATH/src/github.com/miniflux/miniflux/ui/static/css/common.css
ADD layout.html $GOPATH/src/github.com/miniflux/miniflux/template/html/common/layout.html
RUN sed -i "s/100/${ITEM_PER_PAGE}/g" $GOPATH/src/github.com/miniflux/miniflux/ui/pagination.go
RUN cd $GOPATH/src/github.com/miniflux/miniflux && go generate && GOOS=linux GOARCH=amd64 go build && mv miniflux /usr/local/bin
RUN apk del git

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody


CMD /entrypoint.sh
