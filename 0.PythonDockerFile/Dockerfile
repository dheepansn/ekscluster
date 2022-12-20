FROM python:3.6.2-slim
MAINTAINER Dheepan Swaminathan <dheepanswaminathan@gmail.com>
LABEL Quickly serve SPH Monitoring and  Files using Python http.server module.
COPY urlmonitoring.py .
COPY url.csv .
RUN pip3 install requests
RUN pip3 install pandas
ENTRYPOINT [ "python3", "urlmonitoring.py" ]
