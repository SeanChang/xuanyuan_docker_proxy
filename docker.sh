#!/bin/bash
set -e

# 检查是否安装了 sudo，如果没有则创建一个函数来模拟 sudo
if ! command -v sudo &> /dev/null; then
    echo "⚠️  未检测到 sudo 命令，将直接使用 root 权限执行命令"
    # 创建一个模拟 sudo 的函数
    sudo() {
        "$@"
    }
    export -f sudo
else
    echo "✅ 检测到 sudo 命令"
fi

echo "=========================================="
echo "🐳 欢迎使用轩辕镜像 Docker 一键安装配置脚本"
echo "=========================================="
echo "官方网站: https://xuanyuan.cloud/"
echo ""
echo "请选择操作模式："
echo "1) 一键安装配置（推荐）"
echo "2) 修改轩辕镜像专属加速地址"
echo ""
# 循环等待用户输入有效选择
while true; do
    read -p "请输入选择 [1/2]: " mode_choice
    
    if [[ "$mode_choice" == "1" ]]; then
        echo ""
        echo ">>> 模式：一键安装配置"
        echo ""
        break
    elif [[ "$mode_choice" == "2" ]]; then
        echo ""
        echo ">>> 模式：仅修改镜像加速地址"
        echo ""
        
        # 检查 Docker 是否已安装
        if ! command -v docker &> /dev/null; then
            echo "❌ 检测到 Docker 未安装！"
            echo ""
            echo "⚠️  风险提示："
            echo "   - 无法验证镜像加速配置是否生效"
            echo "   - 可能导致后续 Docker 操作失败"
            echo "   - 建议先完成 Docker 安装"
            echo ""
            echo "💡 建议：选择选项 1 进行一键安装配置"
            echo ""
            echo "已退出脚本，请重新运行并选择选项 1 进行完整安装配置"
            exit 1
        else
            # 检查 Docker 版本
            DOCKER_VERSION=$(docker --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
            MAJOR_VERSION=$(echo $DOCKER_VERSION | cut -d. -f1)
            
            if [[ "$MAJOR_VERSION" -lt 20 ]]; then
                echo "⚠️  检测到 Docker 版本 $DOCKER_VERSION 低于 20.0"
                echo ""
                echo "⚠️  风险提示："
                echo "   - 低版本 Docker 可能存在安全漏洞"
                echo "   - 某些新功能可能不可用"
                echo "   - 建议升级到 Docker 20+ 版本"
                echo ""
                echo "💡 建议：选择选项 1 进行一键安装配置和升级"
                echo ""
                read -p "是否仍要继续？[y/N]: " continue_choice
                if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
                    echo "已取消操作，建议选择选项 1 进行完整安装配置"
                    exit 0
                fi
            fi
        fi
        
        echo ""
        echo ">>> 配置轩辕镜像加速地址"
        echo ""
        echo "请选择版本："
        echo "1) 轩辕镜像免费版 (默认加速地址: docker.xuanyuan.me)"
        echo "2) 轩辕镜像专业版 (自定义专属免登录地址 + docker.xuanyuan.me)"
        # 循环等待用户输入有效选择
        while true; do
            read -p "请输入选择 [1/2]: " choice
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            else
                echo "❌ 无效选择，请输入 1 或 2"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
            read -p "请输入您的专属免登录地址 (格式如 xxx.xuanyuan.run): " custom_domain
            # 生成对应的 .dev 域名
            custom_domain_dev="${custom_domain%.run}.dev"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev",
  "https://docker.xuanyuan.me"
]
EOF
)
        else
            mirror_list=$(cat <<EOF
[
  "https://docker.xuanyuan.me"
]
EOF
)
        fi
        
        # 创建 Docker 配置目录
        mkdir -p /etc/docker
        
        # 备份现有配置
        if [ -f /etc/docker/daemon.json ]; then
            sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
            echo "✅ 已备份现有配置到 /etc/docker/daemon.json.backup.*"
        fi
        
        # 写入新配置
        
        # 根据用户选择设置 insecure-registries
        if [[ "$choice" == "2" ]]; then
          insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev",
  "docker.xuanyuan.me"
]
EOF
)
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        cat <<EOF | tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries
}
EOF
        
        echo "✅ 镜像加速配置已更新"
        echo ""
        echo "当前配置的镜像源："
        if [[ "$choice" == "2" ]]; then
            echo "  - https://$custom_domain (优先)"
            echo "  - https://$custom_domain_dev (优先)"
            echo "  - https://docker.xuanyuan.me (备用)"
        else
            echo "  - https://docker.xuanyuan.me"
        fi
        echo ""
        
        # 如果 Docker 服务正在运行，重启以应用配置
        if systemctl is-active --quiet docker 2>/dev/null; then
            echo "正在重启 Docker 服务以应用新配置..."
            systemctl daemon-reexec || true
            systemctl restart docker || true
            
            # 等待服务启动
            sleep 3
            
            if systemctl is-active --quiet docker; then
                echo "✅ Docker 服务重启成功，新配置已生效"
            else
                echo "❌ Docker 服务重启失败，请手动重启"
            fi
        else
            echo "⚠️  Docker 服务未运行，配置将在下次启动时生效"
        fi
        
        echo ""
        echo "🎉 镜像加速配置完成！"
        exit 0
    else
        echo "❌ 无效选择，请输入 1 或 2"
        echo ""
    fi
