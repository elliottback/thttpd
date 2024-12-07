FROM alpine:3.21.0

# Install all dependencies required for compiling thttpd
RUN apk add gcc musl-dev make

RUN GCC_VERSION=$(gcc --version | grep ^gcc | sed 's/^.* //g' | awk -F. '{print $1}') \
    && echo "Found GCC_VERSION $GCC_VERSION" \
    && if [ "$GCC_VERSION" -ne 14 ]; then exit 1 ; fi \
    && cd thttpd \
    && ls -l \
    && ./configure || cat config.log \
    && make CCOPT='-O2 -s -static' thttpd