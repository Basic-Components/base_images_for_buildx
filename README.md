# base_images_for_buildx

为buildx准备的跨平台镜像的dockerfile,主要为静态语言编译为纯静态可执行文件准备

包含包管理工具

+ `conan`,已经创建了名为`default`的profile,其配置如下

    ```conf

    ```

+ `vcpkg`仓库下载在路径`/vcpkg/vcpkg`中,`/vcpkg/vcpkg/vcpkg`软连接到了`/usr/bin/vcpkg`

    感谢[robotdad/findfaces](https://github.com/robotdad/findfaces/tree/original)这个项目.它提供了`x64-linux-musl.cmake`.


## 墙内注意

1. 根目录创建`pip.conf`用于使用pypi的国内镜像

    ```conf
    [global]
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    ```

2. `sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories`用国内apk的镜像
3. 设置环境变量`X_VCPKG_ASSET_SOURCES=x-azurl,http://106.15.181.5/`启用国内vcpkg镜像
4. 



> 墙外

1. 项目根目录创建`Dockerfile`

    ```Dockerfile
    FROM hsz1273327/vscode_cxx_env:alpine3.13-gcc10-conan1.39.0-vcpkgmaster
    ```

2. vscode中设置remote插件配置`New Container->From Dockerfile`

> 墙内

1. 根目录创建`pip.conf`用于使用pypi的国内镜像

    ```conf
    [global]
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    ```

2. 项目根目录创建`Dockerfile`

    ```Dockerfile
    FROM hsz1273327/vscode_cxx_env:alpine3.13-gcc10-conan1.39.0-vcpkgmaster
    ENV X_VCPKG_ASSET_SOURCES=x-azurl,http://106.15.181.5/
    RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
    RUN apk update 
    COPY pip.conf /etc/pip.conf
    ```

3. vscode中设置remote插件配置`New Container->From Dockerfile`

4. 待镜像构造完成后退出

5. 在创建出来的`.devcontainer/devcontainer.json`文件中修改hosts配置.

    ```json
    {
        ...
        "runArgs": [
            "--add-host=github-releases.githubusercontent.com:185.199.108.154",
            "--add-host=alive.github.com:140.82.114.26",
            "--add-host=live.github.com:140.82.113.26",
            "--add-host=github.githubassets.com:185.199.108.154",
            "--add-host=desktop.githubusercontent.com:185.199.108.133",
            "--add-host=assets-cdn.github.com:185.199.108.153",
            "--add-host=camo.githubusercontent.com:185.199.108.133",
            "--add-host=github.map.fastly.net:185.199.108.133",
            "--add-host=github.global.ssl.fastly.net:199.232.5.194",
            "--add-host=gist.github.com:140.82.112.3",
            "--add-host=github.io:185.199.108.153",
            "--add-host=github.com:140.82.114.3",
            "--add-host=github.blog:192.0.66.2",
            "--add-host=api.github.com:140.82.113.6",
            "--add-host=raw.githubusercontent.com:185.199.108.133",
            "--add-host=user-images.githubusercontent.com:185.199.108.133",
            "--add-host=favicons.githubusercontent.com:185.199.108.133",
            "--add-host=avatars5.githubusercontent.com:185.199.108.133",
            "--add-host=avatars4.githubusercontent.com:185.199.108.133",
            "--add-host=avatars3.githubusercontent.com:185.199.108.133",
            "--add-host=avatars2.githubusercontent.com:185.199.108.133",
            "--add-host=avatars1.githubusercontent.com:185.199.108.133",
            "--add-host=avatars0.githubusercontent.com:185.199.108.133",
            "--add-host=avatars.githubusercontent.com:185.199.108.133",
            "--add-host=codeload.github.com:140.82.112.10",
            "--add-host=github-cloud.s3.amazonaws.com:52.216.236.11",
            "--add-host=github-com.s3.amazonaws.com:52.217.99.188",
            "--add-host=github-production-release-asset-2e65be.s3.amazonaws.com:52.216.243.100",
            "--add-host=github-production-user-asset-6210df.s3.amazonaws.com:52.216.250.204",
            "--add-host=github-production-repository-file-5c1aeb.s3.amazonaws.com:52.217.74.124",
            "--add-host=githubstatus.com:185.199.108.153",
            "--add-host=github.community:64.71.144.202",
            "--add-host=media.githubusercontent.com:185.199.108.133"
        ],
        ...
    }
    ```

    其中的具体值需要跟踪[GitHub520这个项目](https://github.com/521xueweihan/GitHub520)

6. 重新进入镜像


