FROM 593291632749.dkr.ecr.eu-west-1.amazonaws.com/rshiny:4.1

ENV PATH="/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}"
ENV SHINY_APP=/srv/shiny-server
ENV NODE_ENV=production

WORKDIR /srv/shiny-server

# ENV SHINY_GAID <your google analytics token here>

RUN npm i -g ministryofjustice/analytics-platform-shiny-server#v0.0.5

# Add shiny app code
ADD . .

# use renv for packages
ENV RENV_VERSION 0.13.2
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e 'renv::restore()'

USER shiny
CMD analytics-platform-shiny-server
EXPOSE 9999
