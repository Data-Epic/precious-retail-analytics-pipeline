# Use an official Python 3.10 runtime as a parent image
FROM python:3-slim

# Set the working directory
WORKDIR /analytics

# Install dependencies to allow downloading and unzipping of files
RUN apt-get update && apt-get install -y wget unzip

# Download and unzip DuckDB binary, then clean up
RUN wget https://github.com/duckdb/duckdb/releases/download/v1.0.0/duckdb_cli-linux-amd64.zip 
RUN unzip duckdb_cli-linux-amd64.zip 
RUN rm duckdb_cli-linux-amd64.zip    
RUN chmod +x duckdb

# Copy the requirements file into the container at /app
COPY requirements.txt /analytics/

# Install any needed packages specified in requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the executable file and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the rest of the application code into the container
COPY . /analytics

# Unzip online_retail file
RUN unzip online_retail.zip

# Run data ingestion script
RUN python data_ingestion.py


# Execute the entrypoint script to open DuckDB CLI automatically
ENTRYPOINT ["/entrypoint.sh"]