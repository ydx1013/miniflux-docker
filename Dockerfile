FROM alpine:latest
ENV ADMIN_USER miniflux
ENV ADMIN_PASS yhiblog
ENV ITEM_PER_PAGE 20

RUN apk --no-cache add expect alpine-sdk
RUN git clone https://github.com/miniflux/miniflux.git
RUN sed -i "s/100/${ITEM_PER_PAGE}/g" miniflux/ui/pagination.go
RUN sed -i '/<template id="keyboard-shortcuts">/,/<\/template>/d' miniflux/template/html/common/layout.html
RUN last_go=`curl https://golang.org/dl/ 2>/dev/null | grep -E  "google.*linux-amd64" | head -n 1 | awk -F 'href=' '{print $2}' | awk -F '"' '{print $2}'` && \
wget $last_go && \
tar xzf go*.tar.gz && \
export PATH=$PATH:`pwd`/go/bin && \
cd miniflux && \
last_version=`curl https://github.com/miniflux/miniflux/tags 2>/dev/null | grep "miniflux/releases/tag" | head -n 1 | sed 's#.*tag/\([^"]*\).*#\1#'` && \
make miniflux VERSION=$last_version && \
mv miniflux /usr/local/bin && \
make clean && \
cd .. && \
ls && \
go clean && \
rm -rf miniflux && \
rm -rf go*

RUN apk del alpine-sdk
RUN apk --no-cache add curl ca-certificates

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody

CMD /entrypoint.sh
