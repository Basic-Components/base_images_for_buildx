docker buildx build --platform=linux/amd64,linux/arm64 -t hsz1273327/buildx_conan:alpine-3.14-gcc10-conan-1.39.0 . --push
#docker buildx build --platform=linux/amd64,linux/arm64 -t conanio/buildx_conan:alpine-3.14-gcc10-conan-1.39.0 . --push