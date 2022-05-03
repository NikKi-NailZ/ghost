FROM alpine:latest
ARG PROJECT_NAME={{.AppName}}
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY ./cmd/$PROJECT_NAME /app/

LABEL Name=$PROJECT_NAME

RUN chmod +x $PROJECT_NAME
ENTRYPOINT ["sh","$PROJECT_NAME"]
