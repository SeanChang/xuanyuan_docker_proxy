# Docker 部署 devkitARM：轻松搭建掌机自制程序编译环境

![Docker 部署 devkitARM：轻松搭建掌机自制程序编译环境](https://imgs.xuanyuan.cloud/docker/blog/devkitarm/devkitarm.webp)

*分类: Docker部署教程 | 标签: devkitARM,devkitpro/devkitarm,Docker,轩辕镜像,交叉编译,部署教程 | 发布时间: 2026-10-28 16:00:52*

> devkitARM 是一款面向掌机自制程序的开源交叉编译工具链，旨在为 Game Boy Advance、Nintendo DS、Nintendo 3DS、GP32 和 GP2X 提供编译器与开发库，并把源码编译成对应平台的程序文件。本文将介绍如何通过 Docker Compose 部署 devkitARM，搭建掌机自制程序编译环境，帮助开发者在容器里编译这些程序，适合不想在本机安装整套工具链，以及要在持续集成里固定工具链的场景。

## devkitARM 是什么

devkitARM 是 devkitPro 提供的 ARM 交叉编译工具链，用来为 Game Boy Advance、Nintendo DS、Nintendo 3DS、GP32 和 GP2X 编写自制程序。官方 Docker 镜像以 Debian 12 为底，预先装入这套工具链和对应平台的开发库，本机不必再单独安装编译器。

和在本机逐项安装编译器、库和构建脚本相比，镜像按同一份构建文件把这些组件装进同一个环境。devkitPro 的 devkitPPC 面向 GameCube、Wii 和 Wii U，devkitA64 面向 Nintendo Switch，软件包组合和这份镜像不同。

## devkitARM 能做什么

- **编译 GBA 程序**：把源码编成 Game Boy Advance 的程序文件。
- **编译 NDS 与 3DS 程序**：在同一套环境里编译 Nintendo DS 和 Nintendo 3DS 的自制程序。
- **编译 GP32 与 GP2X 程序**：把这两款掌机的源码编成对应的程序文件。
- **反复编译挂载目录里的源码**：源码和产物留在本机目录，改完可以再编译。
- **使用镜像里已有的移植库**：NDS、3DS 和 armv4t 的移植库随开发包装进镜像。

## 为什么要使用 devkitARM

在每台电脑上安装这套工具链时，要处理包管理器、依赖和路径。Windows、macOS 和 Linux 的安装位置经常不一致。工具链体积也大，持续集成里每台构建机再装一遍，版本会跟着安装时间变化。

拉取镜像之后，宿主机不必安装 devkitARM，也可以在容器里编出程序文件。适合写掌机自制程序、又不想在每台电脑上维护一整套交叉编译器的人。

## 使用 Docker 部署 devkitARM

Docker 可以把这套编译环境跑起来。部署前准备好 Docker，并准备好要编译的源码。这个镜像没有网页，编译是否完成要看目录里的程序文件。

接下来用 Docker Compose 挂载源码目录，让容器留在后台，再在容器里完成编译。

## 环境要求

本文命令使用标签 **20260610**。这是 2026-06-10 推送的构建。这次在 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）上拉取并启动，容器内编译器是 **devkitARM GCC 16.1.0**。

Dockerfile 以 `debian:bookworm-slim` 为底，安装 make、cmake、ninja、git、Python 3 等构建工具，以及 devkitPro 的包管理器，然后安装 `gba-dev`、`nds-dev`、`3ds-dev`、`gp32-dev`、`gp2x-dev`，以及 `3ds-portlibs`、`nds-portlibs`、`armv4t-portlibs`。

`DEVKITPRO` 是 `/opt/devkitpro`，`DEVKITARM` 是 `/opt/devkitpro/devkitARM`。镜像没有设置 `USER`，容器以 root 运行。Docker Hub 列出 `linux/amd64` 的压缩体积为 536821606 字节，`linux/arm64` 为 519213273 字节。解压后的占用比压缩体积大，拉取前确认磁盘有富余空间。镜像不监听端口。

| 项目 | 建议 |
|------|------|
| 系统 | Linux。macOS 把工作目录换成 `~/docker/devkitarm` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **amd64**、**arm64**。命令使用多架构标签 `20260610` |
| 磁盘 | 至少能放下上述压缩体积，并留出解压和工作目录的空间 |
| 端口 | 不映射。没有网页 |
| 工作目录 | `/www/wwwroot/devkitarm` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

## 标签怎么选

新安装使用 **`20260610`**。devkitPro 的这份镜像用构建日期做标签，格式是 `YYYYMMDD`，不是 devkitARM 编译器自己的发行号。容器里的编译器版本见「编译 GBA 示例」。

Docker Hub 上 `latest` 和 `20260610` 目前指向同一份镜像索引。下次构建后，`latest` 会改指向新日期，`20260610` 仍是这一天的构建。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`20260610`** | 2026-06-10 的构建，amd64 与 arm64 | **是** |
| `latest` | 浮动标签，目前与 `20260610` 相同 | 否 |
| 更早的 `YYYYMMDD` | 旧的构建日期 | 否。项目必须使用更早的构建时再改，并同时改拉取命令、`compose.yaml` 和 `docker run` |

完整标签见[标签列表](https://xuanyuan.cloud/r/devkitpro/devkitarm/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**。

```bash
docker pull docker.xuanyuan.run/devkitpro/devkitarm:20260610
```

Ubuntu 24.04 上拉取完成：

```text
20260610: Pulling from devkitpro/devkitarm
3c5026e520ae: Pull complete
74701f26999d: Pull complete
59e22667830b: Pull complete
ea5d3216df1f: Pull complete
956ab3702a6f: Download complete
Digest: sha256:116afba8df8453961de2936ffab20dd441edf4d682856c1ec8b0e53d7ed0bbf5
Status: Downloaded newer image for docker.xuanyuan.run/devkitpro/devkitarm:20260610
docker.xuanyuan.run/devkitpro/devkitarm:20260610
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。压缩体积见「环境要求」。

## Docker Compose 部署

镜像没有长期运行的业务进程。Compose 里把命令写成 `sleep infinity`，容器才会留在后台，再用 `docker compose exec` 反复编译。

源码目录在宿主机上叫 `template`，挂到容器内的 `/template`。官方 Makefile 用当前目录名作为程序名，所以产物文件名是 `template.elf` 和 `template.gba`。目录如果改名，这两个文件名会跟着变。

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/devkitarm` |
| **macOS** | **`~/docker/devkitarm`** |

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| `template/` | `/template` | 源码、Makefile 和编译产物 |

下面两份文件对应 [gba-examples 的 template 目录](https://github.com/devkitPro/gba-examples/tree/435346171d820c0a6eb021b90e58032d88d30244/template) 提交 `435346171d820c0a6eb021b90e58032d88d30244`。`source/template.c` 在画面中间打印 Hello World。

不要把带制表符的原文直接粘进交互式 bash。bash 会把 Tab 补成当前目录里的路径，文件内容会变掉。下面的源码用空格缩进。Makefile 里以 `%%` 开头的行，由 sed 换成制表符。

1. 创建工作目录，并把目录交给当前用户：

```bash
sudo mkdir -p /www/wwwroot/devkitarm/template/source
sudo chown -R "$USER":"$USER" /www/wwwroot/devkitarm
cd /www/wwwroot/devkitarm
```

2. 写入官方示例源码：

```bash
cat > template/source/template.c <<'EOF'

#include <gba_console.h>
#include <gba_video.h>
#include <gba_interrupt.h>
#include <gba_systemcalls.h>
#include <gba_input.h>
#include <stdio.h>
#include <stdlib.h>

//---------------------------------------------------------------------------------
// Program entry point
//---------------------------------------------------------------------------------
int main(void) {
//---------------------------------------------------------------------------------


    // the vblank interrupt must be enabled for VBlankIntrWait() to work
    // since the default dispatcher handles the bios flags no vblank handler
    // is required
    irqInit();
    irqEnable(IRQ_VBLANK);

    consoleDemoInit();

    // ansi escape sequence to set print co-ordinates
    // /x1b[line;columnH
    iprintf("x1b[10;10HHello World!
");

    while (1) {
        VBlankIntrWait();
    }
}

EOF
```

3. 写入 Makefile。sed 把行首的 `%%` 换成制表符：

```bash
sed 's/^%%/	/' <<'EOF' > template/Makefile
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/gba_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# DATA is a list of directories containing binary data
# GRAPHICS is a list of directories containing files to be processed by grit
#
# All directories are specified relative to the project directory where
# the makefile is found
#
#---------------------------------------------------------------------------------
TARGET  := $(notdir $(CURDIR))
BUILD  := build
SOURCES  := source
INCLUDES := include
DATA  :=
MUSIC  :=

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH := -mthumb -mthumb-interwork

CFLAGS := -g -Wall -O2
  -mcpu=arm7tdmi -mtune=arm7tdmi
  $(ARCH)

CFLAGS += $(INCLUDE)

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS := -g $(ARCH)
LDFLAGS = -g $(ARCH) -Wl,-Map,$(notdir $*.map)

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS := -lmm -lgba


#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS := $(LIBGBA)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------


ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT := $(CURDIR)/$(TARGET)

export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) 
   $(foreach dir,$(DATA),$(CURDIR)/$(dir)) 
   $(foreach dir,$(GRAPHICS),$(CURDIR)/$(dir))

export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES  := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES  := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

ifneq ($(strip $(MUSIC)),)
 export AUDIOFILES := $(foreach dir,$(notdir $(wildcard $(MUSIC)/*.*)),$(CURDIR)/$(MUSIC)/$(dir))
 BINFILES += soundbank.bin
endif

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
 export LD := $(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
 export LD := $(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES_BIN := $(addsuffix .o,$(BINFILES))

export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export OFILES := $(OFILES_BIN) $(OFILES_SOURCES)

export HFILES := $(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE := $(foreach dir,$(INCLUDES),-iquote $(CURDIR)/$(dir)) 
     $(foreach dir,$(LIBDIRS),-I$(dir)/include) 
     -I$(CURDIR)/$(BUILD)

export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
%%@[ -d $@ ] || mkdir -p $@
%%@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
%%@echo clean ...
%%@rm -fr $(BUILD) $(TARGET).elf $(TARGET).gba


#---------------------------------------------------------------------------------
else

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------

$(OUTPUT).gba : $(OUTPUT).elf

$(OUTPUT).elf : $(OFILES)

$(OFILES_SOURCES) : $(HFILES)

#---------------------------------------------------------------------------------
# The bin2o rule should be copied and modified
# for each extension used in the data directories
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# rule to build soundbank from music files
#---------------------------------------------------------------------------------
soundbank.bin soundbank.h : $(AUDIOFILES)
#---------------------------------------------------------------------------------
%%@mmutil $^ -osoundbank.bin -hsoundbank.h

#---------------------------------------------------------------------------------
# This rule links in binary data with the .bin extension
#---------------------------------------------------------------------------------
%.bin.o %_bin.h : %.bin
#---------------------------------------------------------------------------------
%%@echo $(notdir $<)
%%@$(bin2o)


-include $(DEPSDIR)/*.d
#---------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------
EOF
```

4. 确认命令行以制表符开头。没有输出时，不要继续编译：

```bash
grep -n $'^	@' template/Makefile
```

这次列出 7 行。行首是制表符，终端里看起来像空格：

```text
117:	@[ -d $@ ] || mkdir -p $@
118:	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
122:	@echo clean ...
123:	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).gba
149:	@mmutil $^ -osoundbank.bin -hsoundbank.h
156:	@echo $(notdir $<)
157:	@$(bin2o)
```

5. 写入 `compose.yaml`：

```bash
cat > compose.yaml <<'EOF'
services:
  devkitarm:
    image: docker.xuanyuan.run/devkitpro/devkitarm:20260610
    container_name: devkitarm
    working_dir: /template
    volumes:
      - ./template:/template
    command: ["sleep", "infinity"]
    restart: unless-stopped
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 具体日期标签 `20260610` |
| `working_dir` | `/template`。目录名决定产物文件名 |
| `volumes` | 宿主机 `./template` 对应容器 `/template` |
| `command` | `sleep infinity`，让编译环境留在后台 |
| `restart` | 进程退出后再次拉起 |
| 端口 | 不映射 |

6. 启动容器：

```bash
docker compose up -d
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network devkitarm_default  Created  0.5s
 ✔ Container devkitarm        Started  4.4s
```

7. 查看容器状态。状态为运行中之后再编译：

```bash
docker compose ps
```

这次没有端口映射：

```text
NAME        IMAGE                                              COMMAND            SERVICE     CREATED         STATUS         PORTS
devkitarm   docker.xuanyuan.run/devkitpro/devkitarm:20260610   "sleep infinity"   devkitarm   7 seconds ago   Up 5 seconds
```

## 编译 GBA 示例

容器以 root 运行。挂载目录里新生成的文件，属主是 root。要删除这些文件时，使用 sudo。

Makefile 通过环境变量 `DEVKITARM` 找到构建规则。镜像已经设置这个变量，执行 make 时不要把它清空。上一步 `grep` 没有输出时，不要执行 make。

1. 在容器里编译：

```bash
docker compose exec devkitarm make
```

这次编译完成：

```text
template.c
linking cartridge
built ... template.gba
ROM fixed!
```

2. 在宿主机上查看这两个程序文件：

```bash
ls -l template/template.elf template/template.gba
```

`template.elf` 是 113976 字节，`template.gba` 是 55600 字节，属主都是 root：

```text
-rwxr-xr-x 1 root root 113976 Oct 28 07:36 template/template.elf
-rwxr-xr-x 1 root root  55600 Oct 28 07:36 template/template.gba
```

3. 查看编译器版本。编译器不依赖是否出现在 `PATH` 里，直接使用镜像里的路径：

```bash
docker compose exec devkitarm /opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc --version
```

版本输出是：

```text
arm-none-eabi-gcc (devkitARM) 16.1.0
Copyright (C) 2026 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

`source/template.c` 会在画面中间打印 Hello World。打开 `template.gba` 需要 Game Boy Advance 模拟器，本文不部署模拟器。

把自己的源码放进 `template/source/` 后，在同一目录再次执行 make。要清掉中间文件和程序文件时：

```bash
docker compose exec devkitarm make clean
```

## 更换标签

要换构建日期时，同时修改三处：`docker pull` 的标签、`compose.yaml` 里的 `image`、后面 `docker run` 的镜像参数。改完后重新拉取，再执行：

```bash
docker compose up -d
```

已经生成的 `template.gba` 不会自动重编。需要新工具链的产物时，再执行一次 make。

## 备选：docker run

没有 Compose 时，用一次 `docker run` 编译。「Docker Compose 部署」里的源码和 Makefile 需要已经写好。`--rm` 会在 make 结束后删除容器，源码和产物留在宿主机目录里。

Compose 容器已经在运行时，继续用 `docker compose exec`，不要再开一个容器写同一个目录。

```bash
docker run --rm 
  --name devkitarm-build 
  -v /www/wwwroot/devkitarm/template:/template 
  -w /template 
  docker.xuanyuan.run/devkitpro/devkitarm:20260610 
  make
```

macOS 把 `-v` 前面的目录换成 `~/docker/devkitarm/template`。

查看产物：

```bash
ls -l /www/wwwroot/devkitarm/template/template.gba
```

## 常见问题

### make 报 empty variable name

交互式 bash 会把粘贴内容里的 Tab 当成路径补全。制表符会变成 `template/` 或 `template/source/` 这类路径，Makefile 和 `template.c` 都会写坏。这次 make 停在：

```text
Makefile:94: *** empty variable name.  Stop.
```

随后查看产物，两个文件都不存在：

```text
ls: cannot access 'template/template.elf': No such file or directory
ls: cannot access 'template/template.gba': No such file or directory
```

容器可以继续用。回到「Docker Compose 部署」，用那里的 sed 命令覆盖 Makefile，用空格缩进覆盖 `template.c`，再执行 `grep -n $'^	@' template/Makefile`。有输出之后再 `docker compose exec devkitarm make`。不要在命令行里手按 Tab。

### 浏览器打不开

这个镜像没有网页，也不映射端口。`docker compose ps` 的 PORTS 一列是空的，浏览器没有地址可开。编译是否完成，看 make 是否输出 `built ... template.gba` 和 `ROM fixed!`，以及宿主机上是否有 `template.gba`。画面在这个程序文件里，要用 Game Boy Advance 模拟器打开。

不要为了习惯把端口映射到宿主机 3000。本机的前端开发经常占用 3000，而这个容器并不监听它。

### 容器马上退出

本文的 `command` 是 `sleep infinity`。编译结束后再执行 `docker compose up -d`，容器仍在运行：

```text
[+] up 1/1
 ✔ Container devkitarm  Running  0.0s
```

若 `docker compose ps` 里状态是退出，检查 `compose.yaml` 的 `command` 是不是 `sleep infinity`，然后重新执行 `docker compose up -d`。

### make 提示设置 DEVKITARM

官方 Makefile 在 `DEVKITARM` 为空时会停止。镜像把该变量设为 `/opt/devkitpro/devkitARM`。不要在 `docker compose exec` 里加上会清空环境变量的参数。确认用的是本文的 `devkitpro/devkitarm:20260610`，而不是另外两套镜像。

### 产物文件名不是 template.gba

Makefile 用当前目录的最后一段作为程序名。工作目录是 `/template` 时，文件名才是 `template.gba`。`working_dir` 或 `docker run` 的 `-w` 如果改成别的目录，文件名会变成那个目录的名字。

### 产物文件删不掉

容器以 root 运行，`build/`、`template.elf` 和 `template.gba` 的属主是 root。在宿主机上删除时使用 sudo。不要为了改属主去改镜像里的工具链目录权限。

### 想编译 Nintendo DS 或 Nintendo 3DS

同一镜像已经安装 `nds-dev` 和 `3ds-dev`。换对应平台的官方示例和 Makefile，挂载方式可以照本文。本文只编译 GBA 的 template。

GBA 源码不要改用 `devkitpro/devkitppc` 或 `devkitpro/devkita64`。前者的软件包面向 GameCube、Wii 和 Wii U，后者面向 Nintendo Switch。这两份镜像的 Dockerfile 会安装 devkitARM 编译器，但没有本文用到的 `gba-dev` 这组软件包。

### 用 latest 可以吗

`latest` 目前和 `20260610` 是同一份镜像索引，下次构建后会改指向。本文命令使用 `20260610`。说明见「标签怎么选」。

## 命令速查

```bash
docker pull docker.xuanyuan.run/devkitpro/devkitarm:20260610

cd /www/wwwroot/devkitarm
grep -n $'^	@' template/Makefile
docker compose up -d
docker compose ps
docker compose exec devkitarm make
docker compose exec devkitarm /opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc --version
ls -l template/template.elf template/template.gba

docker compose exec devkitarm make clean
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。没有网页，也没有登录账号。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [devkitpro/devkitarm 镜像页](https://xuanyuan.cloud/zh/r/devkitpro/devkitarm) | [https://xuanyuan.cloud/zh/r/devkitpro/devkitarm](https://xuanyuan.cloud/zh/r/devkitpro/devkitarm) |
| [devkitpro/devkitarm 概览](https://xuanyuan.cloud/r/devkitpro/devkitarm) | [https://xuanyuan.cloud/r/devkitpro/devkitarm](https://xuanyuan.cloud/r/devkitpro/devkitarm) |
| [devkitpro/devkitarm 标签列表](https://xuanyuan.cloud/r/devkitpro/devkitarm/tags) | [https://xuanyuan.cloud/r/devkitpro/devkitarm/tags](https://xuanyuan.cloud/r/devkitpro/devkitarm/tags) |
| [Docker Hub · devkitpro/devkitarm](https://hub.docker.com/r/devkitpro/devkitarm) | [https://hub.docker.com/r/devkitpro/devkitarm](https://hub.docker.com/r/devkitpro/devkitarm) |
| [GitHub · devkitPro/docker](https://github.com/devkitPro/docker) | [https://github.com/devkitPro/docker](https://github.com/devkitPro/docker) |
| [devkitarm Dockerfile](https://github.com/devkitPro/docker/blob/master/devkitarm/Dockerfile) | [https://github.com/devkitPro/docker/blob/master/devkitarm/Dockerfile](https://github.com/devkitPro/docker/blob/master/devkitarm/Dockerfile) |
| [gba-examples template](https://github.com/devkitPro/gba-examples/tree/435346171d820c0a6eb021b90e58032d88d30244/template) | [https://github.com/devkitPro/gba-examples/tree/435346171d820c0a6eb021b90e58032d88d30244/template](https://github.com/devkitPro/gba-examples/tree/435346171d820c0a6eb021b90e58032d88d30244/template) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/devkitarm-docker-deploy)

*本文基于 [devkitpro/devkitarm:20260610](https://xuanyuan.cloud/zh/r/devkitpro/devkitarm)，实测编译器 **devkitARM GCC 16.1.0**，测试平台 **Ubuntu 24.04** Linux。*


