FROM node:20-alpine as dependencies

ARG CI_PROJECT_DIR

WORKDIR $CI_PROJECT_DIR

RUN npm install


FROM node:20-alpine as builder

ARG CI_PROJECT_DIR

WORKDIR /builder

COPY --from=dependencies $CI_PROJECT_DIR/node_modules ./node_modules
COPY --from=dependencies $CI_PROJECT_DIR/package*.json ./
COPY --from=dependencies $CI_PROJECT_DIR/index.js ./

RUN npm install


FROM node:20-alpine

WORKDIR /home/node/app

COPY --from=builder /builder/node_modules ./node_modules
COPY --from=dependencies $CI_PROJECT_DIR/package*.json ./
COPY --from=dependencies $CI_PROJECT_DIR/index.js ./

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]