done

echo ">>> 模式：一键安装配置"
echo ""

echo ">>> [1/8] 检查系统信息..."
OS=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
ARCH=$(uname -m)
VERSION_ID=$(awk -F= '/^VERSION_ID=/{print $2}' /etc/os-release | tr -d '"')
echo "系统: $OS $VERSION_ID 架构: $ARCH"

echo ">>> [1.5/8] 检查 Docker 安装状态..."
if command -v docker &> /dev/null; then
    echo "检测到 Docker 已安装"
    DOCKER_VERSION=$(docker --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    echo "当前 Docker 版本: $DOCKER_VERSION"
    
    # 提取主版本号进行比较
    MAJOR_VERSION=$(echo $DOCKER_VERSION | cut -d. -f1)
    
    if [[ "$MAJOR_VERSION" -lt 20 ]]; then
        echo "警告: 当前 Docker 版本 $DOCKER_VERSION 低于 20.0"
        echo "建议升级到 Docker 20+ 版本以获得更好的性能和功能"
        read -p "是否要升级 Docker? [y/N]: " upgrade_choice
        
        if [[ "$upgrade_choice" =~ ^[Yy]$ ]]; then
            echo "用户选择升级 Docker，继续执行安装流程..."
        else
            echo "用户选择不升级，跳过 Docker 安装"
                    echo ">>> [5/8] 配置轩辕镜像加速..."
        
        # 循环等待用户选择镜像版本
        while true; do
            echo "请选择版本:"
            echo "1) 免费版 (默认加速地址: docker.xuanyuan.me)"
            echo "2) 专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
            read -p "请输入选择 [1/2]: " choice
            
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            else
                echo "❌ 无效选择，请输入 1 或 2"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
          read -p "请输入您的专属免登录地址 (格式如 xxx.xuanyuan.run): " custom_domain
          mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://docker.xuanyuan.me"
]
EOF
)
        else
          mirror_list=$(cat <<EOF
[
  "https://docker.xuanyuan.me"
]
EOF
)
        fi
        
        sudo mkdir -p /etc/docker

        # 根据用户选择设置 insecure-registries
        if [[ "$choice" == "2" ]]; then
          insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev",
  "docker.xuanyuan.me"
]
EOF
)
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "🎉Docker 镜像加速已配置完成"
        echo "轩辕镜像 - 中国开发者首选的专业 Docker 镜像下载加速服务平台"
        echo "官方网站: https://xuanyuan.cloud/"
        
        # 显示当前配置的镜像源
        echo ""
        echo "当前配置的镜像源："
        if [[ "$choice" == "2" ]]; then
            echo "  - https://$custom_domain (优先)"
            echo "  - https://$custom_domain_dev (优先)"
            echo "  - https://docker.xuanyuan.me (备用)"
        else
            echo "  - https://docker.xuanyuan.me"
        fi
        echo ""
        
        # 继续执行完整的流程，不在这里退出
        fi
    else
        echo "Docker 版本 $DOCKER_VERSION 满足要求 (>= 20.0)"
        echo "跳过 Docker 安装，直接配置镜像加速..."
        
        echo ">>> [5/8] 配置国内镜像加速..."
        
        # 循环等待用户选择镜像版本
        while true; do
            echo "请选择版本:"
            echo "1) 免费版 (默认加速地址: docker.xuanyuan.me)"
            echo "2) 专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
            read -p "请输入选择 [1/2]: " choice
            
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            else
                echo "❌ 无效选择，请输入 1 或 2"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
          read -p "请输入您的专属免登录地址 (格式如 xxx.xuanyuan.run): " custom_domain
          # 生成对应的 .dev 域名
          custom_domain_dev="${custom_domain%.run}.dev"
          mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev",
  "https://docker.xuanyuan.me"
]
EOF
)
        else
          mirror_list=$(cat <<EOF
[
  "https://docker.xuanyuan.me"
]
EOF
)
        fi
        
        sudo mkdir -p /etc/docker

        # 根据用户选择设置 insecure-registries
        if [[ "$choice" == "2" ]]; then
          insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev",
  "docker.xuanyuan.me"
]
EOF
)
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "🎉Docker 镜像加速已配置完成"
        echo "轩辕镜像 - 中国开发者首选的专业 Docker 镜像下载加速服务平台"
        echo "官方网站: https://xuanyuan.cloud/"
        exit 0
    fi
