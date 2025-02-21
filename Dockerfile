# build env
FROM node:18-slim as build

RUN apt-get update && apt-get install -y python3 make g++ curl git &&\
    npm install -g npm@9.8.0

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . ./

ARG BUGSNAG_KEY
ENV BUGSNAG_KEY=${BUGSNAG_KEY}
ARG DIRECTORY_PROTOCOL=https
ENV DIRECTORY_PROTOCOL=${DIRECTORY_PROTOCOL}
ARG DIRECTORY_DOMAIN=cosmos.directory
ENV DIRECTORY_DOMAIN=${DIRECTORY_DOMAIN}
ARG DIRECTORY_DOMAIN_TESTNET=testcosmos.directory
ENV DIRECTORY_DOMAIN_TESTNET=${DIRECTORY_DOMAIN_TESTNET}
ARG TESTNET_MODE
ENV TESTNET_MODE=${TESTNET_MODE}
ARG MAINNET_DOMAIN
ENV MAINNET_DOMAIN=${MAINNET_DOMAIN}
ARG TESTNET_DOMAIN
ENV TESTNET_DOMAIN=${TESTNET_DOMAIN}

RUN yarn build

# production env
FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 4000
CMD ["nginx", "-g", "daemon off;"]
