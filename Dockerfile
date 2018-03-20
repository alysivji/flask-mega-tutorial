FROM python:3.6.4-alpine3.7

LABEL maintainer="Aly Sivji <alysivji@gmail.com>" \
      description="Development image for Flask Mega Tutorial webapp"

ARG blah

WORKDIR /home/web/

COPY requirements.txt /tmp/
COPY . /home/web

RUN addgroup -g 901 -S sivdev && \
    adduser -G sivdev -D -u 901 sivdev_user && \
    pip install --no-cache-dir -r /tmp/requirements.txt

EXPOSE 5000

# Switch from root user for security
USER sivdev_user

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
