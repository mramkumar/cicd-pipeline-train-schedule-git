FROM     node:carbon

WORKDIR  /usr/src/app

COPY     . ./

EXPOSE  3000

CMD     ["npm","start","app.js"]

