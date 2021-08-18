FROM node:10-alpine

#Create app directory
WORKDIR /usr/app
COPY package*.json ./
RUN npm install
COPY dist /usr/app/dist
COPY server.js /usr/app
COPY ".env.development" /usr/app
COPY ".env.production" /usr/app
COPY ".env.tunnel" /usr/app


ENV NODE_ENV "tunnel"

EXPOSE 8088

CMD ["node", "server"]
