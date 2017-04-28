FROM rocker/shiny:latest

WORKDIR /srv/shiny-server

# Cleanup shiny-server dir
RUN rm -rf ./*

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server

# Add Packrat files individually so that next install command
# can be cached as an image layer separate from application code
ADD packrat packrat

# Install packrat itself then packages from packrat.lock
RUN R -e "install.packages('packrat'); packrat::restore()"

# Add shiny app code
ADD . .

# Shiny runs as 'shiny' user, adjust app directory permissions
RUN chown -R shiny:shiny .

# Install dependency on xml2
RUN apt-get install libxml2-dev --yes

# APT Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/
