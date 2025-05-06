# thttpd

A fork of [thttpd](https://acme.com/software/thttpd/) v2.29 that compiles under GCC 14.

# Sample Usage

Here is a sample dockerfile that runs a site on port `81` in the same folder:

```dockerfile
# Please specify the appropriate version of alpine!
FROM alpine:latest AS builder

# Install all dependencies required for compiling thttpd
RUN apk add gcc musl-dev make git

# Download thttpd sources
RUN git init && git clone https://github.com/elliottback/thttpd.git thttpd

# Compile thttpd to a static binary which we can copy around
RUN cd /thttpd/src \
  && ./configure || cat config.log \
  && make CCOPT='-O2 -s -static -fpermissive' thttpd

# Create a non-root user to own the files and run our server
RUN adduser -D static

# Switch to the scratch image
FROM scratch

EXPOSE 81

# Copy over the user
COPY --from=builder /etc/passwd /etc/passwd

# Copy the thttpd static binary
COPY --from=builder /thttpd/src/thttpd /

# Use our non-root user
USER static
WORKDIR /home/static

# Copy the static website
# Use the .dockerignore file to control what ends up inside the image!
COPY . .

# Run thttpd
CMD ["/thttpd", "-D", "-h", "0.0.0.0", "-p", "81", "-d", "/home/static", "-u", "static", "-l", "-", "-M", "60"]
```