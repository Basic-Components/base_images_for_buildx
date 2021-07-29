FROM --platform=$TARGETPLATFORM alpine:3.14
RUN apk update 
RUN apk add --no-cache ca-certificates git gcc=10.3.1_git20210424-r2 g++==10.3.1_git20210424-r2 make cmake perl linux-headers tar curl zip unzip python3 py3-pip 
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++
ENV CURLOPT_HTTP_VERSION=CURL_HTTP_VERSION_1_1
# ENV X_VCPKG_ASSET_SOURCES=x-azurl,http://106.15.181.5/
COPY pip.conf /etc/pip.conf
RUN pip --no-cache-dir install --upgrade pip
RUN pip --no-cache-dir install conan==1.39.0
RUN conan profile new default --detect
RUN conan profile update settings.compiler=gcc default
RUN conan profile update settings.compiler.version=10 default
RUN conan profile update settings.compiler.exception=seh default
RUN conan profile update settings.compiler.libcxx=libstdc++11 default
RUN conan profile update settings.compiler.threads=posix default
RUN conan profile update settings.build_type=Release default
WORKDIR /vcpkg
RUN git config --global http.version HTTP/1.1
RUN git config --global http.sslVerify false
RUN git clone https://github.com/microsoft/vcpkg.git
WORKDIR /vcpkg/vcpkg
RUN ./bootstrap-vcpkg.sh
RUN ln -s /vcpkg/vcpkg/vcpkg /usr/bin/vcpkg