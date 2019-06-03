FROM rocker/shiny@sha256:627a2b7b3b6b1f6e33d37bdba835bbbd854acf70d74010645af71fc3ff6c32b6

WORKDIR /srv/shiny-server

# Cleanup shiny-server dir
RUN rm -rf ./*

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server

# Install dependency on xml2 and cleanup
RUN apt-get update && \
apt-get install --yes libxml2-dev libssl-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/

# Add Packrat files individually so that next install command
# can be cached as an image layer separate from application code
ADD packrat packrat

# Install packrat itself then packages from packrat.lock
RUN R -e "install.packages('packrat'); packrat::restore()"

# Add shiny app code
ADD . .

# Shiny runs as 'shiny' user, adjust permissions
RUN chown -R shiny:shiny /var/log/shiny-server && \
chown -R shiny:shiny /usr/local/lib/R/site-library && \
chown -R shiny:shiny /var/lib/shiny-server && \
chown -R shiny:shiny .

# Run shiny-server on port 80
RUN sed -i 's/3838/8080/g' /etc/shiny-server/shiny-server.conf
EXPOSE 8080

USER shiny