else
    echo "未检测到 Docker，将进行全新安装"
fi

echo ">>> [2/8] 配置国内 Docker 源..."
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
  # 检查 Debian 版本，为老版本提供兼容性支持
  if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
    echo "⚠️  检测到 Debian 9 (Stretch)，使用兼容的安装方法..."
    echo "⚠️  注意：Debian 9 已到达生命周期结束，将使用特殊处理..."
    
    # 清理损坏的软件源索引文件
    echo "正在清理损坏的软件源索引文件..."
    rm -rf /var/lib/apt/lists/*
    rm -rf /var/lib/apt/lists/partial/*
    
    # 强制清理 apt 缓存
    apt-get clean
    apt-get autoclean
    
    # 首先尝试安装基本工具
    echo "正在安装基本工具..."
    apt-get update --allow-unauthenticated || true
    
    # 尝试安装 dirmngr 和 curl
    if apt-get install -y --allow-unauthenticated dirmngr; then
      echo "✅ dirmngr 安装成功"
    else
      echo "⚠️  dirmngr 安装失败，将使用备用方法"
    fi
    
    if apt-get install -y --allow-unauthenticated curl; then
      echo "✅ curl 安装成功"
    else
      echo "⚠️  curl 安装失败，将使用备用方法"
    fi
    
    # 如果 curl 安装失败，尝试使用 wget 作为备用
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
      echo "正在安装 wget 作为 curl 的备用..."
      apt-get install -y --allow-unauthenticated wget || true
    fi
    
    # 现在尝试更新过期的 GPG 密钥
    echo "正在更新过期的 GPG 密钥..."
    if command -v dirmngr &> /dev/null; then
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 || true
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 || true
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 || true
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A || true
      
      # 尝试使用不同的密钥服务器
      echo "尝试使用备用密钥服务器..."
      apt-key adv --keyserver pgpkeys.mit.edu --recv-keys 648ACFD622F3D138 || true
      apt-key adv --keyserver pgpkeys.mit.edu --recv-keys 0E98404D386FA1D9 || true
    else
      echo "⚠️  dirmngr 不可用，跳过 GPG 密钥更新"
    fi
    
    # 更新软件包列表，允许未认证的包，移除不支持的选项
    echo "正在更新软件包列表..."
    apt-get update --allow-unauthenticated || true
    
    # 如果还是失败，尝试强制更新
    if ! apt-get update --allow-unauthenticated; then
      echo "⚠️  软件源更新失败，尝试强制更新..."
      apt-get update --allow-unauthenticated --fix-missing || true
    fi
    
    # 安装必要的依赖包，允许未认证的包
    echo "正在安装必要的依赖包..."
    apt-get install -y --allow-unauthenticated --fix-broken ca-certificates gnupg lsb-release apt-transport-https || true
    
    # 如果某些包安装失败，尝试逐个安装
    if ! dpkg -l | grep -q "ca-certificates"; then
      echo "尝试单独安装 ca-certificates..."
      apt-get install -y --allow-unauthenticated ca-certificates || true
    fi
    
    if ! dpkg -l | grep -q "gnupg"; then
      echo "尝试单独安装 gnupg..."
      apt-get install -y --allow-unauthenticated gnupg || true
    fi
    
    # 添加 Docker 官方 GPG 密钥
    echo "正在添加 Docker 官方 GPG 密钥..."
    if command -v curl &> /dev/null; then
      curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - || true
    elif command -v wget &> /dev/null; then
      wget -qO- https://download.docker.com/linux/debian/gpg | apt-key add - || true
    else
      echo "❌ 无法下载 Docker GPG 密钥，curl 和 wget 都不可用"
    fi
    
    # 添加 Docker 仓库（使用 Debian 9 兼容的源）
    echo "正在添加 Docker 仓库..."
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian stretch stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 再次更新，这次包含 Docker 仓库
    echo "正在更新包含 Docker 仓库的软件包列表..."
    apt-get update --allow-unauthenticated || true
    
    echo ">>> [3/8] 安装 Docker CE 兼容版本..."
    echo "正在安装 Docker CE..."
    apt-get install -y --allow-unauthenticated --fix-broken docker-ce docker-ce-cli containerd.io || true
    
    # 检查 Docker 是否安装成功
    if command -v docker &> /dev/null; then
      echo "✅ Docker CE 安装成功"
    else
      echo "❌ Docker CE 安装失败，尝试备用方法..."
      # 尝试从二进制包安装
      echo "正在下载 Docker 二进制包..."
      if command -v curl &> /dev/null; then
        curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.24.tgz -o /tmp/docker.tgz
      elif command -v wget &> /dev/null; then
        wget -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-20.10.24.tgz
      else
        echo "❌ 无法下载 Docker 二进制包，curl 和 wget 都不可用"
      fi
      
      if [ -f /tmp/docker.tgz ]; then
        echo "正在解压 Docker 二进制包..."
        tar -xzf /tmp/docker.tgz -C /tmp
        cp /tmp/docker/* /usr/bin/
        chmod +x /usr/bin/docker*
        echo "✅ Docker CE 二进制安装成功"
      else
        echo "❌ Docker 二进制下载失败"
      fi
    fi
    
    echo ">>> [3.5/8] 安装 Docker Compose 兼容版本..."
    # Debian 9 使用较老版本的 docker-compose
    echo "正在下载兼容的 Docker Compose..."
    
    DOCKER_COMPOSE_DOWNLOADED=false
    
    # 尝试下载兼容版本
    if command -v curl &> /dev/null; then
      if curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从 GitHub 下载兼容版本成功"
      fi
    elif command -v wget &> /dev/null; then
      if wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" --timeout=30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从 GitHub 下载兼容版本成功"
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "❌ GitHub 下载失败，尝试包管理器安装..."
      if apt-get install -y --allow-unauthenticated docker-compose; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 通过包管理器安装 docker-compose 成功"
      else
        echo "❌ 包管理器安装也失败了"
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
      chmod +x /usr/local/bin/docker-compose
      ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
      echo "✅ Docker Compose 兼容版本安装完成"
    else
      echo "❌ Docker Compose 安装失败"
    fi
    
  else
    # 现代版本的 Ubuntu/Debian 使用标准安装方法
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://mirrors.tencent.com/docker-ce/linux/$OS/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tencent.com/docker-ce/linux/$OS \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    echo ">>> [3/8] 安装 Docker CE 最新版..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

    echo ">>> [3.5/8] 安装 Docker Compose..."
    # 安装最新版本的 docker-compose，使用多个备用下载源
    echo "正在下载 Docker Compose..."
    
    # 尝试多个下载源
    DOCKER_COMPOSE_DOWNLOADED=false
    
    # 源1: 阿里云镜像
    echo "尝试从阿里云镜像下载..."
    if sudo curl -L "https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从阿里云镜像下载成功"
    else
      echo "❌ 阿里云镜像下载失败，尝试下一个源..."
    fi
    
    # 源2: 腾讯云镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从腾讯云镜像下载..."
      if sudo curl -L "https://mirrors.cloud.tencent.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从腾讯云镜像下载成功"
      else
        echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
      fi
    fi
    
    # 源3: 华为云镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从华为云镜像下载..."
      if sudo curl -L "https://mirrors.huaweicloud.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从华为云镜像下载成功"
      else
        echo "❌ 华为云镜像下载失败，尝试下一个源..."
      fi
    fi
    
    # 源4: 中科大镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从中科大镜像下载..."
      if sudo curl -L "https://mirrors.ustc.edu.cn/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从中科大镜像下载成功"
      else
        echo "❌ 中科大镜像下载失败，尝试下一个源..."
      fi
    fi
    
    # 源5: 清华大学镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从清华大学镜像下载..."
      if sudo curl -L "https://mirrors.tuna.tsinghua.edu.cn/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从清华大学镜像下载成功"
      else
        echo "❌ 清华大学镜像下载失败，尝试下一个源..."
      fi
    fi
    
    # 源6: 最后尝试 GitHub (如果网络允许)
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从 GitHub 下载..."
      if sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从 GitHub 下载成功"
      else
        echo "❌ GitHub 下载失败"
      fi
    fi
    
    # 检查是否下载成功
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "❌ 所有下载源都失败了，尝试使用包管理器安装..."
      
      # 使用包管理器作为备选方案
      if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        if sudo apt-get install -y docker-compose-plugin; then
          echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
          DOCKER_COMPOSE_DOWNLOADED=true
        else
          echo "❌ 包管理器安装也失败了"
        fi
      elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "rocky" || "$OS" == "ol" ]]; then
        if sudo yum install -y docker-compose-plugin; then
          echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
          DOCKER_COMPOSE_DOWNLOADED=true
        else
          echo "❌ 包管理器安装也失败了"
        fi
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
      # 设置执行权限
      sudo chmod +x /usr/local/bin/docker-compose
      
      # 创建软链接到 PATH 目录
      sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
      
      echo "✅ Docker Compose 安装完成"
    else
      echo "❌ Docker Compose 安装失败，请手动安装"
      echo "建议访问: https://docs.docker.com/compose/install/ 查看手动安装方法"
    fi
  fi

elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "rocky" || "$OS" == "ol" ]]; then
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://mirrors.tencent.com/docker-ce/linux/centos/docker-ce.repo

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
  sudo systemctl enable docker
  sudo systemctl start docker
  
  echo ">>> [3.5/8] 安装 Docker Compose..."
  # 安装最新版本的 docker-compose，使用多个备用下载源
  echo "正在下载 Docker Compose..."
  
  # 尝试多个下载源
  DOCKER_COMPOSE_DOWNLOADED=false
  
  # 源1: 阿里云镜像
  echo "尝试从阿里云镜像下载..."
  if sudo curl -L "https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
    DOCKER_COMPOSE_DOWNLOADED=true
    echo "✅ 从阿里云镜像下载成功"
  else
    echo "❌ 阿里云镜像下载失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从腾讯云镜像下载..."
    if sudo curl -L "https://mirrors.cloud.tencent.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从腾讯云镜像下载成功"
    else
      echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从华为云镜像下载..."
    if sudo curl -L "https://mirrors.huaweicloud.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从华为云镜像下载成功"
    else
      echo "❌ 华为云镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从中科大镜像下载..."
    if sudo curl -L "https://mirrors.ustc.edu.cn/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从中科大镜像下载成功"
    else
      echo "❌ 中科大镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从清华大学镜像下载..."
    if sudo curl -L "https://mirrors.tuna.tsinghua.edu.cn/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从清华大学镜像下载成功"
    else
      echo "❌ 清华大学镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源6: 最后尝试 GitHub (如果网络允许)
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从 GitHub 下载..."
    if sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从 GitHub 下载成功"
    else
      echo "❌ GitHub 下载失败"
    fi
  fi
  
  # 检查是否下载成功
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "❌ 所有下载源都失败了，尝试使用包管理器安装..."
    
    # 使用包管理器作为备选方案
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
      if sudo apt-get install -y docker-compose-plugin; then
        echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
        DOCKER_COMPOSE_DOWNLOADED=true
      else
        echo "❌ 包管理器安装也失败了"
      fi
    elif [[ "$OS" == "centos" || "$OS" == "rhel" ]]; then
      if sudo yum install -y docker-compose-plugin; then
        echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
        DOCKER_COMPOSE_DOWNLOADED=true
      else
        echo "❌ 包管理器安装也失败了"
      fi
    fi
  fi
  
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
    # 设置执行权限
    sudo chmod +x /usr/local/bin/docker-compose
    
    # 创建软链接到 PATH 目录
    sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    echo "✅ Docker Compose 安装完成"
  else
    echo "❌ Docker Compose 安装失败，请手动安装"
    echo "建议访问: https://docs.docker.com/compose/install/ 查看手动安装方法"
  fi
else
  echo "暂不支持该系统: $OS"
  exit 1
fi

echo ">>> [5/8] 配置国内镜像加速..."

# 循环等待用户选择镜像版本
while true; do
    echo "请选择版本:"
    echo "1) 轩辕镜像免费版 (默认加速地址: docker.xuanyuan.me)"
    echo "2) 轩辕镜像专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
    read -p "请输入选择 [1/2]: " choice
    
    if [[ "$choice" == "1" || "$choice" == "2" ]]; then
        break
    else
        echo "❌ 无效选择，请输入 1 或 2"
        echo ""
    fi
done

mirror_list=""

if [[ "$choice" == "2" ]]; then
  read -p "请输入您的专属免登录地址 (格式如 xxx.xuanyuan.run): " custom_domain
  # 生成对应的 .dev 域名
  custom_domain_dev="${custom_domain%.run}.dev"
  mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev",
  "https://docker.xuanyuan.me"
]
EOF
)
else
  mirror_list=$(cat <<EOF
[
  "https://docker.xuanyuan.me"
]
EOF
)
fi

sudo mkdir -p /etc/docker

# 根据用户选择设置 insecure-registries
if [[ "$choice" == "2" ]]; then
  insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev",
  "docker.xuanyuan.me"
]
EOF
)
else
  insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
fi

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries
}
EOF

sudo systemctl daemon-reexec || true
sudo systemctl restart docker || true

echo ">>> [6/8] 安装完成！"
echo "🎉Docker 镜像加速已配置完成"
echo "轩辕镜像 - 中国开发者首选的专业 Docker 镜像下载加速服务平台"
echo "官方网站: https://xuanyuan.cloud/"

echo ">>> [7/8] 重载 Docker 配置并重启服务..."
sudo systemctl daemon-reexec || true
sudo systemctl restart docker || true

# 等待 Docker 服务完全启动
echo "等待 Docker 服务启动..."
sleep 3

# 验证 Docker 服务状态
if systemctl is-active --quiet docker; then
    echo "✅ Docker 服务已成功启动"
    echo "✅ 镜像加速配置已生效"
    
    # 显示当前配置的镜像源
    echo "当前配置的镜像源:"
    if [[ "$choice" == "2" ]]; then
        echo "  - https://$custom_domain (优先)"
        echo "  - https://$custom_domain_dev (优先)"
        echo "  - https://docker.xuanyuan.me (备用)"
    else
        echo "  - https://docker.xuanyuan.me"
    fi
    
    echo ""
    echo "🎉 安装和配置完成！"
    echo ""
    echo "轩辕镜像 - 中国开发者首选的专业 Docker 镜像下载加速服务平台"
    echo "官方网站: https://xuanyuan.cloud/"
else
    echo "❌ Docker 服务启动失败，请检查配置"
    exit 1
fi