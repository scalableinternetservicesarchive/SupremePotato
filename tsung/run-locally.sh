docker run \
  -v "$(cd $(dirname "$0"); pwd):/usr/local/tsung" \
  ddragosd/tsung-docker:latest \
  -f "/usr/local/tsung/SP-Tsung.xml" \
  -r "'ssh -p 22'" \
  start
