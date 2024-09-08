# docker build . -t example-http:latest
# docker run -p 5000:5000 -it ${image_id}
# http://localhost:5000/test.html

FROM python:3

COPY test.html .
EXPOSE 5000
ENTRYPOINT ["python3", "-m", "http.server", "5000", "--directory", "."]