FROM golang:1.11.4-alpine
ENV ADMIN_USER miniflux
ENV ADMIN_PASS yhiblog
ENV ITEM_PER_PAGE 20

RUN apk --no-cache add expect alpine-sdk
RUN git clone https://github.com/miniflux/miniflux.git
RUN sed -i "s/100/${ITEM_PER_PAGE}/g" miniflux/ui/pagination.go
RUN sed -i '/<template id="keyboard-shortcuts">/,/<\/template>/d' miniflux/template/html/common/layout.html
RUN cd miniflux && \
last_version=`curl https://github.com/miniflux/miniflux/tags 2>/dev/null | grep "miniflux/releases/tag" | head -n 1 | sed 's#.*tag/\([^"]*\).*#\1#'` && \
make miniflux VERSION=$last_version && \
mv miniflux /usr/local/bin && \
make clean && \
cd .. && \
ls && \
rm -rf miniflux && \
go clean
RUN apk del alpine-sdk
RUN apk --no-cache add curl ca-certificates

ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh 
USER nobody

CMD /entrypoint.sh
