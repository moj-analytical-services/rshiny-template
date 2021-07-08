FROM quay.io/mojanalytics/rshiny:3.5.1

ENV PATH="/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}"
ENV SHINY_APP=/srv/shiny-server
ENV NODE_ENV=production

WORKDIR /srv/shiny-server

# ENV SHINY_GAID <your google analytics token here>

RUN npm i -g ministryofjustice/analytics-platform-shiny-server#v0.0.5

# Add shiny app code
ADD . .

USER shiny
CMD analytics-platform-shiny-server
EXPOSE 9999
