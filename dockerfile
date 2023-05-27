# syntax=docker/dockerfile:1

FROM debian

EXPOSE 443 80

VOLUME /config

RUN apt-get update && apt-get install -y ca-certificates openssl

WORKDIR /app

# install go 1.20.2
RUN apt-get install -y wget curl
RUN wget https://golang.org/dl/go1.20.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# install nodejs 18.16.0
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY package.json ./
COPY package-lock.json ./
RUN npm install

COPY . .
RUN ls 
RUN npm run client-build
RUN ./build.sh

WORKDIR /app/build

CMD ["./cosmos"]
