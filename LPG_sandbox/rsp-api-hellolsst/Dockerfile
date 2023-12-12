# Use the official lightweight Python image.
FROM python:3.11-slim

LABEL MAINTAINER="Leanne Guy <leanne@lsst.org>"


RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Set the working directory.
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container image.
COPY . ./

# Upgrade pip and install the requirements.
RUN pip install --root-user-action=ignore --upgrade pip -r requirements.txt

# Run the script to remotely query the Rubin Science Platform.
CMD ["python3","hello-rubin.py"]
