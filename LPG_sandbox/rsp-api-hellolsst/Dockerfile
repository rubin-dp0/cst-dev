# Use the official lightweight Python image.
FROM python:3.12

LABEL MAINTAINER="Leanne Guy <leanne@lsst.org>"


# Set the working directory
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container image.
COPY . ./


# Upgrade pip
RUN python -m pip install --root-user-action=ignore --upgrade --quiet --no-cache-dir pip setuptools wheel 

# Install the requirements
RUN pip install -r requirements.txt

# Run the script to connect to the RSP and create and save an image cutout
CMD ["python3","hello-rubin.py"]
