FROM klakegg/hugo:ext-alpine

WORKDIR /src

COPY . /src

EXPOSE 1313

CMD ["server", "--bind=0.0.0.0", "--baseURL=http://localhost:1313/", "--disableFastRender"]
