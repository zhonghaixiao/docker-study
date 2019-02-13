MAILER_CID=$(docker run -d dockerinaction/ch2_mailer)
echo $MAILER_CID
WEB_CID=$(docker run -d nginx)
echo $WEB_CID
AGENT_CID=$(docker create --link $WEB_CID:insideweb --link $MAILER_CID:insidemailer dockerinaction/ch2_agent)