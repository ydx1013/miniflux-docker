FROM golang:1.9.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS test123
ENV DIS yulahuyed

RUN apk --no-cache add ca-certificates git expect make
RUN go get -u github.com/golang/dep/cmd/dep
RUN git clone https://github.com/$DIS/miniflux.git
RUN cd miniflux && go generate && GOOS=linux GOARCH=amd64 go build && mv miniflux /usr/local/bin
RUN apk del git make

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody
CMD /entrypoint.sh
