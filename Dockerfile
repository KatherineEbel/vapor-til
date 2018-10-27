FROM swift:4.2

WORKDIR /package

COPY . ./

RUN swift package --enable-prefetching fetch
RUN swift package clean
CMD swift test

