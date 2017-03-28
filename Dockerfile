FROM rocker/shiny

ENV SHINY_APP_PATH /srv/shiny-server

# Install packrat
RUN R -e "install.packages('packrat')"

# Add shiny app code
RUN rm -rf $SHINY_APP_PATH/*
ADD . $SHINY_APP_PATH
RUN rm -rf $SHINY_APP_PATH/packrat/lib*
RUN rm -rf $SHINY_APP_PATH/packrat/src

# Install shiny app dependencies
RUN if [ -f $SHINY_APP_PATH/packrat/packrat.lock ]; then cd $SHINY_APP_PATH && R -e "packrat::restore()"; fi;

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server
