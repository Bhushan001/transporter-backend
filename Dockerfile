FROM shoppinpal/node:6.10 as serverbuilder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN npm install -g grunt-cli
RUN mkdir -p /app/transporter
WORKDIR /app/transporter
COPY . /app/transporter
RUN npm install
# RUN if [ ${BUILD_ENV} = "production" ]; then grunt cdn; fi

FROM node:6.11.2-alpine
RUN mkdir -p /app/transporter
WORKDIR /app/transporter
COPY . /app/transporter
COPY --from=serverbuilder /app/transporter /app/transporter
EXPOSE 3000
CMD [ "node","server/server.js" ]
