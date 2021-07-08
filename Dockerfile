FROM 593291632749.dkr.ecr.eu-west-1.amazonaws.com/rshiny:local

ENV PATH="/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}"
ENV SHINY_APP=/srv/shiny-server
ENV NODE_ENV=production

WORKDIR /srv/shiny-server

# ENV SHINY_GAID <your google analytics token here>

RUN npm i -g ministryofjustice/analytics-platform-shiny-server#v0.0.5


# use renv for packages
ADD renv.lock renv.lock
RUN R -e "install.packages('renv')"
RUN R -e 'renv::restore()'

# Add shiny app code
ADD . .

USER shiny
CMD analytics-platform-shiny-server
EXPOSE 9999
