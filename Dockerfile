FROM golang:1.9.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV DIS yulahuyed

RUN apk --no-cache add ca-certificates git expect make
RUN go get -u github.com/golang/dep/cmd/dep
RUN mkdir -p $GOPATH/src/github.com/miniflux
RUN cd $GOPATH/src/github.com/miniflux
RUN git clone https://github.com/$DIS/miniflux.git
RUN cd miniflux
RUN make linux
RUN chmod 777 miniflux-linux-amd64
RUN mv miniflux-linux-amd64 /usr/local/bin/miniflux
RUN cd $GOPATH
RUN rm -rf $GOPATH/src/github.com/miniflux
RUN apk del git make

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
