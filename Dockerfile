FROM rocker/shiny

# ENV SHINY_APP_PATH /srv/shiny-server

# # Cleanup shiny-server dir
# RUN rm -rf $SHINY_APP_PATH/*

# # Make sure the directory for individual app logs exists
# RUN mkdir -p /var/log/shiny-server

# # Install packrat
# RUN R -e "install.packages('packrat')"

# # Add shiny app code
# ADD . $SHINY_APP_PATH

# # Install shiny app dependencies
# RUN if [ -f $SHINY_APP_PATH/packrat/packrat.lock ]; then cd $SHINY_APP_PATH && R -e "packrat::restore()"; fi;

# # Shiny runs as 'shiny' user, adjust app directory permissions
# RUN chown -R shiny:shiny $SHINY_APP_PATH
