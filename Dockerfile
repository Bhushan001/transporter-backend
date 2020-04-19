FROM shoppinpal/node:6.10 as serverbuilder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN npm install -g grunt-cli
RUN mkdir -p /app/transporter
WORKDIR /app/transporter
COPY package.json /app/blubox/package.json
COPY Gruntfile.js /app/blubox/Gruntfile.js
COPY . /app/transporter
# RUN if [ ${BUILD_ENV} = "production" ]; then grunt cdn; fi

FROM node:6.11.2-alpine
RUN mkdir -p /app/transporter
WORKDIR /app/transporter
COPY . /app/transporter
COPY --from=serverbuilder /app/transporter/node_modules /app/transporter/node_modules
COPY --from=serverbuilder /app/transporter /app/transporter
RUN npm install
EXPOSE 3000
CMD [ "grunt","docker" ]
