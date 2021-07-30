FROM --platform=$TARGETPLATFORM alpine:3.14
ARG TARGETARCH
RUN apk update 
RUN apk add --no-cache \
    ca-certificates git curl \
    gcc=10.3.1_git20210424-r2 g++==10.3.1_git20210424-r2 libgcc \
    musl-dev linux-headers libc6-compat \
    pkgconfig autoconf binutils libtool make cmake re2c\
    tar zip unzip\
    perl python3 py3-pip gfortran
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++
ENV CMAKE_C_COMPILER=gcc
ENV CMAKE_Fortran_COMPILER=gfortran
ENV CURLOPT_HTTP_VERSION=CURL_HTTP_VERSION_1_1
RUN pip --no-cache-dir install --upgrade pip
RUN pip --no-cache-dir install conan==1.39.0
RUN conan profile new default --detect
RUN conan profile update settings.compiler=gcc default
RUN conan profile update settings.compiler.version=10 default
RUN conan profile update settings.compiler.exception=seh default
RUN conan profile update settings.compiler.libcxx=libstdc++11 default
RUN conan profile update settings.compiler.threads=posix default
RUN conan profile update settings.build_type=Release default
RUN git config --global http.version HTTP/1.1
RUN git config --global http.sslVerify false
WORKDIR /ninja
RUN git clone -b v1.10.2 https://github.com/ninja-build/ninja.git
WORKDIR /ninja/ninja
RUN python3 configure.py --bootstrap
RUN cp ninja /usr/bin
WORKDIR /
RUN rm -rf ninja
WORKDIR /vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git
WORKDIR /vcpkg/vcpkg
RUN ./bootstrap-vcpkg.sh --useSystemBinaries
COPY ${TARGETARCH}-triplet/*.cmake /vcpkg/vcpkg/triplets/
COPY ${TARGETARCH}-env/env.sh /env.sh
WORKDIR /
RUN source env.sh
RUN rm -f env.sh
RUN ln -s /vcpkg/vcpkg/vcpkg /usr/bin/vcpkg