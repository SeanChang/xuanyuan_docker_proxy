---
image: messense/cargo-zigbuild
description: "使用zig作为链接器编译Cargo项目，简化交叉编译过程。"
source: https://xuanyuan.cloud/zh/r/messense/cargo-zigbuild
canonical: https://xuanyuan.cloud/zh/r/messense/cargo-zigbuild
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/messense/cargo-zigbuild" title="messense/cargo-zigbuild Docker 镜像中文简介、标签列表与拉取命令">messense/cargo-zigbuild 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cargo-zigbuild

[![CI](https://github.com/rust-cross/cargo-zigbuild/workflows/CI/badge.svg)](https://github.com/rust-cross/cargo-zigbuild/actions?query=workflow%3ACI)
[![Crates.io](https://img.shields.io/crates/v/cargo-zigbuild.svg)](https://crates.io/crates/cargo-zigbuild)
[![docs.rs](https://docs.rs/cargo-zigbuild/badge.svg)](https://docs.rs/cargo-zigbuild/)
[![PyPI](https://img.shields.io/pypi/v/cargo-zigbuild.svg)](https://pypi.org/project/cargo-zigbuild)
[![Docker Image](https://img.shields.io/docker/pulls/messense/cargo-zigbuild.svg?maxAge=2592000)](https://hub.docker.com/r/messense/cargo-zigbuild/)

> 🚀 支持我成为全职开源开发者：[在GitHub上赞助我](https://github.com/sponsors/messense)

使用[zig](https://github.com/ziglang/zig)作为[链接器](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html)编译Cargo项目，实现[更简单的交叉编译](https://actually.fyi/posts/zig-makes-rust-cross-compilation-just-work/)。

## 安装

```bash
cargo install --locked cargo-zigbuild
```

也可通过pip安装，会自动安装[`ziglang`](https://pypi.org/project/ziglang/)：

```bash
pip install cargo-zigbuild
```

我们还提供Docker镜像，除cargo-zigbuild和Rust外，预安装了macOS SDK。例如，构建x86_64 macOS目标：

- Linux Docker镜像（[ghcr.io](https://github.com/rust-cross/cargo-zigbuild/pkgs/container/cargo-zigbuild)、[Docker Hub](https://hub.docker.com/r/messense/cargo-zigbuild)）：
```bash
docker run --rm -it -v $(pwd):/io -w /io ghcr.io/rust-cross/cargo-zigbuild \
  cargo zigbuild --release --target x86_64-apple-darwin
```

[![打包状态](https://repology.org/badge/vertical-allrepos/cargo-zigbuild.svg?columns=4)](https://repology.org/project/cargo-zigbuild/versions)

## 使用方法

1. 按照[官方文档](https://ziglang.org/learn/getting-started/#installing-zig)安装[zig](https://ziglang.org/)，在macOS、Windows和Linux上也可通过`pip3 install ziglang`从PyPI安装zig
2. 通过rustup安装Rust目标，例如：`rustup target add aarch64-unknown-linux-gnu`
3. 运行`cargo zigbuild`，例如：`cargo zigbuild --target aarch64-unknown-linux-gnu`

### 指定glibc版本

默认情况下，`*-gnu`的`--target`会让Zig隐式构建基于Zig版本的默认glibc版本（[v12到v14版本默认glibc 2.28](https://github.com/ziglang/zig/blob/0.14.1/lib/std/Target.zig#L473)）。

要为特定最低glibc版本构建，可在`--target`值后添加版本后缀。例如，为glibc 2.17编译`--target aarch64-unknown-linux-gnu`：

```bash
cargo zigbuild --target aarch64-unknown-linux-gnu.2.17
```

> [!NOTE]
> glibc版本目标功能存在[各种注意事项](https://github.com/rust-cross/cargo-zigbuild/issues/231#issuecomment-1983434802)：
> - 若未提供`--target`，则不使用Zig，命令实际运行常规`cargo build`
> - 若指定无效glibc版本，`cargo-zigbuild`不会转发`zig cc`关于所选回退版本的警告
> - 此功能不一定与在构建主机上动态链接到特定glibc版本的行为匹配
>   - 可指定版本2.32，但在仅提供2.31的主机上运行时应报错却未报错
>   - 而指定2.33在glibc 2.31主机上会正确检测为不兼容
> - 某些`RUSTFLAGS`（如`-C linker`）会退出使用Zig，而`-L path/to/files`会让Zig忽略`-C target-feature=+crt-static`
> - `-C target-feature=+crt-static`用于静态链接glibc版本**不受支持**（_上游`zig cc`缺乏支持_）

#### 提示 - `cargo zigbuild`找不到已存在的头文件（`*.h`）或库

可能需要在`cargo zigbuild`命令前添加以下环境变量，包含系统路径：
- `CFLAGS='-isystem /usr/include'`
- `RUSTFLAGS='-L /usr/lib64'`

---

`cargo zigbuild`始终使用`zig cc`的`-nostdinc`选项，排除标准头文件位置（如`/usr/include`）。当Zig配置了`--target`时，这也是默认行为，此外还会退出标准系统搜索路径。

这可能导致`cargo build`成功而`cargo zigbuild`失败（需额外配置）的常见情况：

```console
# 无法找到构建所需的头文件：
fatal error: 'libelf.h' file not found

# 无法找到要链接的共享库：
error: unable to find dynamic system library 'elf' using strategy 'no_fallback'. searched paths
```

有多种解决方法，但对于`/usr/include`等系统路径，需注意避免将系统glibc头文件与Zig自身提供的glibc头文件混合，否则会产生类似`CPATH=/usr/include`的错误：

```rust
In file included from /usr/local/lib64/python3.13/site-packages/ziglang/lib/libunwind/src/gcc_personality_v0.c:21:
In file included from /usr/local/lib64/python3.13/site-packages/ziglang/lib/libunwind/include/unwind.h:18:
In file included from /usr/include/stdint.h:26:
In file included from /usr/include/bits/libc-header-start.h:33:
/usr/include/features.h:516:9: warning: '__GLIBC_MINOR__' macro redefined [-Wmacro-redefined]
  516 | #define __GLIBC_MINOR__ 41
      |         ^
<command line>:2:9: note: previous definition is here
    2 | #define __GLIBC_MINOR__ 37
      |
```

当系统包将项目构建所需的头文件添加到`/usr/include`时，需让Zig仅对这些头文件回退到`/usr/include`，同时使用自身的glibc头文件。可通过`zig cc -isystem /usr/include`实现，对于`cargo zigbuild`，可通过环境变量`CFLAGS='-isystem /usr/include'`配置。

对于共享库的类似问题，若包将系统库安装在`/usr/lib64`，通常使用`LDFLAGS='-L /usr/lib64'`，但`rustc`和`cargo`不读取此环境变量，需为带有`build.rs`的 crate 配置搜索路径以链接动态/静态库。此时需使用`RUSTFLAGS='-L /usr/lib64'`。

#### 提示 - 验证所需最低GLIBC版本

若未剥离构建二进制文件的符号，在Linux上可运行以下脚本扫描glibc版本化符号，找到最高版本（运行所需最低版本）：

1. 创建文件**`/usr/local/bin/get-min-glibc`:**

   ```bash
   #!/bin/bash
   
   FILE_NAME=$1
   readelf -W --version-info --dyn-syms ${FILE_NAME} \
     | grep 'Name: GLIBC' \
     | sed -re 's/.*GLIBC_(.+) Flags.*/\1/g' \
     | sort -t . -k1,1n -k2,2n \
     | tail -n 1
   ```

2. 使脚本可执行：

   ```bash
   chmod +x /usr/local/bin/get-min-glibc
   ```

3. 使用可执行文件/库路径运行命令：

   ```console
   $ get-min-glibc target/x86_64-unknown-linux-gnu/release/hello-world
   2.28
   ```

### macOS universal2目标

`cargo-zigbuild`支持特殊的`universal2-apple-darwin`目标，在Rust 1.64.0及更高版本上构建macOS universal2二进制文件/库。

```bash
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
cargo zigbuild --target universal2-apple-darwin
```

> **注意**
>
> 目前Cargo的`--message-format`选项在universal2目标上不工作。

## 注意事项

1. 目前仅支持Linux和macOS目标，其他目标平台若可正常工作可添加，欢迎提交PR
2. CI仅定期测试当前Rust**stable**和**nightly**版本，其他版本可能不工作

上游zig的已知[问题](https://github.com/ziglang/zig/labels/zig%20cc)：

1. [zig cc: 根据clang解析`-target`和`-mcpu`/`-march`/`-mtune`标志](https://github.com/ziglang/zig/issues/4911)：
   某些Rust目标不被`zig cc`识别（如`armv7-unknown-linux-gnueabihf`），在[#58](https://github.com/rust-cross/cargo-zigbuild/pull/58)中通过使用`-mcpu=generic`和显式传递目标功能作为 workaround
2. [交叉编译时链接darwin框架（如CoreFoundation）的能力](https://github.com/ziglang/zig/issues/1349)：
   设置`SDKROOT`环境变量为macOS SDK路径作为 workaround
3. [zig缺少某些`compiler_rt`函数](https://github.com/ziglang/zig/issues/1290)，可能导致某些目标出现未定义符号错误。另见：[zig compiler-rt状态](https://github.com/ziglang/zig/blob/master/lib/compiler_rt/README.md)
4. [CPU功能未传递给clang](https://github.com/ziglang/zig/issues/10411)

## 许可证

本作品以MIT许可证发布。许可证副本见[LICENSE](./LICENSE)文件。
