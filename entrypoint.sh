#!/bin/sh

export LISTEN_ADDR=0.0.0.0:$PORT
echo $DATABASE_URL

miniflux -migrate

expect <<END
spawn miniflux -create-admin
expect "Username:"
send "$ADMIN_USER\n"
expect "Password:"
send "$ADMIN_PASS\n"
expect eof
END

miniflux
