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
            
            echo "请选择版本:"
            echo "1) 免费版 (默认加速地址: docker.xuanyuan.me)"
            echo "2) 专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
            read -p "请输入选择 [1/2]: " choice
            
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
            cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list
}
EOF
            
            sudo systemctl daemon-reexec || true
            sudo systemctl restart docker || true
            
            echo ">>> [6/8] 安装完成！"
            echo "Docker 镜像加速已配置完成"
            exit 0
        fi
    else
        echo "Docker 版本 $DOCKER_VERSION 满足要求 (>= 20.0)"
        echo "跳过 Docker 安装，直接配置镜像加速..."
        
        echo ">>> [5/8] 配置国内镜像加速..."
        
        echo "请选择版本:"
        echo "1) 免费版 (默认加速地址: docker.xuanyuan.me)"
        echo "2) 专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
        read -p "请输入选择 [1/2]: " choice
        
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
        cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "Docker 镜像加速已配置完成"
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
    
    # 首先更新过期的 GPG 密钥
    echo "正在更新过期的 GPG 密钥..."
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
    
    # 更新软件包列表，允许未认证的包
    apt-get update --allow-unauthenticated || true
    
    # 安装必要的依赖包，允许未认证的包
    apt-get install -y --allow-unauthenticated ca-certificates curl gnupg lsb-release apt-transport-https
    
    # 添加 Docker 官方 GPG 密钥
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    
    # 添加 Docker 仓库（使用 Debian 9 兼容的源）
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian stretch stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 再次更新，这次包含 Docker 仓库
    apt-get update --allow-unauthenticated || true
    
    echo ">>> [3/8] 安装 Docker CE 兼容版本..."
    apt-get install -y --allow-unauthenticated docker-ce docker-ce-cli containerd.io
    
    echo ">>> [3.5/8] 安装 Docker Compose 兼容版本..."
    # Debian 9 使用较老版本的 docker-compose
    echo "正在下载兼容的 Docker Compose..."
    
    DOCKER_COMPOSE_DOWNLOADED=false
    
    # 尝试下载兼容版本
    if curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从 GitHub 下载兼容版本成功"
    else
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

echo "请选择版本:"
echo "1) 轩辕镜像免费版 (默认加速地址: docker.xuanyuan.me)"
echo "2) 轩辕镜像专业版 (默认加速地址: 自定义专属免登录地址 + docker.xuanyuan.me)"
read -p "请输入选择 [1/2]: " choice

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
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": $mirror_list
}
EOF

sudo systemctl daemon-reexec || true
sudo systemctl restart docker || true

echo ">>> [6/8] 安装完成！"
echo "Docker 镜像加速已配置完成"

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
        echo "  - https://docker.xuanyuan.me (备用)"
    else
        echo "  - https://docker.xuanyuan.me"
    fi
    
    echo ""
    echo "🎉 安装和配置完成！"
else
    echo "❌ Docker 服务启动失败，请检查配置"
    exit 1
fi
