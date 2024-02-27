FROM node:20-alpine as base

WORKDIR /home/node/app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:20-alpine as production

WORKDIR /home/node/app

COPY --from=base /home/node/app ./

EXPOSE 3000

CMD [ "npm", "start" ]