FROM golang:alpine AS build
RUN mkdir -p /go_app
ADD . /go_app
WORKDIR /go_app
RUN go build -o main .

FROM alpine
RUN apk update && rm -rf /var/cache/apk*
RUN mkdir -p /app
ADD . /app
COPY --from=build /go_app /app

CMD ["/app/main"]
