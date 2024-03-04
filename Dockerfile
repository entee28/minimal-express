FROM node:20-alpine as dependencies

ARG CI_PROJECT_DIR

WORKDIR $CI_PROJECT_DIR

RUN npm ci


FROM node:20-alpine as builder

ARG CI_PROJECT_DIR

WORKDIR /builder

COPY --from=dependencies $CI_PROJECT_DIR/node_modules ./node_modules
COPY --from=dependencies $CI_PROJECT_DIR/src ./src

RUN npm ci


FROM node:20-alpine

WORKDIR /home/node/app

COPY --from=builder /builder/node_modules ./node_modules
COPY --from=builder /builder/src ./src

RUN npm ci

EXPOSE 3000

CMD [ "npm", "start" ]