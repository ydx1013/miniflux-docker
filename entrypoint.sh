#!/bin/sh

export LISTEN_ADDR=0.0.0.0:$PORT
echo $DATABASE_URL

/usr/local/bin/miniflux -migrate

expect <<END
spawn /usr/local/bin/miniflux -create-admin
expect "Username:"
send "$ADMIN_USER\n"
expect "Password:"
send "$ADMIN_PASS\n"
expect eof
END

/usr/local/bin/miniflux
