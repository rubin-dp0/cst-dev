# Use the official lightweight Python image.
FROM python:3.12-alpine

LABEL MAINTAINER="Leanne Guy <leanne@lsst.org>"


# Set the working directory
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container image.
COPY . ./

# Create and set a non-root user
RUN useradd --create-home appuser
USER appuser

# Upgrade pip and install the requirements
RUN python -m pip install --upgrade --quiet --no-cache-dir pip setuptools wheel && pip install -r requirements.txt

# Run the script to connect to the RSP and create and save an image cutout
CMD ["python3","hello-rubin.py"]
