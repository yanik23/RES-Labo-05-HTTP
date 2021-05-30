FROM node:14.17.0

RUN apt-get update && \
	apt-get install -y vim
	
COPY src /opt/app

COPY serf /usr/local/bin

CMD ["node", "/opt/app/index.js"]

RUN chmod +x /usr/local/bin/serf
