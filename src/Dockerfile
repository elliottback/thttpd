FROM alpine:3.21.0

# Install all dependencies required for compiling thttpd
RUN apk add gcc musl-dev make

# verify version
RUN GCC_VERSION=$(gcc --version | grep ^gcc | sed 's/^.* //g' | awk -F. '{print $1}') \
    && echo "Found GCC_VERSION $GCC_VERSION" \
    && if [ "$GCC_VERSION" -ne 14 ]; then exit 1 ; fi

# Setup directories
WORKDIR /usr/local/app
COPY . .
RUN chmod +x configure
RUN pwd && ls -l

# try to build the image
RUN ./configure || cat config.log \
    && make CCOPT='-O2 -s -static' thttpd