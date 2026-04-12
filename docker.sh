#!/bin/bash
# 使用 set -e 但允许关键步骤有错误处理
set -e
# 定义错误处理函数
handle_error() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo "❌ 命令执行失败，退出码: $exit_code"
    return $exit_code
  fi
  return 0
}

# ============================================================================
# 免责声明 / Disclaimer
# ============================================================================
# 本脚本为开源代码，仅供学习和参考使用。
# 使用本脚本前，请务必：
#   1. 在本地测试环境充分测试，确认脚本功能符合预期
#   2. 在生产环境使用前，备份重要数据和配置
#   3. 了解脚本执行的操作及其可能产生的影响
#
# 虽然脚本经过充分测试，但由于系统环境差异、网络状况等因素，
# 无法保证在所有环境下都能完美运行。使用本脚本所产生的任何后果，
# 包括但不限于数据丢失、服务中断等，均由使用者自行承担。
#
# This script is open source code, provided for learning and reference purposes only.
# Before using this script, please:
#   1. Fully test in a local test environment to ensure the script functions as expected
#   2. Backup important data and configurations before using in production environments
#   3. Understand the operations performed by the script and their potential impacts
#
# Although the script has been thoroughly tested, due to differences in system
# environments, network conditions, and other factors, we cannot guarantee
# perfect operation in all environments. Any consequences arising from the use
# of this script, including but not limited to data loss and service interruptions,
# shall be borne by the user.
# ============================================================================

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

# 恢复 /etc/docker/daemon.json 中与轩辕镜像相关的配置（需交互确认）
restore_docker_daemon_config() {
  local DETECTED_RESTORE_OS
  DETECTED_RESTORE_OS=$(uname -s 2>/dev/null || echo "Unknown")
  if [[ "$DETECTED_RESTORE_OS" == "Darwin" ]]; then
    echo ""
    echo "❌ macOS 不适用本脚本修改 Linux 路径下的 /etc/docker/daemon.json。"
    echo "💡 请在 Docker Desktop「设置 → Docker Engine」中编辑或重置配置。"
    return 1
  fi
  if [[ "$DETECTED_RESTORE_OS" == MINGW* ]] || [[ "$DETECTED_RESTORE_OS" == MSYS* ]] || [[ "$DETECTED_RESTORE_OS" == CYGWIN* ]]; then
    echo ""
    echo "❌ 当前为 Windows（Git Bash / MSYS / Cygwin 等），不适用本脚本的 Linux daemon.json 路径。"
    echo "💡 请在 Docker Desktop 中配置镜像；若在 WSL 内使用 Linux，请在 WSL 内运行本脚本。"
    return 1
  fi
  if ! [[ -t 0 ]]; then
    echo ""
    echo "❌ 恢复配置需在交互式终端中运行（未检测到 TTY），已跳过，未修改任何文件。"
    return 1
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo " 恢复 Docker 镜像相关配置"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo " 将修改 /etc/docker/daemon.json：可移除轩辕镜像加速、insecure-registries，"
  echo " 以及脚本曾写入的 dns 等。之后拉取镜像将更多依赖官方 registry（视网络而定）。"
  echo " 若选择「重置为默认 {}」，当前文件中的其它自定义项也会一并清空，请谨慎。"
  echo " 💡 确认时请完整输入 yes（不区分大小写，YES / Yes 均可）；其它输入视为取消。"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  local _confirm
  local _confirm_lower
  read -r -p "确认继续恢复？输入 yes 继续，其它任意键取消: " _confirm
  _confirm_lower=$(printf '%s' "$_confirm" | tr '[:upper:]' '[:lower:]')
  if [[ "$_confirm_lower" != "yes" ]]; then
    echo "ℹ️  已取消，未修改任何文件。"
    return 0
  fi

  echo ""
  echo "请选择恢复方式："
  echo " 1) 从最新一份 daemon.json.backup.* 恢复（排除 before_restore 备份）"
  echo " 2) 重置为 Docker 默认（写入空对象 {}，不依赖备份）"
  local sub
  while true; do
    read -r -p "请输入 [1/2]: " sub
    if [[ "$sub" == "1" || "$sub" == "2" ]]; then
      break
    fi
    echo "❌ 无效选择，请输入 1 或 2"
  done

  sudo mkdir -p /etc/docker

  if [[ "$sub" == "1" ]]; then
    local latest=""
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      [[ "$line" == *before_restore* ]] && continue
      latest="$line"
      break
    done < <(ls -1t /etc/docker/daemon.json.backup.* 2>/dev/null || true)
    if [[ -z "$latest" ]] || [[ ! -f "$latest" ]]; then
      echo ""
      echo "❌ 未找到可用的 daemon.json.backup.*（不含 before_restore），无法从历史备份还原。"
      echo "💡 请重新运行本功能并选择 2) 重置为 {}，或手动编辑 /etc/docker/daemon.json。"
      return 1
    fi
    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    if [[ -f /etc/docker/daemon.json ]]; then
      sudo cp /etc/docker/daemon.json "/etc/docker/daemon.json.backup.before_restore.$ts"
      echo "✅ 已备份当前配置到 /etc/docker/daemon.json.backup.before_restore.$ts"
    fi
    sudo cp "$latest" /etc/docker/daemon.json
    echo "✅ 已从备份恢复: $latest"
  else
    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    if [[ -f /etc/docker/daemon.json ]]; then
      sudo cp /etc/docker/daemon.json "/etc/docker/daemon.json.backup.before_restore.$ts"
      echo "✅ 已备份当前配置到 /etc/docker/daemon.json.backup.before_restore.$ts"
    fi
    local _y
    read -r -p "确认将 /etc/docker/daemon.json 重置为 {}？[y/N]: " _y
    if [[ ! "$_y" =~ ^[Yy]$ ]]; then
      echo "ℹ️  已取消重置（若已生成 before_restore 备份，可自行保留或删除）。"
      return 0
    fi
    echo '{}' | sudo tee /etc/docker/daemon.json > /dev/null
    echo "✅ 已重置为 {}"
  fi

  local SCRIPT_RESTORE_SYSTEMD_OK=false
  if command -v systemctl &>/dev/null; then
    local PID1_COMM_RESTORE
    PID1_COMM_RESTORE=$(tr -d '\0' < /proc/1/comm 2>/dev/null || echo "")
    if [[ "$PID1_COMM_RESTORE" == "systemd" ]] && systemctl show-environment &>/dev/null 2>&1; then
      SCRIPT_RESTORE_SYSTEMD_OK=true
    fi
  fi
  if [[ "$SCRIPT_RESTORE_SYSTEMD_OK" == "true" ]]; then
    sudo systemctl daemon-reexec || true
    sudo systemctl restart docker || true
    echo "✅ 已尝试重载 Docker 服务"
  else
    echo "ℹ️  未检测到可用 systemd，请手动执行: sudo systemctl restart docker（或按需启动 dockerd）"
  fi
  echo ""
  echo "💡 可通过 docker info 查看 Registry Mirrors 是否已变更。"
  return 0
}

echo "=========================================="
echo "🐳 欢迎使用轩辕镜像 Docker 一键安装配置脚本"
echo "=========================================="
echo "官方网站: https://xuanyuan.cloud/"
echo ""
echo "请选择操作模式："
echo "1) 一键安装配置（推荐）"
echo "2) 修改轩辕镜像专属域名"
echo "3) 恢复 Docker 镜像相关配置"
echo ""
# 循环等待用户输入有效选择
while true; do
    read -p "请输入选择 [1/2/3]: " mode_choice
    
    if [[ "$mode_choice" == "1" ]]; then
        echo ""
        echo ">>> 模式：一键安装配置"
        
        # 检查是否已经安装了 Docker
        if command -v docker &> /dev/null; then
            DOCKER_VERSION=$(docker --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
            echo ""
            echo "⚠️  检测到系统已安装 Docker 版本: $DOCKER_VERSION"
            echo ""
            echo "⚠️  重要提示："
            echo "   选择此选项将进行 Docker 升级或重装操作"
            echo "   这可能会影响现有的 Docker 容器和数据"
            echo "   建议在操作前备份重要的容器和数据"
            echo ""
            echo "请确认是否继续："
            echo "1) 确认继续安装/升级 Docker"
            echo "2) 返回选择菜单"
            echo ""
            
            # 循环等待用户输入有效选择
            while true; do
                read -p "请输入选择 [1/2]: " confirm_choice
                
                if [[ "$confirm_choice" == "1" ]]; then
                    echo ""
                    echo "✅ 用户确认继续，将进行 Docker 安装/升级..."
                    echo ""
                    break
                elif [[ "$confirm_choice" == "2" ]]; then
                    echo ""
                    echo "🔄 返回选择菜单..."
                    echo ""
                    # 重新显示菜单选项
                    echo "请选择操作模式："
                    echo "1) 一键安装配置（推荐）"
                    echo "2) 修改轩辕镜像专属域名"
                    echo "3) 恢复 Docker 镜像相关配置"
                    echo ""
                    # 重置 mode_choice 以重新进入循环
                    mode_choice=""
                    break
                else
                    echo "❌ 无效选择，请输入 1 或 2"
                    echo ""
                fi
            done
            
            # 如果用户选择了返回菜单，继续外层循环
            if [[ "$confirm_choice" == "2" ]]; then
                continue
            fi
        fi
        
        echo ""
        break
    elif [[ "$mode_choice" == "2" ]]; then
        echo ""
        echo ">>> 模式：仅修改镜像地址"
        echo ""
        
        # 检查 Docker 是否已安装
        if ! command -v docker &> /dev/null; then
            echo "❌ 检测到 Docker 未安装！"
            echo ""
            echo "⚠️  风险提示："
            echo "   - 无法验证镜像配置是否生效"
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
        echo ">>> 配置轩辕镜像地址"
        echo ""
        echo "请选择版本："
        echo "1) 轩辕镜像免费版 (域名: docker.xuanyuan.me)"
        echo "2) 轩辕镜像专业版 (专属域名 *.xuanyuan.run / *.xuanyuan.dev ，不含免费版域名)"
        echo "3) 恢复/重置镜像相关配置"
        # 循环等待用户输入有效选择
        while true; do
            read -p "请输入选择 [1/2/3]: " choice
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            elif [[ "$choice" == "3" ]]; then
                restore_docker_daemon_config
                exit $?
            else
                echo "❌ 无效选择，请输入 1、2 或 3"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
            read -p "请输入您的轩辕镜像专属域名 (访问官网获取：https://xuanyuan.cloud): " custom_domain
            
            # 清理用户输入的域名，移除协议前缀
            custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
            
            # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
            if [[ "$custom_domain" == *.xuanyuan.run ]]; then
                custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
                mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev"
]
EOF
)
            elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
                custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
                mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_run"
]
EOF
)
            else
                mirror_list=$(cat <<EOF
[
  "https://$custom_domain"
]
EOF
)
            fi
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
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_run"
]
EOF
)
          else
            insecure_registries=$(cat <<EOF
[
  "$custom_domain"
]
EOF
)
          fi
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

# 如果没有禁用 DNS 配置且宿主机没有配置 DNS，则添加 DNS 配置
if [[ "$SKIP_DNS" != "true" ]]; then
  if grep -q "nameserver" /etc/resolv.conf; then
    echo "ℹ️  检测到系统已配置 DNS，跳过 Docker DNS 配置以避免冲突"
  else
    # 使用 jq 或 python 来修改 json 文件，避免直接覆盖
    if command -v jq &> /dev/null; then
      tmp_json=$(mktemp)
      sudo jq '. + {"dns": ["119.29.29.29", "114.114.114.114"]}' /etc/docker/daemon.json > "$tmp_json" && sudo mv "$tmp_json" /etc/docker/daemon.json
      echo "✅ 已添加 Docker DNS 配置"
    else
      # 简单的 sed 替换作为后备方案
      sudo sed -i 's/}/,\n  "dns": ["119.29.29.29", "114.114.114.114"]\n}/' /etc/docker/daemon.json
      echo "✅ 已添加 Docker DNS 配置"
    fi
  fi
fi
        
        echo "✅ 镜像配置已更新"
        echo ""
        echo "当前配置的镜像源："
        if [[ "$choice" == "2" ]]; then
            if [[ "$custom_domain" == *.xuanyuan.run ]]; then
                custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_dev (备用)"
            elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
                custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_run (备用)"
            else
                echo "  - https://$custom_domain"
            fi
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
        echo "🎉 镜像配置完成！"
        exit 0
    elif [[ "$mode_choice" == "3" ]]; then
        echo ""
        echo ">>> 模式：恢复 Docker 镜像相关配置"
        restore_docker_daemon_config
        exit $?
    else
        echo "❌ 无效选择，请输入 1、2 或 3"
        echo ""
    fi
done

# 检测 macOS 和 Windows 系统
DETECTED_OS=$(uname -s 2>/dev/null || echo "Unknown")

# macOS 检测
if [[ "$DETECTED_OS" == "Darwin" ]]; then
  echo "🍎 检测到 macOS 系统"
  echo ""
  echo "=========================================="
  echo "⚠️  macOS 不支持此 Linux 安装脚本"
  echo "=========================================="
  echo ""
  echo "📋 macOS 安装 Docker 的正确方式："
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "方法一：使用 Homebrew 安装（推荐）"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1. 如果未安装 Homebrew，先安装："
  echo "     /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  echo ""
  echo "  2. 使用 Homebrew 安装 Docker Desktop："
  echo "     brew install --cask docker"
  echo ""
  echo "  3. 启动 Docker Desktop："
  echo "     打开「应用程序」文件夹，双击 Docker 图标"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "方法二：下载官方安装包"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  访问：https://www.docker.com/products/docker-desktop"
  echo "  下载 Docker Desktop for Mac (Apple Silicon 或 Intel)"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 配置轩辕镜像"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1. 启动 Docker Desktop"
  echo "  2. 点击菜单栏 Docker 图标 → Settings (设置)"
  echo "  3. 选择 Docker Engine"
  echo "  4. 在 JSON 配置中添加："
  echo ""
  echo '  {'
  echo '    "registry-mirrors": ['
  echo '      "https://docker.xuanyuan.me"'
  echo '    ],'
  echo '    "insecure-registries": ['
  echo '      "docker.xuanyuan.me"'
  echo '    ]'
  echo '  }'
  echo ""
  echo "  5. 点击 Apply & Restart（应用并重启）"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📚 更多信息"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  官方网站：https://xuanyuan.cloud/"
  echo "  Docker 文档：https://docs.docker.com/desktop/install/mac-install/"
  echo ""
  echo "=========================================="
  exit 0
fi

# Windows 检测（Git Bash、WSL、Cygwin、MSYS2 等）
if [[ "$DETECTED_OS" == MINGW* ]] || [[ "$DETECTED_OS" == MSYS* ]] || [[ "$DETECTED_OS" == CYGWIN* ]]; then
  echo "🪟 检测到 Windows 系统"
  echo ""
  echo "=========================================="
  echo "⚠️  Windows 不支持此 Linux 安装脚本"
  echo "=========================================="
  echo ""
  echo "📋 Windows 安装 Docker 的正确方式："
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "方法一：Docker Desktop（推荐）"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1. 访问官方网站："
  echo "     https://www.docker.com/products/docker-desktop"
  echo ""
  echo "  2. 下载 Docker Desktop for Windows"
  echo ""
  echo "  3. 运行安装程序并按提示完成安装"
  echo ""
  echo "  4. 重启计算机（如果需要）"
  echo ""
  echo "  📌 系统要求："
  echo "     - Windows 10/11 64位专业版、企业版或教育版"
  echo "     - 启用 WSL 2（Windows Subsystem for Linux 2）"
  echo "     - 启用 Hyper-V 和容器功能"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "方法二：在 WSL 2 中使用（高级用户）"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1. 安装 WSL 2："
  echo "     wsl --install"
  echo ""
  echo "  2. 安装 Ubuntu 或其他 Linux 发行版"
  echo ""
  echo "  3. 在 WSL 2 中运行本安装脚本："
  echo "     bash <(curl -fsSL https://xuanyuan.cloud/docker.sh)"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 配置轩辕镜像"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1. 启动 Docker Desktop"
  echo "  2. 点击系统托盘 Docker 图标 → Settings (设置)"
  echo "  3. 选择 Docker Engine"
  echo "  4. 在 JSON 配置中添加："
  echo ""
  echo '  {'
  echo '    "registry-mirrors": ['
  echo '      "https://docker.xuanyuan.me"'
  echo '    ],'
  echo '    "insecure-registries": ['
  echo '      "docker.xuanyuan.me"'
  echo '    ]'
  echo '  }'
  echo ""
  echo "  5. 点击 Apply & Restart（应用并重启）"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📚 更多信息"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  官方网站：https://xuanyuan.cloud/"
  echo "  Docker 文档：https://docs.docker.com/desktop/install/windows-install/"
  echo "  WSL 2 安装：https://docs.microsoft.com/windows/wsl/install"
  echo ""
  echo "=========================================="
  exit 0
fi

echo ">>> [1/8] 检查系统信息..."
OS=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
ARCH=$(uname -m)
VERSION_ID=$(awk -F= '/^VERSION_ID=/{print $2}' /etc/os-release | tr -d '"')
echo "系统: $OS $VERSION_ID 架构: $ARCH"

# 映射架构标识到 Docker 官方使用的架构名称
case "$ARCH" in
  x86_64)
    DOCKER_ARCH="x86_64"
    echo "✅ 检测到 x86_64 架构（Intel/AMD 64位）"
    ;;
  aarch64|arm64)
    DOCKER_ARCH="aarch64"
    echo "✅ 检测到 ARM 64位架构（aarch64），支持鲲鹏、飞腾等处理器"
    ;;
  armv7l|armhf)
    DOCKER_ARCH="armhf"
    echo "✅ 检测到 ARM 32位硬浮点架构（armhf）"
    ;;
  armv6l|armel)
    DOCKER_ARCH="armel"
    echo "✅ 检测到 ARM 32位软浮点架构（armel）"
    ;;
  s390x)
    DOCKER_ARCH="s390x"
    echo "✅ 检测到 IBM Z 架构（s390x）"
    ;;
  ppc64le)
    DOCKER_ARCH="ppc64le"
    echo "✅ 检测到 PowerPC 64位小端架构（ppc64le）"
    ;;
  *)
    echo "⚠️  检测到架构: $ARCH"
    echo "⚠️  Docker 官方静态二进制包可能不支持此架构"
    echo "⚠️  将尝试使用 $ARCH 作为架构标识，如果下载失败请手动安装"
    DOCKER_ARCH="$ARCH"
    ;;
esac
echo "📦 Docker 将使用架构标识: $DOCKER_ARCH"

# 针对 Debian 10 和 Ubuntu 16.04 显示特殊提示
if [[ "$OS" == "debian" && "$VERSION_ID" == "10" ]]; then
  echo ""
  echo "⚠️  检测到 Debian 10 (Buster) 系统"
  echo "📋 系统状态说明："
  echo "   - Debian 10 已于 2022 年 8 月结束生命周期"
  echo "   - 官方软件源已迁移到 archive.debian.org"
  echo "   - 本脚本将自动配置国内镜像源以提高下载速度"
  echo "   - 建议考虑升级到 Debian 11+ 或 Ubuntu 20.04+"
  echo ""
  echo "🚀 优化措施："
  echo "   - 使用阿里云/腾讯云/华为云镜像源"
  echo "   - 自动检测并切换可用的镜像源"
  echo "   - 使用二进制安装方式避免包依赖问题"
  echo ""
elif [[ "$OS" == "ubuntu" && "$VERSION_ID" == "16.04" ]]; then
  echo ""
  echo "⚠️  检测到 Ubuntu 16.04 (Xenial) 系统"
  echo "📋 系统状态说明："
  echo "   - Ubuntu 16.04 已于 2021 年 4 月结束标准支持"
  echo "   - Docker 官方仓库缺少部分新组件（如 docker-buildx-plugin）"
  echo "   - 本脚本将使用二进制安装方式以确保兼容性"
  echo "   - 强烈建议升级到 Ubuntu 20.04 LTS 或 Ubuntu 22.04 LTS"
  echo ""
  echo "🚀 优化措施："
  echo "   - 使用 Docker 二进制包直接安装"
  echo "   - 自动配置多个国内镜像源"
  echo "   - 跳过不兼容的组件安装"
  echo ""
elif [[ "$OS" == "centos" && "$VERSION_ID" == "7" ]]; then
  echo ""
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo "⚠️  重要提醒：CentOS 7 生命周期已结束"
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo "⚠️  📅 2024 年 6 月 30 日：CentOS 7 结束生命周期（EOL）"
  echo "⚠️  "
  echo "⚠️  之后，不再接收官方更新或安全补丁"
  echo "⚠️  建议升级到受支持的操作系统版本"
  echo "⚠️  "
  echo "⚠️  推荐替代方案："
  echo "⚠️    - Rocky Linux 8/9（CentOS 的社区替代品）"
  echo "⚠️    - AlmaLinux 8/9（企业级长期支持）"
  echo "⚠️    - CentOS Stream 8/9（滚动发布版本）"
  echo "⚠️    - Red Hat Enterprise Linux 8/9（商业支持）"
  echo "⚠️  "
  echo "⚠️  当前将使用归档源继续安装，但强烈建议尽快升级系统"
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo ""
elif [[ "$OS" == "centos" && "$VERSION_ID" == "8" ]]; then
  echo ""
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo "⚠️  重要提醒：CentOS 8 生命周期已结束"
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo "⚠️  📅 2021 年 12 月 31 日：CentOS 8 结束生命周期（EOL）"
  echo "⚠️  "
  echo "⚠️  之后，不再接收官方更新或安全补丁"
  echo "⚠️  建议升级到受支持的操作系统版本"
  echo "⚠️  "
  echo "⚠️  推荐替代方案："
  echo "⚠️    - Rocky Linux 8/9（CentOS 的社区替代品）"
  echo "⚠️    - AlmaLinux 8/9（企业级长期支持）"
  echo "⚠️    - CentOS Stream 8/9（滚动发布版本）"
  echo "⚠️    - Red Hat Enterprise Linux 8/9（商业支持）"
  echo "⚠️  "
  echo "⚠️  当前将使用归档源继续安装，但强烈建议尽快升级系统"
  echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
  echo ""
elif [[ "$OS" == "kylin" || "$OS" == "uos" || "$OS" == "uniontechos" ]]; then
  echo ""
  if [[ "$OS" == "kylin" ]]; then
    # 规范显示银河麒麟版本，避免出现 Vv10 等重复前缀
    if [[ "$VERSION_ID" =~ ^[Vv] ]]; then
      KYLIN_VERSION_DISPLAY="$VERSION_ID"
    else
      KYLIN_VERSION_DISPLAY="V$VERSION_ID"
    fi
    echo "✅ 检测到银河麒麟操作系统 (Kylin Linux) $KYLIN_VERSION_DISPLAY"
    echo "📋 系统信息："
    echo "   - Kylin Linux 基于 RHEL，与 CentOS/RHEL 兼容"
    echo "   - 使用 yum/dnf 包管理器"
    echo "   - 支持国内镜像"
  else
    echo "✅ 检测到统信操作系统 (UnionTechOS / UOS) $VERSION_ID"
    echo "📋 系统信息："
    echo "   - 与 RHEL/CentOS 软件生态兼容，使用 yum/dnf 包管理器"
    echo "   - Docker CE 将按兼容映射使用国内 CentOS 系镜像源"
    echo "   - 支持国内镜像"
  fi
  echo ""
elif [[ "$OS" == "kali" ]]; then
  echo ""
  echo "✅ 检测到 Kali Linux $VERSION_ID"
  echo "📋 系统信息："
  echo "   - Kali Linux 基于 Debian，与 Debian 完全兼容"
  echo "   - 使用 apt 包管理器"
  echo "   - 将使用 Debian 兼容的安装方法"
  echo "   - 支持国内镜像"
  echo ""
elif [[ "$OS" == "deepin" ]]; then
  echo ""
  echo "✅ 检测到深度操作系统 (Deepin) $VERSION_ID"
  echo "📋 系统信息："
  echo "   - Deepin 基于 Debian，使用 apt 包管理器"
  echo "   - Docker CE 使用官方 linux/debian 源（Deepin 代号将映射为 Debian suite）"
  echo "   - 支持国内镜像"
  echo ""
fi

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
                    echo ">>> [5/8] 配置轩辕镜像..."
        
        # 循环等待用户选择镜像版本
        while true; do
            echo "请选择版本:"
            echo "1) 轩辕镜像免费版 (域名: docker.xuanyuan.me)"
            echo "2) 轩辕镜像专业版 (专属域名: *.xuanyuan.run / *.xuanyuan.dev 不含免费版域名)"
            echo "3) 恢复/重置镜像相关配置"
            read -p "请输入选择 [1/2/3]: " choice
            
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            elif [[ "$choice" == "3" ]]; then
                restore_docker_daemon_config
                exit $?
            else
                echo "❌ 无效选择，请输入 1、2 或 3"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
          read -p "请输入您的轩辕镜像专属域名 (访问官网获取：https://xuanyuan.cloud): " custom_domain
          
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_run"
]
EOF
)
          else
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain"
]
EOF
)
          fi
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
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_run"
]
EOF
)
          else
            insecure_registries=$(cat <<EOF
[
  "$custom_domain"
]
EOF
)
          fi
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        # 准备 DNS 配置字符串
dns_config=""
if [[ "$SKIP_DNS" != "true" ]]; then
  if ! grep -q "nameserver" /etc/resolv.conf; then
     dns_config=',
  "dns": ["119.29.29.29", "114.114.114.114"]'
  else
     echo "ℹ️  检测到系统已配置 DNS，跳过 Docker DNS 配置以避免冲突"
  fi
fi

cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries$dns_config
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "🎉Docker 镜像已配置完成"
        echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
        echo "官方网站: https://xuanyuan.cloud/"
        
        # 显示当前配置的镜像源
        echo ""
        echo "当前配置的镜像源："
        if [[ "$choice" == "2" ]]; then
            if [[ "$custom_domain" == *.xuanyuan.run ]]; then
                custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_dev (备用)"
            elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
                custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_run (备用)"
            else
                echo "  - https://$custom_domain"
            fi
        else
            echo "  - https://docker.xuanyuan.me"
        fi
        echo ""
        
        # 继续执行完整的流程，不在这里退出
        fi
    else
        echo "Docker 版本 $DOCKER_VERSION 满足要求 (>= 20.0)"
        echo "跳过 Docker 安装，直接配置镜像..."
        
        echo ">>> [5/8] 配置国内镜像..."
        
        # 循环等待用户选择镜像版本
        while true; do
            echo "请选择版本:"
            echo "1) 轩辕镜像免费版 (域名: docker.xuanyuan.me)"
            echo "2) 轩辕镜像专业版 (专属域名 *.xuanyuan.run / *.xuanyuan.dev 不含免费版域名)"
            echo "3) 恢复/重置镜像相关配置"
            read -p "请输入选择 [1/2/3]: " choice
            
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            elif [[ "$choice" == "3" ]]; then
                restore_docker_daemon_config
                exit $?
            else
                echo "❌ 无效选择，请输入 1、2 或 3"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
          read -p "请输入您的轩辕镜像专属域名 (访问官网获取：https://xuanyuan.cloud): " custom_domain

          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_run"
]
EOF
)
          else
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain"
]
EOF
)
          fi
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
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_run"
]
EOF
)
          else
            insecure_registries=$(cat <<EOF
[
  "$custom_domain"
]
EOF
)
          fi
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        # 准备 DNS 配置字符串
dns_config=""
if [[ "$SKIP_DNS" != "true" ]]; then
  if ! grep -q "nameserver" /etc/resolv.conf; then
     dns_config=',
  "dns": ["119.29.29.29", "114.114.114.114"]'
  else
     echo "ℹ️  检测到系统已配置 DNS，跳过 Docker DNS 配置以避免冲突"
  fi
fi

cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries$dns_config
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "🎉Docker 镜像已配置完成"
        echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
        echo "官方网站: https://xuanyuan.cloud/"
        exit 0
    fi
else
    echo "未检测到 Docker，将进行全新安装"
fi

echo ">>> [2/8] 配置国内 Docker 源..."
# 将 OS 转换为小写进行比较（支持 openEuler、openeuler 等大小写形式）
OS_LOWER=$(echo "$OS" | tr '[:upper:]' '[:lower:]')
if [[ "$OS_LOWER" == "openeuler" ]]; then
  # openEuler (欧拉操作系统) 支持
  echo "检测到 openEuler (欧拉操作系统) $VERSION_ID"
  
  # 判断使用 dnf 还是 yum
  if [[ "${VERSION_ID%%.*}" -ge 22 ]]; then
    # openEuler 22+ 使用 dnf
    PKG_MANAGER="dnf"
    CENTOS_VERSION="9"
    echo "使用 dnf 包管理器 (openEuler $VERSION_ID 使用 CentOS 9 兼容源)"
  elif [[ "${VERSION_ID%%.*}" -ge 20 ]]; then
    # openEuler 20-21 使用 dnf，基于 CentOS 8
    PKG_MANAGER="dnf"
    CENTOS_VERSION="8"
    echo "使用 dnf 包管理器 (openEuler $VERSION_ID 使用 CentOS 8 兼容源)"
  else
    # openEuler 旧版本使用 yum，基于 CentOS 7
    PKG_MANAGER="yum"
    CENTOS_VERSION="7"
    echo "使用 yum 包管理器 (openEuler $VERSION_ID 使用 CentOS 7 兼容源)"
  fi
  
  sudo $PKG_MANAGER install -y ${PKG_MANAGER}-utils
  
  # 定义切换 Docker 镜像源的函数
  switch_docker_mirror() {
    local mirror_index=$1
    local centos_version=${CENTOS_VERSION:-9}
    local repo_added=false
    
    case $mirror_index in
      1)
        echo "尝试配置阿里云 Docker 源..."
        sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${centos_version}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
        ;;
      2)
        echo "尝试配置腾讯云 Docker 源..."
        sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${centos_version}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
        ;;
      3)
        echo "尝试配置中科大 Docker 源..."
        sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${centos_version}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
        ;;
      4)
        echo "尝试配置清华大学 Docker 源..."
        sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${centos_version}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
        ;;
      5)
        echo "尝试配置官方 Docker 源..."
        sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${centos_version}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
        ;;
      *)
        return 1
        ;;
    esac
    
    # 清理缓存并更新
    sudo $PKG_MANAGER clean all 2>/dev/null || true
    sudo rm -rf /var/cache/dnf/* 2>/dev/null || true
    sudo rm -rf /var/cache/yum/* 2>/dev/null || true
    
    if sudo $PKG_MANAGER makecache; then
      repo_added=true
      echo "✅ Docker 源切换成功"
      return 0
    else
      echo "❌ Docker 源切换失败"
      return 1
    fi
  }
  
  # 尝试多个国内镜像源（优先华为云，因为 openEuler 是华为开发）
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  CURRENT_MIRROR_INDEX=0  # 0=华为云, 1=阿里云, 2=腾讯云, 3=中科大, 4=清华, 5=官方
  
  # 创建Docker仓库配置文件，使用 openEuler 兼容的 CentOS 版本
  echo "正在创建 Docker 仓库配置 (使用 CentOS ${CENTOS_VERSION} 兼容源)..."
  
  # 源1: 华为云镜像（openEuler 是华为开发，优先使用华为云）
  echo "尝试配置华为云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo $PKG_MANAGER makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 华为云 Docker 源配置成功"
  else
    echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 阿里云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置阿里云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 阿里云 Docker 源配置成功"
    else
      echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 检查是否安装了 iSulad（openEuler 的容器运行时，与 Docker 冲突）
  if rpm -q iSulad &>/dev/null; then
    echo "⚠️  检测到系统已安装 iSulad（openEuler 容器运行时）"
    echo "⚠️  iSulad 与 Docker CE 存在包冲突，需要卸载 iSulad 才能安装 Docker"
    echo "正在卸载 iSulad..."
    if sudo $PKG_MANAGER remove -y iSulad 2>/dev/null; then
      echo "✅ iSulad 卸载成功"
    else
      echo "⚠️  iSulad 卸载失败，将使用 --allowerasing 参数处理冲突"
    fi
  fi
  
  # 在安装 docker-ce 之前，先检查并安装 libnftables 依赖
  echo ">>> [3.1/8] 检查 libnftables 依赖..."
  if ! rpm -q libnftables >/dev/null 2>&1; then
    echo "⚠️  未检测到 libnftables，正在安装..."
    if sudo $PKG_MANAGER install -y libnftables 2>&1; then
      echo "✅ libnftables 安装成功"
    else
      echo "⚠️  libnftables 安装失败，将在安装 docker-ce 时重试"
    fi
  else
    echo "✅ libnftables 已安装"
  fi
  
  # 尝试安装 Docker，使用 --allowerasing 参数处理 runc 冲突
  # containerd.io 会替代系统的 runc，需要使用 --allowerasing 允许替换
  if sudo $PKG_MANAGER install -y --allowerasing docker-ce docker-ce-cli containerd.io docker-buildx-plugin; then
    echo "✅ Docker CE 安装成功"
  else
    echo "❌ 批量安装失败，尝试逐个安装组件（使用 --allowerasing）..."
    
    # 再次检查 libnftables（批量安装失败后）
    echo "再次检查 libnftables 依赖..."
    if ! rpm -q libnftables >/dev/null 2>&1; then
      echo "⚠️  未检测到 libnftables，正在安装..."
      if sudo $PKG_MANAGER install -y libnftables 2>&1; then
        echo "✅ libnftables 安装成功"
      else
        echo "⚠️  libnftables 安装失败"
      fi
    else
      echo "✅ libnftables 已安装"
    fi
    
    # 逐个安装组件，都使用 --allowerasing 处理冲突
    CONTAINERD_INSTALLED=false
    CONTAINERD_OUTPUT=""
    if sudo $PKG_MANAGER install -y --allowerasing containerd.io 2>&1; then
      echo "✅ containerd.io 安装成功"
      CONTAINERD_INSTALLED=true
    else
      CONTAINERD_OUTPUT=$(sudo $PKG_MANAGER install -y --allowerasing containerd.io 2>&1 || true)
      echo "❌ containerd.io 安装失败"
      
      # 检测是否是校验和错误，如果是则尝试切换镜像源
      if echo "$CONTAINERD_OUTPUT" | grep -qiE "(checksum doesn't match|校验和不匹配|Cannot download|all mirrors were already tried)"; then
        echo "⚠️  检测到下载失败或校验和不匹配，尝试切换 Docker 镜像源..."
        
        # 尝试切换其他镜像源（从阿里云开始，因为华为云已经失败）
        for mirror_idx in 1 2 3 4 5; do
          if switch_docker_mirror $mirror_idx; then
            CURRENT_MIRROR_INDEX=$mirror_idx
            echo "  - 重新尝试安装 containerd.io..."
            if sudo $PKG_MANAGER install -y --allowerasing containerd.io 2>&1; then
              echo "✅ containerd.io 安装成功（切换镜像源后）"
              CONTAINERD_INSTALLED=true
              break
            else
              echo "  ❌ 切换镜像源后仍然失败，尝试下一个镜像源..."
            fi
          fi
        done
        
        if [[ "$CONTAINERD_INSTALLED" == "false" ]]; then
          echo "❌ 所有镜像源都尝试失败，containerd.io 无法安装"
        fi
      fi
    fi
    
    if sudo $PKG_MANAGER install -y --allowerasing docker-ce-cli; then
      echo "✅ docker-ce-cli 安装成功"
    else
      echo "❌ docker-ce-cli 安装失败"
    fi
    
    DOCKER_CE_INSTALLED=false
    DOCKER_CE_OUTPUT=""
    # 使用临时变量捕获退出码，因为 tee 会改变退出码
    DOCKER_CE_INSTALL_LOG=$(sudo $PKG_MANAGER install -y --allowerasing docker-ce 2>&1 | tee /tmp/docker-ce-install.log)
    DOCKER_CE_INSTALL_STATUS=${PIPESTATUS[0]}
    
    if [[ $DOCKER_CE_INSTALL_STATUS -eq 0 ]]; then
      # 再次验证 docker-ce 是否真的安装成功
      if rpm -q docker-ce >/dev/null 2>&1; then
        echo "✅ docker-ce 安装成功"
        DOCKER_CE_INSTALLED=true
      else
        echo "⚠️  安装命令成功但 docker-ce 包未找到，可能安装失败"
        DOCKER_CE_OUTPUT="$DOCKER_CE_INSTALL_LOG"
        echo "❌ docker-ce 安装失败"
      fi
    else
      DOCKER_CE_OUTPUT="$DOCKER_CE_INSTALL_LOG"
      echo "❌ docker-ce 安装失败"
      
      # 检测是否是 libnftables 依赖问题
      if echo "$DOCKER_CE_OUTPUT" | grep -qiE "libnftables|LIBNFTABLES"; then
        echo "⚠️  检测到 libnftables 依赖问题"
        
        # 先检查 libnftables 是否已安装
        if rpm -q libnftables >/dev/null 2>&1; then
          echo "⚠️  libnftables 已安装，但版本可能不兼容，尝试升级..."
          sudo $PKG_MANAGER update -y libnftables 2>&1 || true
        else
          echo "正在尝试安装 libnftables 依赖..."
        fi
        
        # 尝试安装 libnftables（显示详细信息，不要隐藏错误）
        if sudo $PKG_MANAGER install -y libnftables 2>&1; then
          echo "✅ libnftables 安装成功，重新尝试安装 docker-ce..."
          if sudo $PKG_MANAGER install -y --allowerasing docker-ce 2>&1 | tee /tmp/docker-ce-install-retry.log; then
            echo "✅ docker-ce 安装成功（安装 libnftables 后）"
            DOCKER_CE_INSTALLED=true
          else
            echo "❌ docker-ce 安装仍然失败"
            DOCKER_CE_OUTPUT=$(cat /tmp/docker-ce-install-retry.log 2>/dev/null || echo "")
            
            # 如果仍然失败，尝试切换镜像源（不同镜像源可能有不同版本的 docker-ce）
            if echo "$DOCKER_CE_OUTPUT" | grep -qiE "libnftables|LIBNFTABLES"; then
              echo "⚠️  当前镜像源的 docker-ce 版本可能不兼容，尝试切换镜像源..."
              
              # 尝试切换其他镜像源（从阿里云开始，因为华为云已经失败）
              for mirror_idx in 1 2 3 4 5; do
                if switch_docker_mirror $mirror_idx; then
                  CURRENT_MIRROR_INDEX=$mirror_idx
                  echo "  - 重新尝试安装 docker-ce..."
                  
                  # 再次检查并安装 libnftables（某些镜像源可能提供不同版本）
                  if ! rpm -q libnftables >/dev/null 2>&1; then
                    echo "  - 安装 libnftables..."
                    sudo $PKG_MANAGER install -y libnftables 2>&1 || echo "  ⚠️  libnftables 安装失败，继续尝试安装 docker-ce..."
                  else
                    echo "  ✅ libnftables 已安装"
                  fi
                  
                  if sudo $PKG_MANAGER install -y --allowerasing docker-ce 2>&1 | tee /tmp/docker-ce-install-mirror.log; then
                    echo "✅ docker-ce 安装成功（切换镜像源后）"
                    DOCKER_CE_INSTALLED=true
                    break
                  else
                    echo "  ❌ 切换镜像源后仍然失败，尝试下一个镜像源..."
                  fi
                fi
              done
            fi
          fi
        else
          echo "⚠️  libnftables 安装失败，尝试切换镜像源后重试..."
          
          # 尝试切换其他镜像源
          for mirror_idx in 1 2 3 4 5; do
            if switch_docker_mirror $mirror_idx; then
              CURRENT_MIRROR_INDEX=$mirror_idx
              echo "  - 检查并安装 libnftables..."
              
              # 先检查是否已安装
              if rpm -q libnftables >/dev/null 2>&1; then
                echo "  ✅ libnftables 已安装"
              else
                # 尝试安装 libnftables（显示详细信息）
                if sudo $PKG_MANAGER install -y libnftables 2>&1; then
                  echo "  ✅ libnftables 安装成功"
                else
                  echo "  ⚠️  libnftables 安装失败，继续尝试安装 docker-ce..."
                fi
              fi
              
              # 无论 libnftables 是否安装成功，都尝试安装 docker-ce
              echo "  - 尝试安装 docker-ce..."
              if sudo $PKG_MANAGER install -y --allowerasing docker-ce 2>&1 | tee /tmp/docker-ce-install-mirror.log; then
                echo "✅ docker-ce 安装成功（切换镜像源后）"
                DOCKER_CE_INSTALLED=true
                break
              else
                echo "  ❌ docker-ce 安装仍然失败，尝试下一个镜像源..."
              fi
            fi
          done
          
          if [[ "$DOCKER_CE_INSTALLED" == "false" ]]; then
            echo "⚠️  所有镜像源都尝试失败，将使用二进制安装方式绕过依赖问题"
          fi
        fi
      fi
    fi
    
    if sudo $PKG_MANAGER install -y --allowerasing docker-buildx-plugin; then
      echo "✅ docker-buildx-plugin 安装成功"
    else
      echo "❌ docker-buildx-plugin 安装失败"
    fi
    
    # 检查 docker.service 文件是否存在
    DOCKER_SERVICE_EXISTS=false
    if [ -f /etc/systemd/system/docker.service ] || [ -f /usr/lib/systemd/system/docker.service ]; then
      DOCKER_SERVICE_EXISTS=true
    fi
    
    # 检查是否至少安装了核心组件
    # 不仅要检查 docker 命令是否存在，还要检查 docker.service 是否存在
    if ! command -v docker &> /dev/null || [ "$DOCKER_CE_INSTALLED" == "false" ] || [ "$DOCKER_SERVICE_EXISTS" == "false" ]; then
      if [ "$DOCKER_CE_INSTALLED" == "false" ] || [ "$DOCKER_SERVICE_EXISTS" == "false" ]; then
        if command -v docker &> /dev/null; then
          echo "⚠️  检测到 docker 命令存在，但 docker-ce 包或 docker.service 文件缺失"
          echo "⚠️  这通常是由于依赖问题导致 docker-ce 安装不完整"
        fi
        echo "❌ docker-ce 安装不完整，尝试二进制安装..."
      else
        echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      fi
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 华为云镜像（优先）
      echo "尝试从华为云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从华为云镜像下载成功"
      else
        echo "❌ 华为云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 阿里云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从阿里云镜像下载..."
        if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从阿里云镜像下载成功"
        else
          echo "❌ 阿里云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
    echo "正在解压并安装 Docker 二进制包..."
    sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
    sudo chmod +x /usr/bin/docker*
    
    # SELinux 友好提示
    if command -v getenforce &> /dev/null && [ "$(getenforce)" != "Disabled" ]; then
        echo ""
        echo "⚠️  检测到 SELinux 处于开启状态 ($(getenforce))"
        echo "⚠️  二进制安装方式可能会遇到 SELinux 上下文问题"
        echo "⚠️  如果启动失败，请尝试临时关闭 SELinux (setenforce 0) 或手动配置 SELinux 策略"
        echo "💡 推荐操作：尝试安装 container-selinux >= 2.74"
        echo ""
        echo "正在等待 3 秒以确认切换到二进制安装模式..."
        sleep 3
    fi

    # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
  # 检查 docker.service 文件是否存在
  if [ ! -f /etc/systemd/system/docker.service ] && [ ! -f /usr/lib/systemd/system/docker.service ]; then
    echo "❌ docker.service 文件不存在，Docker 服务无法启动"
    echo "⚠️  这通常是由于 docker-ce 包安装失败导致的"
    echo "💡 建议："
    echo "   1. 检查依赖问题（如 libnftables）"
    echo "   2. 尝试手动安装依赖：sudo $PKG_MANAGER install -y libnftables"
    echo "   3. 重新运行安装脚本"
    echo "   4. 或使用二进制安装方式"
    exit 1
  fi
  
  # 启动 Docker 服务
  echo "正在启动 Docker 服务..."
  if sudo systemctl enable docker 2>/dev/null; then
    echo "✅ Docker 服务已设置为开机自启"
  else
    echo "⚠️  Docker 服务开机自启设置失败"
  fi
  
  if sudo systemctl start docker 2>/dev/null; then
    echo "✅ Docker 服务启动成功"
  else
    echo "⚠️  Docker 服务启动失败，尝试查看日志..."
    sudo systemctl status docker --no-pager -l || true
    echo "💡 可以尝试手动启动：sudo dockerd &"
  fi
  
  echo ">>> [3.5/8] 安装 Docker Compose..."
  # 安装最新版本的 docker-compose，使用多个备用下载源
  echo "正在下载 Docker Compose..."
  
  # 尝试多个下载源
  DOCKER_COMPOSE_DOWNLOADED=false
  
  # 源1: 华为云镜像（优先）
  echo "尝试从华为云镜像下载..."
  if sudo curl -L "https://mirrors.huaweicloud.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
    DOCKER_COMPOSE_DOWNLOADED=true
    echo "✅ 从华为云镜像下载成功"
  else
    echo "❌ 华为云镜像下载失败，尝试下一个源..."
  fi
  
  # 源2: 阿里云镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从阿里云镜像下载..."
    if sudo curl -L "https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从阿里云镜像下载成功"
    else
      echo "❌ 阿里云镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 腾讯云镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从腾讯云镜像下载..."
    if sudo curl -L "https://mirrors.cloud.tencent.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从腾讯云镜像下载成功"
    else
      echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo $PKG_MANAGER install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "opencloudos" ]]; then
  # OpenCloudOS 9 使用 dnf 而不是 yum
  sudo dnf install -y dnf-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 OpenCloudOS 9 兼容的版本
  echo "正在创建 Docker 仓库配置..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo dnf makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 临时禁用 set -e，允许错误处理
  set +e
  
  echo "正在尝试安装 Docker CE（这可能需要几分钟，请耐心等待）..."
  echo "如果安装过程卡住，可能是网络问题或依赖解析中，请等待..."
  
  # 尝试安装 Docker，使用超时机制（30分钟超时）
  INSTALL_OUTPUT=""
  INSTALL_STATUS=1
  
  # 使用 timeout 命令（如果可用）或直接执行
  # 注意：使用 bash -c 确保 sudo 函数在子 shell 中可用
  if command -v timeout &> /dev/null; then
    INSTALL_OUTPUT=$(timeout 1800 bash -c "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin" 2>&1)
    INSTALL_STATUS=$?
    if [[ $INSTALL_STATUS -eq 124 ]]; then
      echo "❌ 安装超时（30分钟），可能是网络问题或依赖解析失败"
      INSTALL_STATUS=1
    fi
  else
    INSTALL_OUTPUT=$(sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>&1)
    INSTALL_STATUS=$?
  fi
  
  # 重新启用 set -e
  set -e
  
  if [[ $INSTALL_STATUS -eq 0 ]]; then
    echo "✅ Docker CE 安装成功"
  else
    # 显示详细错误信息
    echo ""
    echo "❌ Docker CE 批量安装失败"
    echo "错误详情："
    echo "$INSTALL_OUTPUT" | tail -20
    echo ""
    
    # 检查错误类型
    if echo "$INSTALL_OUTPUT" | grep -qiE "(timeout|timed out|connection|网络|network)"; then
      echo "⚠️  检测到可能的网络问题，请检查网络连接"
    fi
    if echo "$INSTALL_OUTPUT" | grep -qiE "(repo|repository|仓库|not found|找不到)"; then
      echo "⚠️  检测到可能的仓库配置问题，请检查 Docker 源配置"
    fi
    
    echo "正在尝试逐个安装组件..."
    
    # 临时禁用 set -e
    set +e
    
    # 逐个安装组件
    echo "  - 正在安装 containerd.io..."
    CONTAINERD_OUTPUT=$(sudo dnf install -y containerd.io 2>&1)
    CONTAINERD_STATUS=$?
    if [[ $CONTAINERD_STATUS -eq 0 ]]; then
      echo "  ✅ containerd.io 安装成功"
    else
      echo "  ❌ containerd.io 安装失败"
      echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce-cli..."
    DOCKER_CLI_OUTPUT=$(sudo dnf install -y docker-ce-cli 2>&1)
    DOCKER_CLI_STATUS=$?
    if [[ $DOCKER_CLI_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce-cli 安装成功"
    else
      echo "  ❌ docker-ce-cli 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CLI_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce..."
    DOCKER_CE_OUTPUT=$(sudo dnf install -y docker-ce 2>&1)
    DOCKER_CE_STATUS=$?
    if [[ $DOCKER_CE_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce 安装成功"
    else
      echo "  ❌ docker-ce 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-buildx-plugin..."
    BUILDX_OUTPUT=$(sudo dnf install -y docker-buildx-plugin 2>&1)
    BUILDX_STATUS=$?
    if [[ $BUILDX_STATUS -eq 0 ]]; then
      echo "  ✅ docker-buildx-plugin 安装成功"
    else
      echo "  ⚠️  docker-buildx-plugin 安装失败（可选组件，不影响核心功能）"
    fi
    
    # 重新启用 set -e
    set -e
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo ""
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo dnf install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "anolis" ]]; then
  # Anolis OS (龙蜥操作系统) 支持
  echo "检测到 Anolis OS (龙蜥操作系统) $VERSION_ID"
  
  # 判断使用 dnf 还是 yum
  if [[ "${VERSION_ID%%.*}" -ge 8 ]]; then
    # Anolis 8+ 使用 dnf
    PKG_MANAGER="dnf"
    CENTOS_VERSION="8"
    echo "使用 dnf 包管理器 (Anolis $VERSION_ID 基于 CentOS 8+)"
  else
    # Anolis 7 使用 yum
    PKG_MANAGER="yum"
    CENTOS_VERSION="7"
    echo "使用 yum 包管理器 (Anolis $VERSION_ID 基于 CentOS 7)"
  fi
  
  sudo $PKG_MANAGER install -y ${PKG_MANAGER}-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 Anolis 兼容的 CentOS 版本
  echo "正在创建 Docker 仓库配置 (使用 CentOS ${CENTOS_VERSION} 兼容源)..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo $PKG_MANAGER makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 尝试安装 Docker，如果失败则尝试逐个安装组件
  if sudo $PKG_MANAGER install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin; then
    echo "✅ Docker CE 安装成功"
  else
    echo "❌ 批量安装失败，尝试逐个安装组件..."
    
    # 逐个安装组件
    if sudo $PKG_MANAGER install -y containerd.io; then
      echo "✅ containerd.io 安装成功"
    else
      echo "❌ containerd.io 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-ce-cli; then
      echo "✅ docker-ce-cli 安装成功"
    else
      echo "❌ docker-ce-cli 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-ce; then
      echo "✅ docker-ce 安装成功"
    else
      echo "❌ docker-ce 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-buildx-plugin; then
      echo "✅ docker-buildx-plugin 安装成功"
    else
      echo "❌ docker-buildx-plugin 安装失败"
    fi
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo $PKG_MANAGER install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "alinux" ]]; then
  # Alinux (Alibaba Cloud Linux) 支持
  echo "检测到 Alibaba Cloud Linux (Alinux) $VERSION_ID"
  echo "基于 Anolis OS，阿里云深度优化的企业级操作系统"
  
  # 判断使用 dnf 还是 yum
  if [[ "${VERSION_ID%%.*}" -ge 3 ]]; then
    # Alinux 3+ 使用 dnf，基于 Anolis OS 8
    PKG_MANAGER="dnf"
    CENTOS_VERSION="8"
    echo "使用 dnf 包管理器 (Alinux $VERSION_ID 基于 Anolis OS 8 / CentOS 8)"
  else
    # Alinux 2 使用 yum，基于 Anolis OS 7
    PKG_MANAGER="yum"
    CENTOS_VERSION="7"
    echo "使用 yum 包管理器 (Alinux $VERSION_ID 基于 Anolis OS 7 / CentOS 7)"
  fi
  
  sudo $PKG_MANAGER install -y ${PKG_MANAGER}-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 Alinux 兼容的 CentOS 版本
  echo "正在创建 Docker 仓库配置 (使用 CentOS ${CENTOS_VERSION} 兼容源)..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo $PKG_MANAGER makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 尝试安装 Docker，如果失败则尝试逐个安装组件
  if sudo $PKG_MANAGER install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin; then
    echo "✅ Docker CE 安装成功"
  else
    echo "❌ 批量安装失败，尝试逐个安装组件..."
    
    # 逐个安装组件
    if sudo $PKG_MANAGER install -y containerd.io; then
      echo "✅ containerd.io 安装成功"
    else
      echo "❌ containerd.io 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-ce-cli; then
      echo "✅ docker-ce-cli 安装成功"
    else
      echo "❌ docker-ce-cli 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-ce; then
      echo "✅ docker-ce 安装成功"
    else
      echo "❌ docker-ce 安装失败"
    fi
    
    if sudo $PKG_MANAGER install -y docker-buildx-plugin; then
      echo "✅ docker-buildx-plugin 安装成功"
    else
      echo "❌ docker-buildx-plugin 安装失败"
    fi
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo $PKG_MANAGER install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "fedora" ]]; then
  # Fedora 支持
  echo "检测到 Fedora $VERSION_ID"
  
  # 检查 Fedora 版本是否过期
  if [[ "${VERSION_ID%%.*}" -lt 38 ]]; then
    echo ""
    echo "⚠️  警告：Fedora $VERSION_ID 可能已结束生命周期"
    echo "📋 建议："
    echo "   - 升级到 Fedora 38+ 以获得最新的安全更新和软件包"
    echo "   - 或考虑使用 Rocky Linux / AlmaLinux（企业级长期支持）"
    echo ""
  fi
  
  # Fedora 使用 dnf 包管理器
  sudo dnf install -y dnf-plugins-core
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 Fedora 专用仓库
  echo "正在创建 Docker 仓库配置..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/fedora/gpg
EOF
  
  if sudo dnf makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/fedora/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/fedora/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/fedora/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 尝试安装 Docker，如果失败则尝试逐个安装组件
  if sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
    echo "✅ Docker CE 安装成功"
  else
    echo "❌ 批量安装失败，尝试逐个安装组件..."
    
    # 逐个安装组件
    if sudo dnf install -y containerd.io; then
      echo "✅ containerd.io 安装成功"
    else
      echo "❌ containerd.io 安装失败"
    fi
    
    if sudo dnf install -y docker-ce-cli; then
      echo "✅ docker-ce-cli 安装成功"
    else
      echo "❌ docker-ce-cli 安装失败"
    fi
    
    if sudo dnf install -y docker-ce; then
      echo "✅ docker-ce 安装成功"
    else
      echo "❌ docker-ce 安装失败"
    fi
    
    if sudo dnf install -y docker-buildx-plugin; then
      echo "✅ docker-buildx-plugin 安装成功"
    else
      echo "❌ docker-buildx-plugin 安装失败（可选组件）"
    fi
    
    if sudo dnf install -y docker-compose-plugin; then
      echo "✅ docker-compose-plugin 安装成功"
    else
      echo "❌ docker-compose-plugin 安装失败（可选组件）"
    fi
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
  sudo systemctl enable docker
  sudo systemctl start docker
  
  echo ">>> [3.5/8] 安装 Docker Compose..."
  # 检查是否已通过插件安装
  if command -v docker compose version &> /dev/null 2>&1; then
    echo "✅ Docker Compose (插件版本) 已安装"
  else
    # 安装独立版本的 docker-compose，使用多个备用下载源
    echo "正在下载 Docker Compose 独立版本..."
    
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
    
    # 源6: 网易镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从网易镜像下载..."
      if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从网易镜像下载成功"
      else
        echo "❌ 网易镜像下载失败，尝试下一个源..."
      fi
    fi
    
    # 源7: 最后尝试 GitHub (如果网络允许)
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从 GitHub 下载..."
      if sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从 GitHub 下载成功"
      else
        echo "❌ GitHub 下载失败"
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
      # 设置执行权限
      sudo chmod +x /usr/local/bin/docker-compose
      
      # 创建软链接到 PATH 目录
      sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
      
      echo "✅ Docker Compose 独立版本安装完成"
    else
      echo "⚠️  Docker Compose 独立版本安装失败"
      echo "您仍可以使用 'docker compose' 命令（如果插件已安装）"
    fi
  fi

elif [[ "$OS" == "rocky" ]]; then
  # Rocky Linux 9 使用 dnf 而不是 yum
  sudo dnf install -y dnf-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 Rocky Linux 9 兼容的版本
  echo "正在创建 Docker 仓库配置..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo dnf makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 临时禁用 set -e，允许错误处理
  set +e
  
  echo "正在尝试安装 Docker CE（这可能需要几分钟，请耐心等待）..."
  echo "如果安装过程卡住，可能是网络问题或依赖解析中，请等待..."
  
  # 尝试安装 Docker，使用超时机制（30分钟超时）
  INSTALL_OUTPUT=""
  INSTALL_STATUS=1
  
  # 使用 timeout 命令（如果可用）或直接执行
  # 注意：使用 bash -c 确保 sudo 函数在子 shell 中可用
  if command -v timeout &> /dev/null; then
    INSTALL_OUTPUT=$(timeout 1800 bash -c "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin" 2>&1)
    INSTALL_STATUS=$?
    if [[ $INSTALL_STATUS -eq 124 ]]; then
      echo "❌ 安装超时（30分钟），可能是网络问题或依赖解析失败"
      INSTALL_STATUS=1
    fi
  else
    INSTALL_OUTPUT=$(sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>&1)
    INSTALL_STATUS=$?
  fi
  
  # 重新启用 set -e
  set -e
  
  if [[ $INSTALL_STATUS -eq 0 ]]; then
    echo "✅ Docker CE 安装成功"
  else
    # 显示详细错误信息
    echo ""
    echo "❌ Docker CE 批量安装失败"
    echo "错误详情："
    echo "$INSTALL_OUTPUT" | tail -20
    echo ""
    
    # 检查错误类型
    if echo "$INSTALL_OUTPUT" | grep -qiE "(timeout|timed out|connection|网络|network)"; then
      echo "⚠️  检测到可能的网络问题，请检查网络连接"
    fi
    if echo "$INSTALL_OUTPUT" | grep -qiE "(repo|repository|仓库|not found|找不到)"; then
      echo "⚠️  检测到可能的仓库配置问题，请检查 Docker 源配置"
    fi
    
    echo "正在尝试逐个安装组件..."
    
    # 临时禁用 set -e
    set +e
    
    # 逐个安装组件
    echo "  - 正在安装 containerd.io..."
    CONTAINERD_OUTPUT=$(sudo dnf install -y containerd.io 2>&1)
    CONTAINERD_STATUS=$?
    if [[ $CONTAINERD_STATUS -eq 0 ]]; then
      echo "  ✅ containerd.io 安装成功"
    else
      echo "  ❌ containerd.io 安装失败"
      echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce-cli..."
    DOCKER_CLI_OUTPUT=$(sudo dnf install -y docker-ce-cli 2>&1)
    DOCKER_CLI_STATUS=$?
    if [[ $DOCKER_CLI_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce-cli 安装成功"
    else
      echo "  ❌ docker-ce-cli 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CLI_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce..."
    DOCKER_CE_OUTPUT=$(sudo dnf install -y docker-ce 2>&1)
    DOCKER_CE_STATUS=$?
    if [[ $DOCKER_CE_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce 安装成功"
    else
      echo "  ❌ docker-ce 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-buildx-plugin..."
    BUILDX_OUTPUT=$(sudo dnf install -y docker-buildx-plugin 2>&1)
    BUILDX_STATUS=$?
    if [[ $BUILDX_STATUS -eq 0 ]]; then
      echo "  ✅ docker-buildx-plugin 安装成功"
    else
      echo "  ⚠️  docker-buildx-plugin 安装失败（可选组件，不影响核心功能）"
    fi
    
    # 重新启用 set -e
    set -e
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo ""
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo dnf install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "kylin" || "$OS" == "uos" || "$OS" == "uniontechos" ]]; then
  # Kylin Linux（银河麒麟）/ 统信 UOS：RHEL 兼容系，Docker CE 使用 linux/centos/${CENTOS_VERSION} 源
  KYLIN_MAJOR_VERSION=""
  UOS_PRESET_CENTOS=""
  if [[ "$OS" == "kylin" ]]; then
    # 规范显示版本号，避免 Vv10
    if [[ "$VERSION_ID" =~ ^[Vv] ]]; then
      KYLIN_VERSION_DISPLAY="$VERSION_ID"
    else
      KYLIN_VERSION_DISPLAY="V$VERSION_ID"
    fi
    echo "检测到 Kylin Linux $KYLIN_VERSION_DISPLAY"
    echo "Kylin Linux 基于 RHEL，与 CentOS/RHEL 兼容"
    # 对银河麒麟版本做简单解析：V10 系列按 RHEL 8 处理
    if [[ "$VERSION_ID" =~ [0-9]+ ]]; then
      KYLIN_MAJOR_VERSION="$(echo "$VERSION_ID" | grep -oE '[0-9]+' | head -1)"
    fi
  else
    echo "检测到统信 UOS $VERSION_ID（/etc/os-release ID=$OS）"
    echo "统信服务器版与 RHEL/CentOS 兼容；Docker CE 使用 CentOS 兼容仓库"
    # UOS 20.x 等与 EL8 线兼容，不得沿用「首个数字」误判为 7（VERSION_ID=20 时首段为 20 而非 10）
    UOS_MAJOR="${VERSION_ID%%.*}"
    if [[ "$UOS_MAJOR" =~ ^[0-9]+$ ]] && [[ "$UOS_MAJOR" -ge 20 ]]; then
      UOS_PRESET_CENTOS="8"
    else
      UOS_PRESET_CENTOS="7"
    fi
    echo "兼容映射：使用 CentOS ${UOS_PRESET_CENTOS} 的 Docker CE 源（若失败请反馈 VERSION_ID 以便调整）"
  fi

  # 优先使用 dnf，其次尝试 yum；都不存在则提示用户
  if command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    if [[ -n "$UOS_PRESET_CENTOS" ]]; then
      CENTOS_VERSION="$UOS_PRESET_CENTOS"
    elif [[ "$KYLIN_MAJOR_VERSION" == "10" ]]; then
      CENTOS_VERSION="8"
    else
      CENTOS_VERSION="7"
    fi
    if [[ "$OS" == "kylin" ]]; then
      echo "使用 dnf 包管理器 (Kylin $KYLIN_VERSION_DISPLAY 基于 RHEL ${CENTOS_VERSION})"
    else
      echo "使用 dnf 包管理器 (UOS $VERSION_ID → CentOS ${CENTOS_VERSION} 兼容源)"
    fi
  elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
    if [[ -n "$UOS_PRESET_CENTOS" ]]; then
      CENTOS_VERSION="$UOS_PRESET_CENTOS"
    elif [[ "$KYLIN_MAJOR_VERSION" == "10" ]]; then
      CENTOS_VERSION="8"
    else
      CENTOS_VERSION="7"
    fi
    if [[ "$OS" == "kylin" ]]; then
      echo "使用 yum 包管理器 (Kylin $KYLIN_VERSION_DISPLAY 基于 RHEL ${CENTOS_VERSION})"
    else
      echo "使用 yum 包管理器 (UOS $VERSION_ID → CentOS ${CENTOS_VERSION} 兼容源)"
    fi
  else
    echo "❌ 未检测到可用的 dnf 或 yum 包管理器，请先在系统中安装 dnf 或 yum 后重试。"
    exit 1
  fi
  
  sudo $PKG_MANAGER install -y ${PKG_MANAGER}-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用兼容的 CentOS 版本
  echo "正在创建 Docker 仓库配置 (使用 CentOS ${CENTOS_VERSION} 兼容源)..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo $PKG_MANAGER makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo $PKG_MANAGER makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [2.5/8] 检查 container-selinux 依赖..."
  # 检查 container-selinux 是否存在及版本
  CONTAINER_SELINUX_INSTALLED=false
  if rpm -q container-selinux &>/dev/null; then
    INSTALLED_VERSION=$(rpm -q --qf '%{VERSION}-%{RELEASE}' container-selinux 2>/dev/null)
    echo "检测到已安装 container-selinux: $INSTALLED_VERSION"
    # 检查版本是否满足要求 (>= 2.74)
    # 尝试解析版本号，格式可能是 2:2.74-1 或 2.74-1
    VERSION_STRING=$(echo "$INSTALLED_VERSION" | grep -oE '[0-9]+\.[0-9]+' | head -1)
    if [[ -n "$VERSION_STRING" ]]; then
      MAJOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f1)
      MINOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f2)
      if [[ "$MAJOR_VERSION" -gt 2 ]] || [[ "$MAJOR_VERSION" -eq 2 && "$MINOR_VERSION" -ge 74 ]]; then
        CONTAINER_SELINUX_INSTALLED=true
        echo "✅ container-selinux 版本满足要求"
      else
        echo "⚠️  container-selinux 版本过低 ($INSTALLED_VERSION)，需要 >= 2:2.74"
      fi
    else
      # 如果无法解析版本，尝试安装最新版本
      echo "⚠️  无法解析 container-selinux 版本，将尝试更新"
    fi
  else
    echo "未检测到 container-selinux，将尝试安装..."
  fi
  
  # 如果 container-selinux 未安装或版本不够，尝试安装
  if [[ "$CONTAINER_SELINUX_INSTALLED" == "false" ]]; then
    echo "正在尝试安装 container-selinux..."
    
    # 方法1: 尝试从系统源安装
    if sudo $PKG_MANAGER install -y container-selinux 2>/dev/null; then
      echo "✅ 从系统源安装 container-selinux 成功"
      # 重新检查版本
      INSTALLED_VERSION=$(rpm -q --qf '%{VERSION}-%{RELEASE}' container-selinux 2>/dev/null)
      echo "已安装版本: $INSTALLED_VERSION"
      VERSION_STRING=$(echo "$INSTALLED_VERSION" | grep -oE '[0-9]+\.[0-9]+' | head -1)
      if [[ -n "$VERSION_STRING" ]]; then
        MAJOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f1)
        MINOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f2)
        if [[ "$MAJOR_VERSION" -gt 2 ]] || [[ "$MAJOR_VERSION" -eq 2 && "$MINOR_VERSION" -ge 74 ]]; then
          CONTAINER_SELINUX_INSTALLED=true
          echo "✅ container-selinux 版本满足要求"
        else
          echo "⚠️  container-selinux 版本过低 ($INSTALLED_VERSION)，需要 >= 2:2.74"
          echo "⚠️  将尝试从其他源安装更高版本..."
        fi
      fi
    else
      echo "⚠️  系统源中未找到 container-selinux，尝试配置 RHEL 8 extras 源..."
    fi
    
    # 方法2: 如果版本仍然不满足要求，尝试配置 RHEL 8 extras 源（适用于 Kylin V10）
    if [[ "$CONTAINER_SELINUX_INSTALLED" == "false" && "$CENTOS_VERSION" == "8" ]]; then
      echo "尝试配置 RHEL 8 extras 源以获取更高版本的 container-selinux..."
      # 尝试配置阿里云 CentOS 8 extras 源
      if sudo tee /etc/yum.repos.d/rhel8-extras.repo > /dev/null <<EOF 2>/dev/null; then
[rhel8-extras]
name=RHEL 8 Extras - \$basearch
baseurl=https://mirrors.aliyun.com/centos-vault/8.5.2111/extras/\$basearch/os/
enabled=1
gpgcheck=0
EOF
        if sudo $PKG_MANAGER makecache -q 2>/dev/null; then
          # 尝试升级到更高版本
          if sudo $PKG_MANAGER upgrade -y container-selinux 2>/dev/null || sudo $PKG_MANAGER install -y container-selinux 2>/dev/null; then
            INSTALLED_VERSION=$(rpm -q --qf '%{VERSION}-%{RELEASE}' container-selinux 2>/dev/null)
            echo "已安装版本: $INSTALLED_VERSION"
            VERSION_STRING=$(echo "$INSTALLED_VERSION" | grep -oE '[0-9]+\.[0-9]+' | head -1)
            if [[ -n "$VERSION_STRING" ]]; then
              MAJOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f1)
              MINOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f2)
              if [[ "$MAJOR_VERSION" -gt 2 ]] || [[ "$MAJOR_VERSION" -eq 2 && "$MINOR_VERSION" -ge 74 ]]; then
                CONTAINER_SELINUX_INSTALLED=true
                echo "✅ 从 RHEL 8 extras 源安装 container-selinux 成功，版本满足要求"
              else
                echo "⚠️  RHEL 8 extras 源版本仍然不满足要求"
              fi
            fi
          else
            echo "⚠️  RHEL 8 extras 源安装失败"
          fi
        else
          echo "⚠️  RHEL 8 extras 源配置失败"
        fi
        sudo rm -f /etc/yum.repos.d/rhel8-extras.repo 2>/dev/null
      fi
    fi
    
    # 方法3: 如果版本仍然不满足要求，标记为需要二进制安装
    if [[ "$CONTAINER_SELINUX_INSTALLED" == "false" ]]; then
      echo "⚠️  container-selinux 版本不满足要求（需要 >= 2:2.74）"
      echo "⚠️  将使用二进制安装方式绕过依赖问题"
      CONTAINER_SELINUX_ERROR=true
    fi
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."

  # 统信 UOS / 银河麒麟等自带的 docker-runc 与 Docker CE 的 containerd.io（内置 runc）冲突，需先移除再装 docker-ce
  if [[ "$OS" == "uos" || "$OS" == "uniontechos" || "$OS" == "kylin" ]]; then
    if rpm -q docker-runc &>/dev/null; then
      echo ">>> [2.9/8] 检测到系统包 docker-runc，与 Docker CE 依赖冲突，正在移除..."
      sudo $PKG_MANAGER remove -y docker-runc 2>/dev/null || true
    fi
  fi
  
  # 如果 container-selinux 版本不满足要求，直接使用二进制安装
  DOCKER_INSTALL_SUCCESS=false
  
  # 如果已经检测到 container-selinux 错误，直接跳过包管理器安装
  if [[ "$CONTAINER_SELINUX_ERROR" == "true" ]]; then
    echo ""
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo "⚠️  检测到 container-selinux 版本不满足要求"
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo "⚠️  Docker CE 需要 container-selinux >= 2:2.74，但系统源中无法提供"
    echo "⚠️  将使用二进制安装方式绕过依赖问题"
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # 清理可能的安装残留
    sudo $PKG_MANAGER remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>/dev/null || true
    
    echo "❌ 包管理器安装失败，切换到二进制安装..."
  else
    # 临时禁用 set -e，允许错误处理
    set +e
    
    echo "正在尝试安装 Docker CE（这可能需要几分钟，请耐心等待）..."
    echo "如果安装过程卡住，可能是网络问题或依赖解析中，请等待..."
    
    # 尝试安装 Docker，使用超时机制（30分钟超时）
    INSTALL_OUTPUT=""
    INSTALL_STATUS=1
    
    # 使用 timeout 命令（如果可用）或直接执行
    # 注意：使用 bash -c 确保 sudo 函数在子 shell 中可用
    if command -v timeout &> /dev/null; then
      INSTALL_OUTPUT=$(timeout 1800 bash -c "sudo $PKG_MANAGER install -y --allowerasing docker-ce docker-ce-cli containerd.io docker-buildx-plugin" 2>&1)
      INSTALL_STATUS=$?
      if [[ $INSTALL_STATUS -eq 124 ]]; then
        echo "❌ 安装超时（30分钟），可能是网络问题或依赖解析失败"
        INSTALL_STATUS=1
      fi
    else
      INSTALL_OUTPUT=$(sudo $PKG_MANAGER install -y --allowerasing docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>&1)
      INSTALL_STATUS=$?
    fi
    
    # 重新启用 set -e
    set -e
    
    if [[ $INSTALL_STATUS -eq 0 ]]; then
      echo "✅ Docker CE 安装成功"
      DOCKER_INSTALL_SUCCESS=true
    else
      # 显示详细错误信息
      echo ""
      echo "❌ Docker CE 批量安装失败"
      echo "错误详情："
      echo "$INSTALL_OUTPUT" | tail -20
      echo ""
      
      # 检查错误输出，判断是否是 container-selinux 依赖问题
      if echo "$INSTALL_OUTPUT" | grep -qi "container-selinux"; then
        CONTAINER_SELINUX_ERROR=true
        echo "❌ 检测到 container-selinux 依赖问题"
      fi
      
      # 检查是否是网络问题
      if echo "$INSTALL_OUTPUT" | grep -qiE "(timeout|timed out|connection|网络|network)"; then
        echo "⚠️  检测到可能的网络问题，请检查网络连接"
      fi
      
      # 检查是否是仓库问题
      if echo "$INSTALL_OUTPUT" | grep -qiE "(repo|repository|仓库|not found|找不到)"; then
        echo "⚠️  检测到可能的仓库配置问题，请检查 Docker 源配置"
      fi
      
      echo "正在尝试逐个安装组件..."
      
      # 临时禁用 set -e
      set +e
      
      # 逐个安装组件
      echo "  - 正在安装 containerd.io..."
      CONTAINERD_OUTPUT=$(sudo $PKG_MANAGER install -y containerd.io 2>&1)
      CONTAINERD_STATUS=$?
      if echo "$CONTAINERD_OUTPUT" | grep -qi "container-selinux"; then
        echo "  ❌ containerd.io 安装失败（container-selinux 依赖问题）"
        echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | grep -i "container-selinux" | head -1)"
        CONTAINER_SELINUX_ERROR=true
      elif [[ $CONTAINERD_STATUS -eq 0 ]]; then
        echo "  ✅ containerd.io 安装成功"
      else
        echo "  ❌ containerd.io 安装失败"
        echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | tail -5)"
        
        # 检测下载失败或校验和不匹配，尝试清理缓存后重试
        if echo "$CONTAINERD_OUTPUT" | grep -qiE "(Cannot download|all mirrors were already tried|下载失败|无法下载|checksum doesn't match|校验和不匹配)"; then
          echo "  ⚠️  检测到下载失败或校验和不匹配，尝试清理缓存后重试..."
          # 清理所有缓存，包括损坏的文件
          sudo $PKG_MANAGER clean all 2>/dev/null || true
          sudo rm -rf /var/cache/dnf/* 2>/dev/null || true
          sudo rm -rf /var/cache/yum/* 2>/dev/null || true
          echo "  - 重新尝试安装 containerd.io..."
          CONTAINERD_RETRY_OUTPUT=$(sudo $PKG_MANAGER install -y containerd.io 2>&1)
          CONTAINERD_RETRY_STATUS=$?
          if [[ $CONTAINERD_RETRY_STATUS -eq 0 ]]; then
            echo "  ✅ containerd.io 重试安装成功"
            CONTAINERD_STATUS=0
          else
            echo "  ❌ containerd.io 重试安装仍然失败"
            echo "  错误信息: $(echo "$CONTAINERD_RETRY_OUTPUT" | tail -5)"
            
            # 如果还是校验和不匹配，尝试安装其他版本
            if echo "$CONTAINERD_RETRY_OUTPUT" | grep -qiE "(checksum doesn't match|校验和不匹配)"; then
              echo "  ⚠️  检测到校验和不匹配，尝试安装其他版本的 containerd.io..."
              
              # 尝试多个可用版本（从新到旧）
              CONTAINERD_VERSIONS=("1.6.31-3.1.el8" "1.6.28-3.2.el8" "1.6.28-3.1.el8" "1.6.27-3.1.el8" "1.6.26-3.1.el8")
              CONTAINERD_INSTALLED=false
              
              for VERSION in "${CONTAINERD_VERSIONS[@]}"; do
                echo "  - 尝试安装 containerd.io-${VERSION}..."
                CONTAINERD_ALT_OUTPUT=$(sudo $PKG_MANAGER install -y containerd.io-${VERSION} 2>&1)
                CONTAINERD_ALT_STATUS=$?
                if [[ $CONTAINERD_ALT_STATUS -eq 0 ]]; then
                  echo "  ✅ containerd.io-${VERSION} 安装成功"
                  CONTAINERD_STATUS=0
                  CONTAINERD_INSTALLED=true
                  break
                else
                  # 检查是否是校验和不匹配，如果是则继续尝试下一个版本
                  if echo "$CONTAINERD_ALT_OUTPUT" | grep -qiE "(checksum doesn't match|校验和不匹配)"; then
                    echo "  ⚠️  containerd.io-${VERSION} 也存在校验和不匹配，尝试下一个版本..."
                    continue
                  else
                    echo "  ❌ containerd.io-${VERSION} 安装失败"
                    # 如果不是校验和问题，可能是其他问题，继续尝试下一个版本
                    continue
                  fi
                fi
              done
              
              if [[ "$CONTAINERD_INSTALLED" == "false" ]]; then
                echo "  ❌ 所有尝试的版本都安装失败"
                echo "  💡 建议：手动下载并安装 containerd.io"
                echo "    下载地址：https://mirrors.aliyun.com/docker-ce/linux/centos/8/${DOCKER_ARCH}/stable/Packages/"
                echo "    或尝试其他镜像源："
                echo "    - 腾讯云：https://mirrors.cloud.tencent.com/docker-ce/linux/centos/8/${DOCKER_ARCH}/stable/Packages/"
                echo "    - 华为云：https://mirrors.huaweicloud.com/docker-ce/linux/centos/8/${DOCKER_ARCH}/stable/Packages/"
                echo "    安装命令：sudo rpm -ivh containerd.io-*.rpm"
              fi
            else
              echo "  ⚠️  提示：containerd.io 是 Docker 的运行时依赖，如果无法安装，Docker daemon 可能无法启动"
              echo "  💡 建议：检查网络连接或尝试手动安装 containerd.io"
            fi
          fi
        fi
      fi
      
      echo "  - 正在安装 docker-ce-cli..."
      DOCKER_CLI_OUTPUT=$(sudo $PKG_MANAGER install -y docker-ce-cli 2>&1)
      DOCKER_CLI_STATUS=$?
      if [[ $DOCKER_CLI_STATUS -eq 0 ]]; then
        echo "  ✅ docker-ce-cli 安装成功"
      else
        echo "  ❌ docker-ce-cli 安装失败"
        echo "  错误信息: $(echo "$DOCKER_CLI_OUTPUT" | tail -5)"
      fi
      
      echo "  - 正在安装 docker-ce..."
      DOCKER_CE_OUTPUT=$(sudo $PKG_MANAGER install -y --allowerasing docker-ce 2>&1)
      DOCKER_CE_STATUS=$?
      if echo "$DOCKER_CE_OUTPUT" | grep -qi "container-selinux"; then
        echo "  ❌ docker-ce 安装失败（container-selinux 依赖问题）"
        echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | grep -i "container-selinux" | head -1)"
        CONTAINER_SELINUX_ERROR=true
      elif [[ $DOCKER_CE_STATUS -eq 0 ]]; then
        echo "  ✅ docker-ce 安装成功"
        DOCKER_INSTALL_SUCCESS=true
      else
        echo "  ❌ docker-ce 安装失败"
        echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | tail -5)"
      fi
      
      echo "  - 正在安装 docker-buildx-plugin..."
      BUILDX_OUTPUT=$(sudo $PKG_MANAGER install -y docker-buildx-plugin 2>&1)
      BUILDX_STATUS=$?
      if [[ $BUILDX_STATUS -eq 0 ]]; then
        echo "  ✅ docker-buildx-plugin 安装成功"
      else
        echo "  ⚠️  docker-buildx-plugin 安装失败（可选组件，不影响核心功能）"
      fi
      
      # 重新启用 set -e
      set -e
      
      # 检查是否至少安装了核心组件
      if command -v docker &> /dev/null; then
        DOCKER_INSTALL_SUCCESS=true
        echo ""
        echo "✅ Docker 核心组件已安装（docker 命令可用）"
        
        # 检查安装状态并给出提示
        if [[ $CONTAINERD_STATUS -ne 0 ]] || [[ $DOCKER_CE_STATUS -ne 0 ]]; then
          echo ""
          echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
          echo "⚠️  部分组件安装失败"
          echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
          if [[ $CONTAINERD_STATUS -ne 0 ]]; then
            echo "⚠️  containerd.io 未安装 - Docker daemon 需要此组件才能运行"
          fi
          if [[ $DOCKER_CE_STATUS -ne 0 ]]; then
            echo "⚠️  docker-ce 未安装 - Docker daemon 需要此组件才能运行"
          fi
          echo ""
          echo "📋 当前状态："
          echo "   ✅ docker-ce-cli 已安装（可以使用 docker 命令）"
          echo "   ✅ docker-buildx-plugin 已安装"
          if [[ $CONTAINERD_STATUS -ne 0 ]]; then
            echo "   ❌ containerd.io 未安装"
          else
            echo "   ✅ containerd.io 已安装"
          fi
          if [[ $DOCKER_CE_STATUS -ne 0 ]]; then
            echo "   ❌ docker-ce 未安装"
          else
            echo "   ✅ docker-ce 已安装"
          fi
          echo ""
          echo "💡 建议操作："
          if [[ $CONTAINERD_STATUS -ne 0 ]]; then
            echo "   1. 手动安装 containerd.io："
            echo "      sudo $PKG_MANAGER clean all"
            echo "      sudo $PKG_MANAGER makecache"
            echo "      sudo $PKG_MANAGER install -y containerd.io"
          fi
          if [[ $DOCKER_CE_STATUS -ne 0 ]]; then
            echo "   2. 安装 containerd.io 后，再安装 docker-ce："
            echo "      sudo $PKG_MANAGER install -y docker-ce"
          fi
          echo "   3. 或者检查网络连接后重新运行安装脚本"
          echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
        fi
      fi
    fi
  fi
  
  # 如果检测到 container-selinux 依赖问题，使用二进制安装
  if [[ "$CONTAINER_SELINUX_ERROR" == "true" ]]; then
    echo ""
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo "⚠️  检测到 container-selinux 依赖问题"
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo "⚠️  Docker CE 需要 container-selinux >= 2:2.74，但系统源中无法提供"
    echo "⚠️  将使用二进制安装方式绕过依赖问题"
    echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # 清理可能的安装残留
    sudo $PKG_MANAGER remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>/dev/null || true
    
    echo "❌ 包管理器安装失败，切换到二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        # 尝试安装 containerd.io（如果可能）
        echo "正在尝试安装 containerd.io..."
        if sudo $PKG_MANAGER install -y containerd.io 2>/dev/null; then
          echo "✅ containerd.io 安装成功"
        else
          echo "⚠️  containerd.io 安装失败，Docker 可能需要手动安装 containerd"
          echo "⚠️  如果 Docker 启动失败，请尝试手动安装 containerd.io"
        fi
        
        echo "✅ Docker 二进制安装成功"
        DOCKER_INSTALL_SUCCESS=true
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
  fi
  
  # 检测 systemd 是否可用：PID 1 须为 systemd 且 dbus 可连通（仅有 /run/systemd 在容器/WSL 中不可靠）
  SYSTEMD_AVAILABLE=false
  if command -v systemctl &>/dev/null; then
    PID1_COMM_KYLIN=$(tr -d '\0' < /proc/1/comm 2>/dev/null || echo "")
    if [[ "$PID1_COMM_KYLIN" == "systemd" ]] && systemctl show-environment &>/dev/null; then
      SYSTEMD_AVAILABLE=true
    fi
  fi
  
  if [[ "$SYSTEMD_AVAILABLE" == "true" ]]; then
    echo "正在启动 Docker 服务..."
    sudo systemctl daemon-reload 2>/dev/null || true
    if sudo systemctl enable docker 2>/dev/null; then
      echo "✅ Docker 服务已启用"
    fi
    if sudo systemctl start docker 2>/dev/null; then
      echo "✅ Docker 服务启动成功"
    else
      echo "⚠️  systemctl 启动失败，尝试手动启动..."
      # 尝试手动启动 dockerd
      if sudo dockerd > /dev/null 2>&1 & then
        sleep 3
        if docker info &>/dev/null; then
          echo "✅ Docker daemon 手动启动成功"
        else
          echo "⚠️  Docker daemon 启动失败，请手动启动: sudo dockerd &"
        fi
      fi
    fi
  else
    echo "⚠️  检测到 systemd 不可用（可能是容器环境）"
    echo "⚠️  将尝试手动启动 Docker daemon..."
    # 创建必要的目录
    sudo mkdir -p /var/run/docker
    sudo mkdir -p /var/lib/docker
    
    # 尝试启动 dockerd
    if sudo dockerd > /tmp/dockerd.log 2>&1 & then
      DOCKERD_PID=$!
      sleep 3
      if docker info &>/dev/null; then
        echo "✅ Docker daemon 手动启动成功 (PID: $DOCKERD_PID)"
        echo "⚠️  注意：Docker daemon 在后台运行，退出终端前请使用 'sudo kill $DOCKERD_PID' 停止"
      else
        echo "⚠️  Docker daemon 启动可能失败，请检查日志: cat /tmp/dockerd.log"
        echo "⚠️  可以尝试手动启动: sudo dockerd &"
      fi
    else
      echo "⚠️  无法自动启动 Docker daemon，请手动执行: sudo dockerd &"
    fi
  fi
  
  echo ">>> [3.5/8] 安装 Docker Compose..."
  # 安装最新版本的 docker-compose，使用多个备用下载源
  echo "正在下载 Docker Compose..."
  
  # 尝试多个下载源
  DOCKER_COMPOSE_DOWNLOADED=false
  
  # 确定 Docker Compose 架构标识（使用已定义的DOCKER_ARCH变量）
  if [[ "$ARCH" == "x86_64" ]]; then
    COMPOSE_ARCH="x86_64"
  elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
    COMPOSE_ARCH="aarch64"
  else
    COMPOSE_ARCH="$DOCKER_ARCH"
  fi
  
  # 临时文件路径
  COMPOSE_TMP="/tmp/docker-compose-$$"
  
  # 源1: 优先使用包管理器安装（最可靠）
  echo "尝试使用包管理器安装 docker-compose-plugin..."
  if sudo $PKG_MANAGER install -y docker-compose-plugin 2>/dev/null; then
    echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
    DOCKER_COMPOSE_DOWNLOADED=true
  else
    echo "⚠️  包管理器安装失败，尝试从国内镜像源下载..."
  fi
  
  # 源2: 使用国内镜像源下载（如果包管理器失败）
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    # 尝试使用 get.docker.com 的镜像（如果有）
    echo "尝试从国内镜像源下载 docker-compose..."
    
    # 使用固定版本 v2.24.0，从国内镜像下载
    # 注意：国内镜像源可能没有最新版本，使用固定版本更可靠
    COMPOSE_VERSION="2.24.0"
    
    # 尝试多个国内镜像源
    # 源2.1: 阿里云镜像（如果有）
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "尝试从阿里云镜像下载 docker-compose v${COMPOSE_VERSION}..."
      # 注意：国内镜像源可能没有 docker-compose，这里尝试但不保证成功
      if sudo curl -L "https://mirrors.aliyun.com/docker-toolbox/linux/compose/${COMPOSE_VERSION}/docker-compose-Linux-${COMPOSE_ARCH}" -o "$COMPOSE_TMP" --connect-timeout 10 --max-time 60 2>/dev/null; then
        FILE_SIZE=$(stat -f%z "$COMPOSE_TMP" 2>/dev/null || stat -c%s "$COMPOSE_TMP" 2>/dev/null || echo "0")
        if [[ "$FILE_SIZE" -gt 10485760 ]] || (file "$COMPOSE_TMP" 2>/dev/null | grep -q "ELF\|executable\|binary") || (head -c 4 "$COMPOSE_TMP" 2>/dev/null | od -An -tx1 | grep -q "7f 45 4c 46"); then
          sudo mv "$COMPOSE_TMP" /usr/local/bin/docker-compose
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从阿里云镜像下载成功"
        else
          if head -c 20 "$COMPOSE_TMP" 2>/dev/null | grep -q "<!DOCTYPE\|<html"; then
            echo "❌ 下载的文件是 HTML 页面，不是二进制文件"
          fi
          sudo rm -f "$COMPOSE_TMP"
        fi
      fi
    fi
  fi
  
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
    # 如果安装的是独立的 docker-compose 二进制文件
    if [[ -f /usr/local/bin/docker-compose ]]; then
      # 设置执行权限
      sudo chmod +x /usr/local/bin/docker-compose
      
      # 创建软链接到 PATH 目录
      sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose 2>/dev/null || true
      
      echo "✅ Docker Compose 安装完成"
    elif command -v docker &>/dev/null && docker compose version &>/dev/null; then
      echo "✅ Docker Compose Plugin 已安装（使用 'docker compose' 命令）"
    fi
  else
    echo "⚠️  Docker Compose 自动安装失败"
    echo ""
    echo "📋 手动安装方法："
    echo "  方法1: 使用包管理器（推荐）"
    echo "    sudo $PKG_MANAGER install -y docker-compose-plugin"
    echo ""
    echo "  方法2: 手动下载二进制文件"
    echo "    由于 GitHub 在国内访问受限，建议："
    echo "    1. 使用代理或 VPN 访问 GitHub"
    echo "    2. 或从其他可靠源下载 docker-compose 二进制文件"
    echo ""
    echo "  安装后验证："
    echo "    docker compose version  或  docker-compose version"
    echo ""
    echo "  更多信息: https://docs.docker.com/compose/install/"
  fi

elif [[ "$OS" == "almalinux" ]]; then
  # AlmaLinux (CentOS 替代品) 支持
  echo "检测到 AlmaLinux $VERSION_ID"
  echo "AlmaLinux 是 RHEL 的 1:1 二进制兼容克隆，企业级长期支持"
  
  # AlmaLinux 使用 dnf 而不是 yum
  sudo dnf install -y dnf-utils
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，使用 AlmaLinux 兼容的 CentOS 9 版本
  echo "正在创建 Docker 仓库配置 (使用 CentOS 9 兼容源)..."
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo dnf makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo dnf makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 临时禁用 set -e，允许错误处理
  set +e
  
  echo "正在尝试安装 Docker CE（这可能需要几分钟，请耐心等待）..."
  echo "如果安装过程卡住，可能是网络问题或依赖解析中，请等待..."
  
  # 尝试安装 Docker，使用超时机制（30分钟超时）
  INSTALL_OUTPUT=""
  INSTALL_STATUS=1
  
  # 使用 timeout 命令（如果可用）或直接执行
  # 注意：使用 bash -c 确保 sudo 函数在子 shell 中可用
  if command -v timeout &> /dev/null; then
    INSTALL_OUTPUT=$(timeout 1800 bash -c "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin" 2>&1)
    INSTALL_STATUS=$?
    if [[ $INSTALL_STATUS -eq 124 ]]; then
      echo "❌ 安装超时（30分钟），可能是网络问题或依赖解析失败"
      INSTALL_STATUS=1
    fi
  else
    INSTALL_OUTPUT=$(sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 2>&1)
    INSTALL_STATUS=$?
  fi
  
  # 重新启用 set -e
  set -e
  
  if [[ $INSTALL_STATUS -eq 0 ]]; then
    echo "✅ Docker CE 安装成功"
  else
    # 显示详细错误信息
    echo ""
    echo "❌ Docker CE 批量安装失败"
    echo "错误详情："
    echo "$INSTALL_OUTPUT" | tail -20
    echo ""
    
    # 检查错误类型
    if echo "$INSTALL_OUTPUT" | grep -qiE "(timeout|timed out|connection|网络|network)"; then
      echo "⚠️  检测到可能的网络问题，请检查网络连接"
    fi
    if echo "$INSTALL_OUTPUT" | grep -qiE "(repo|repository|仓库|not found|找不到)"; then
      echo "⚠️  检测到可能的仓库配置问题，请检查 Docker 源配置"
    fi
    
    echo "正在尝试逐个安装组件..."
    
    # 临时禁用 set -e
    set +e
    
    # 逐个安装组件
    echo "  - 正在安装 containerd.io..."
    CONTAINERD_OUTPUT=$(sudo dnf install -y containerd.io 2>&1)
    CONTAINERD_STATUS=$?
    if [[ $CONTAINERD_STATUS -eq 0 ]]; then
      echo "  ✅ containerd.io 安装成功"
    else
      echo "  ❌ containerd.io 安装失败"
      echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce-cli..."
    DOCKER_CLI_OUTPUT=$(sudo dnf install -y docker-ce-cli 2>&1)
    DOCKER_CLI_STATUS=$?
    if [[ $DOCKER_CLI_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce-cli 安装成功"
    else
      echo "  ❌ docker-ce-cli 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CLI_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce..."
    DOCKER_CE_OUTPUT=$(sudo dnf install -y docker-ce 2>&1)
    DOCKER_CE_STATUS=$?
    if [[ $DOCKER_CE_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce 安装成功"
    else
      echo "  ❌ docker-ce 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-buildx-plugin..."
    BUILDX_OUTPUT=$(sudo dnf install -y docker-buildx-plugin 2>&1)
    BUILDX_STATUS=$?
    if [[ $BUILDX_STATUS -eq 0 ]]; then
      echo "  ✅ docker-buildx-plugin 安装成功"
    else
      echo "  ⚠️  docker-buildx-plugin 安装失败（可选组件，不影响核心功能）"
    fi
    
    # 重新启用 set -e
    set -e
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo ""
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
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
  
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
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
    if sudo dnf install -y docker-compose-plugin; then
      echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
      DOCKER_COMPOSE_DOWNLOADED=true
    else
      echo "❌ 包管理器安装也失败了"
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

elif [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$OS" == "deepin" ]]; then
  # 检查 Debian/Ubuntu/Kali/Deepin 版本，为老版本提供兼容性支持
  if [[ ("$OS" == "debian" && ("$VERSION_ID" == "9" || "$VERSION_ID" == "10")) || ("$OS" == "ubuntu" && "$VERSION_ID" == "16.04") ]]; then
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      echo "⚠️  检测到 Debian 9 (Stretch)，使用兼容的安装方法..."
      echo "⚠️  注意：Debian 9 已于 2020年7月停止主线支持，2022年6月停止LTS支持"
      echo "⚠️  建议升级到 Debian 10 (Buster) 或更高版本"
    elif [[ "$OS" == "debian" && "$VERSION_ID" == "10" ]]; then
      echo "⚠️  检测到 Debian 10 (Buster)，使用兼容的安装方法..."
      echo "⚠️  注意：Debian 10 将于 2024年6月停止主线支持，建议考虑升级到 Debian 11+"
    elif [[ "$OS" == "ubuntu" && "$VERSION_ID" == "16.04" ]]; then
      echo "⚠️  检测到 Ubuntu 16.04 (Xenial)，使用兼容的安装方法..."
      echo "⚠️  注意：Ubuntu 16.04 已于 2021 年结束生命周期，将使用特殊处理..."
    fi
    
    # 清理损坏的软件源索引文件
    echo "正在清理损坏的软件源索引文件..."
    sudo rm -rf /var/lib/apt/lists/*
    sudo rm -rf /var/lib/apt/lists/partial/*
    
    # 强制清理 apt 缓存
    sudo apt-get clean
    sudo apt-get autoclean
    
    # 为 Debian 9/10 或 Ubuntu 16.04 配置更兼容的软件源
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      echo "正在配置 Debian 9 兼容的软件源..."
      
      # ⚠️ Debian 9 (Stretch) 生命周期结束警告
      echo ""
      echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
      echo "⚠️  重要提醒：Debian 9 (Stretch) 生命周期已结束"
      echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
      echo "⚠️  📅 2020 年 7 月：停止主线支持（EOL）"
      echo "⚠️  📅 2022 年 6 月：停止 LTS（长期支持）"
      echo "⚠️  "
      echo "⚠️  之后，不再在 deb.debian.org 和 security.debian.org 提供软件包"
      echo "⚠️  建议升级到至少 Debian 10 (Buster) 或更高版本"
      echo "⚠️  "
      echo "⚠️  当前将使用归档源继续安装，但强烈建议尽快升级系统"
      echo "⚠️  ═══════════════════════════════════════════════════════════════════════════════"
      echo ""
      
      # 备份原始源列表
      sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)
      
      # Debian 9 已停止支持，使用归档源
      echo "正在配置 Debian 9 归档源（官方源已停止支持）..."
      
      # 使用官方归档源（亲测可用）
      sudo tee /etc/apt/sources.list > /dev/null <<EOF
# Debian 9 (Stretch) 官方归档源 - 主要源
# ⚠️ 注意：Debian 9 已停止支持，建议升级到 Debian 10+ 或更高版本
deb http://archive.debian.org/debian stretch main contrib non-free
deb http://archive.debian.org/debian-security stretch/updates main contrib non-free

# 国内归档镜像源 - 备用源（速度快）
# 阿里云归档源
# deb http://mirrors.aliyun.com/debian-archive/debian stretch main contrib non-free
# deb http://mirrors.aliyun.com/debian-archive/debian-security stretch/updates main contrib non-free

# 清华大学归档源
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-archive/debian stretch main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-archive/debian-security stretch/updates main contrib non-free
EOF
      
      echo "✅ Debian 9 归档源配置完成"
      echo "💡 建议：安装完成后考虑升级到 Debian 10 (Buster) 或更高版本"
    elif [[ "$VERSION_ID" == "10" ]]; then
      echo "正在配置 Debian 10 兼容的软件源..."
      
      # 备份原始源列表
      sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)
      
      # 使用国内镜像源替代 archive.debian.org，提高下载速度
      echo "正在配置国内镜像源以提高下载速度..."
      
      # 尝试配置阿里云镜像源
      sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 阿里云镜像源 - 主要源
deb http://mirrors.aliyun.com/debian/ buster main contrib non-free
deb http://mirrors.aliyun.com/debian-security/ buster/updates main contrib non-free
deb http://mirrors.aliyun.com/debian/ buster-updates main contrib non-free

# 备用源 - 腾讯云镜像
# deb http://mirrors.cloud.tencent.com/debian/ buster main contrib non-free
# deb http://mirrors.cloud.tencent.com/debian-security/ buster/updates main contrib non-free
# deb http://mirrors.cloud.tencent.com/debian/ buster-updates main contrib non-free

# 备用源 - 华为云镜像
# deb http://mirrors.huaweicloud.com/debian/ buster main contrib non-free
# deb http://mirrors.huaweicloud.com/debian-security/ buster/updates main contrib non-free
# deb http://mirrors.huaweicloud.com/debian/ buster-updates main contrib non-free

# 最后备用 - archive.debian.org（如果国内源都不可用）
# deb http://archive.debian.org/debian/ buster main
# deb http://archive.debian.org/debian-security/ buster/updates main
# deb http://archive.debian.org/debian/ buster-updates main
EOF
      
      echo "✅ Debian 10 国内镜像源配置完成"
    elif [[ "$OS" == "ubuntu" && "$VERSION_ID" == "16.04" ]]; then
      echo "正在配置 Ubuntu 16.04 兼容的软件源..."
      echo "⚠️  Ubuntu 16.04 官方支持已结束，建议升级到 Ubuntu 20.04 LTS 或更高版本"
      echo "✅ Ubuntu 16.04 软件源配置保持现状（通常已配置国内镜像源）"
    fi
    
    # 首先尝试安装基本工具
    echo "正在安装基本工具..."
    
    # 测试软件源可用性并自动切换
    echo "正在测试软件源可用性..."
    # Debian 9 需要忽略过期校验
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      if sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false 2>/dev/null; then
        echo "✅ 当前软件源可用"
      else
        echo "⚠️  当前软件源不可用，尝试切换到备用源..."
        
        # 尝试腾讯云镜像源
        DEBIAN_CODENAME="stretch"
        
        sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 腾讯云镜像源
deb http://mirrors.cloud.tencent.com/debian/ ${DEBIAN_CODENAME} main contrib non-free
deb http://mirrors.cloud.tencent.com/debian-security/ ${DEBIAN_CODENAME}/updates main contrib non-free
deb http://mirrors.cloud.tencent.com/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free
EOF
        
        if sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false 2>/dev/null; then
          echo "✅ 腾讯云镜像源可用"
        else
          echo "⚠️  腾讯云镜像源也不可用，尝试华为云镜像源..."
          
          # 尝试华为云镜像源
          sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 华为云镜像源
deb http://mirrors.huaweicloud.com/debian/ ${DEBIAN_CODENAME} main contrib non-free
deb http://mirrors.huaweicloud.com/debian-security/ ${DEBIAN_CODENAME}/updates main contrib non-free
deb http://mirrors.huaweicloud.com/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free
EOF
          
          if sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false 2>/dev/null; then
            echo "✅ 华为云镜像源可用"
          else
            echo "⚠️  所有国内镜像源都不可用，回退到 archive.debian.org..."
            
            # 回退到 archive.debian.org
            sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 官方归档源（速度较慢但稳定）
deb http://archive.debian.org/debian/ ${DEBIAN_CODENAME} main
deb http://archive.debian.org/debian-security/ ${DEBIAN_CODENAME}/updates main
deb http://archive.debian.org/debian/ ${DEBIAN_CODENAME}-updates main
EOF
            
            sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false || true
          fi
        fi
      fi
    else
      if sudo apt-get update --allow-unauthenticated 2>/dev/null; then
        echo "✅ 当前软件源可用"
      else
        echo "⚠️  当前软件源不可用，尝试切换到备用源..."
        
        # 尝试腾讯云镜像源
        if [[ "$OS" == "debian" && "$VERSION_ID" == "10" ]]; then
          DEBIAN_CODENAME="buster"
        else
          DEBIAN_CODENAME="buster"  # 默认使用 buster
        fi
        
        sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 腾讯云镜像源
deb http://mirrors.cloud.tencent.com/debian/ ${DEBIAN_CODENAME} main contrib non-free
deb http://mirrors.cloud.tencent.com/debian-security/ ${DEBIAN_CODENAME}/updates main contrib non-free
deb http://mirrors.cloud.tencent.com/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free
EOF
        
        if sudo apt-get update --allow-unauthenticated 2>/dev/null; then
          echo "✅ 腾讯云镜像源可用"
        else
          echo "⚠️  腾讯云镜像源也不可用，尝试华为云镜像源..."
          
          # 尝试华为云镜像源
          sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 华为云镜像源
deb http://mirrors.huaweicloud.com/debian/ ${DEBIAN_CODENAME} main contrib non-free
deb http://mirrors.huaweicloud.com/debian-security/ ${DEBIAN_CODENAME}/updates main contrib non-free
deb http://mirrors.huaweicloud.com/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free
EOF
          
          if sudo apt-get update --allow-unauthenticated 2>/dev/null; then
            echo "✅ 华为云镜像源可用"
          else
            echo "⚠️  所有国内镜像源都不可用，回退到 archive.debian.org..."
            
            # 回退到 archive.debian.org
            sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 官方归档源（速度较慢但稳定）
deb http://archive.debian.org/debian/ ${DEBIAN_CODENAME} main
deb http://archive.debian.org/debian-security/ ${DEBIAN_CODENAME}/updates main
deb http://archive.debian.org/debian/ ${DEBIAN_CODENAME}-updates main
EOF
            
            sudo apt-get update --allow-unauthenticated || true
          fi
        fi
      fi
    fi
    
    # 尝试安装必要的依赖包
    echo "正在安装必要的依赖包..."
    if sudo apt-get install -y --allow-unauthenticated apt-transport-https ca-certificates gnupg lsb-release; then
      echo "✅ 必要依赖包安装成功"
    else
      echo "⚠️  依赖包安装失败，尝试逐个安装..."
      
      # 逐个安装依赖包
      if sudo apt-get install -y --allow-unauthenticated apt-transport-https; then
        echo "✅ apt-transport-https 安装成功"
      else
        echo "⚠️  apt-transport-https 安装失败"
      fi
      
      if sudo apt-get install -y --allow-unauthenticated ca-certificates; then
        echo "✅ ca-certificates 安装成功"
      else
        echo "⚠️  ca-certificates 安装失败"
      fi
      
      if sudo apt-get install -y --allow-unauthenticated gnupg; then
        echo "✅ gnupg 安装成功"
      else
        echo "⚠️  gnupg 安装失败"
      fi
      
      if sudo apt-get install -y --allow-unauthenticated lsb-release; then
        echo "✅ lsb-release 安装成功"
      else
        echo "⚠️  lsb-release 安装失败"
      fi
    fi
    
    # 尝试安装 dirmngr 和 curl
    if sudo apt-get install -y --allow-unauthenticated dirmngr; then
      echo "✅ dirmngr 安装成功"
    else
      echo "⚠️  dirmngr 安装失败，将使用备用方法"
    fi
    
    if sudo apt-get install -y --allow-unauthenticated curl; then
      echo "✅ curl 安装成功"
    else
      echo "⚠️  curl 安装失败，将使用备用方法"
    fi
    
    # 为 Debian 10 或 Ubuntu 16.04 跳过有问题的包安装，直接使用二进制安装
    if [[ "$VERSION_ID" == "10" || ("$OS" == "ubuntu" && "$VERSION_ID" == "16.04") ]]; then
      if [[ "$OS" == "debian" ]]; then
        echo "⚠️  Debian 10 检测到软件源问题，跳过包管理器安装，直接使用二进制安装..."
      else
        echo "⚠️  Ubuntu 16.04 的 Docker 仓库缺少某些新组件，使用二进制安装..."
      fi
      echo "正在下载 Docker 二进制包..."
      
      # 尝试从多个源下载 Docker 二进制包
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker CE 二进制安装成功"
        
        # 启动 Docker 服务
        echo "正在启动 Docker 服务..."
        sudo systemctl daemon-reload
        sudo systemctl enable docker
        
        # 尝试启动 Docker 服务
        if sudo systemctl start docker; then
          echo "✅ Docker 服务启动成功"
        else
          echo "❌ Docker 服务启动失败，正在诊断问题..."
          
          # 检查服务状态
          echo "Docker 服务状态："
          sudo systemctl status docker --no-pager -l
          
          # 检查日志
          echo "Docker 服务日志："
          sudo journalctl -u docker --no-pager -l --since "5 minutes ago"
          
          # 尝试手动启动 dockerd 进行调试
          echo "尝试手动启动 dockerd 进行调试..."
          sudo /usr/bin/dockerd --debug --log-level=debug &
          DOCKERD_PID=$!
          sleep 5
          
          # 检查 dockerd 是否成功启动
          if sudo kill -0 $DOCKERD_PID 2>/dev/null; then
            echo "✅ dockerd 手动启动成功，问题可能在 systemd 配置"
            sudo kill $DOCKERD_PID
          else
            echo "❌ dockerd 手动启动也失败，请检查系统兼容性"
          fi
          
          echo "故障排除建议："
          echo "1. 检查系统是否支持 Docker"
          echo "2. 检查是否有其他容器运行时冲突"
          echo "3. 检查系统资源是否充足"
          echo "4. 尝试重启系统后再次运行脚本"
          
          exit 1
        fi
        
        # 安装 Docker Compose
        echo ">>> [3.5/8] 安装 Docker Compose..."
        echo "正在下载 Docker Compose..."
        
        # 确定 Docker Compose 架构标识
        if [[ "$ARCH" == "x86_64" ]]; then
          COMPOSE_ARCH="x86_64"
        elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
          COMPOSE_ARCH="aarch64"
        else
          COMPOSE_ARCH="$DOCKER_ARCH"
        fi
        
        # 尝试多个下载源
        DOCKER_COMPOSE_DOWNLOADED=false
        
        # 直接使用 GitHub 官方源（最可靠）
        echo "正在从 GitHub 官方源下载 Docker Compose..."
        if sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-linux-${COMPOSE_ARCH}" -o /usr/local/bin/docker-compose --connect-timeout 30 --max-time 120; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从 GitHub 官方源下载成功"
        else
          echo "❌ GitHub 官方源下载失败"
          echo "💡 建议检查网络连接或使用代理"
        fi
        
        if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
          sudo chmod +x /usr/local/bin/docker-compose
          sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
          echo "✅ Docker Compose 安装完成"
        else
          echo "❌ 所有 Docker Compose 下载源都失败"
          echo "💡 建议：可以稍后手动安装 Docker Compose"
          echo "   下载地址：https://github.com/docker/compose/releases"
        fi
        
        # 跳过后续的包管理器安装流程
        echo ">>> [4/8] Docker 安装完成，跳过包管理器安装流程..."
        echo "✅ Docker 已通过二进制方式安装成功"
        echo "✅ Docker Compose 已安装"
        echo "✅ Docker 服务已启动"
        
        # 直接进入镜像配置
        echo ">>> [5/8] 配置轩辕镜像..."
        
        # 循环等待用户选择镜像版本
        while true; do
            echo "请选择版本:"
            echo "1) 轩辕镜像免费版 (域名: docker.xuanyuan.me)"
            echo "2) 轩辕镜像专业版 (专属域名 *.xuanyuan.run / *.xuanyuan.dev 不含免费版域名)"
            echo "3) 恢复/重置镜像相关配置"
            read -p "请输入选择 [1/2/3]: " choice
            
            if [[ "$choice" == "1" || "$choice" == "2" ]]; then
                break
            elif [[ "$choice" == "3" ]]; then
                restore_docker_daemon_config
                exit $?
            else
                echo "❌ 无效选择，请输入 1、2 或 3"
                echo ""
            fi
        done
        
        mirror_list=""
        
        if [[ "$choice" == "2" ]]; then
          read -p "请输入您的轩辕镜像专属域名 (访问官网获取：https://xuanyuan.cloud): " custom_domain

          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_run"
]
EOF
)
          else
            mirror_list=$(cat <<EOF
[
  "https://$custom_domain"
]
EOF
)
          fi
        else
          mirror_list=$(cat <<EOF
[
  "https://docker.xuanyuan.me"
]
EOF
)
        fi

        mkdir -p /etc/docker

        # 根据用户选择设置 insecure-registries
        if [[ "$choice" == "2" ]]; then
          # 清理用户输入的域名，移除协议前缀
          custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
          
          # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
          if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev"
]
EOF
)
          elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_run"
]
EOF
)
          else
            insecure_registries=$(cat <<EOF
[
  "$custom_domain"
]
EOF
)
          fi
        else
          insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
        fi

        # 准备 DNS 配置字符串
dns_config=""
if [[ "$SKIP_DNS" != "true" ]]; then
  if ! grep -q "nameserver" /etc/resolv.conf; then
     dns_config=',
  "dns": ["119.29.29.29", "114.114.114.114"]'
  else
     echo "ℹ️  检测到系统已配置 DNS，跳过 Docker DNS 配置以避免冲突"
  fi
fi

cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries$dns_config
}
EOF
        
        sudo systemctl daemon-reexec || true
        sudo systemctl restart docker || true
        
        echo ">>> [6/8] 安装完成！"
        echo "🎉Docker 镜像已配置完成"
        echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
        echo "官方网站: https://xuanyuan.cloud/"
        
        # 显示当前配置的镜像源
        echo ""
        echo "当前配置的镜像源："
        if [[ "$choice" == "2" ]]; then
            if [[ "$custom_domain" == *.xuanyuan.run ]]; then
                custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_dev (备用)"
            elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
                custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
                echo "  - https://$custom_domain (优先)"
                echo "  - https://$custom_domain_run (备用)"
            else
                echo "  - https://$custom_domain"
            fi
        else
            echo "  - https://docker.xuanyuan.me"
        fi
        echo ""
        
        echo "🎉 安装和配置完成！"
        echo ""
        echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
        echo "官方网站: https://xuanyuan.cloud/"
        exit 0
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
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
    # Debian 9 需要忽略过期校验
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false || true
    else
      sudo apt-get update --allow-unauthenticated || true
    fi
    
    # 如果还是失败，尝试强制更新
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      if ! sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false; then
        echo "⚠️  软件源更新失败，尝试强制更新..."
        sudo apt-get update --allow-unauthenticated --fix-missing -o Acquire::Check-Valid-Until=false || true
      fi
    else
      if ! sudo apt-get update --allow-unauthenticated; then
        echo "⚠️  软件源更新失败，尝试强制更新..."
        sudo apt-get update --allow-unauthenticated --fix-missing || true
      fi
    fi
    
    # 安装必要的依赖包，允许未认证的包
    echo "正在安装必要的依赖包..."
    sudo apt-get install -y --allow-unauthenticated --fix-broken ca-certificates gnupg lsb-release apt-transport-https || true
    
    # 如果某些包安装失败，尝试逐个安装
    if ! dpkg -l | grep -q "ca-certificates"; then
      echo "尝试单独安装 ca-certificates..."
      sudo apt-get install -y --allow-unauthenticated ca-certificates || true
    fi
    
    if ! dpkg -l | grep -q "gnupg"; then
      echo "尝试单独安装 gnupg..."
      sudo apt-get install -y --allow-unauthenticated gnupg || true
    fi
    
    # 添加 Docker 官方 GPG 密钥
    echo "正在添加 Docker 官方 GPG 密钥..."
    if command -v curl &> /dev/null; then
      # 尝试从国内镜像下载 GPG 密钥
      if sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从阿里云镜像下载 Docker GPG 密钥成功"
      elif sudo curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从腾讯云镜像下载 Docker GPG 密钥成功"
      elif sudo curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从华为云镜像下载 Docker GPG 密钥成功"
      else
        echo "❌ 所有国内镜像都无法下载 Docker GPG 密钥"
      fi
    elif command -v wget &> /dev/null; then
      # 尝试从国内镜像下载 GPG 密钥
      if sudo wget -qO- https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从阿里云镜像下载 Docker GPG 密钥成功"
      elif sudo wget -qO- https://mirrors.cloud.tencent.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从腾讯云镜像下载 Docker GPG 密钥成功"
      elif sudo wget -qO- https://mirrors.huaweicloud.com/docker-ce/linux/debian/gpg | sudo apt-key add -; then
        echo "✅ 从华为云镜像下载 Docker GPG 密钥成功"
      else
        echo "❌ 所有国内镜像都无法下载 Docker GPG 密钥"
      fi
    else
      echo "❌ 无法下载 Docker GPG 密钥，curl 和 wget 都不可用"
    fi
    
    # 添加 Docker 仓库（使用国内镜像源）
    echo "正在添加 Docker 仓库..."
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      DEBIAN_CODENAME="stretch"
    elif [[ "$OS" == "debian" && "$VERSION_ID" == "10" ]]; then
      DEBIAN_CODENAME="buster"
    else
      DEBIAN_CODENAME="stretch"  # 默认使用 stretch
    fi
    
    # 尝试配置国内 Docker 镜像源
    echo "deb [arch=$(dpkg --print-architecture)] https://mirrors.aliyun.com/docker-ce/linux/debian ${DEBIAN_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 再次更新，这次包含 Docker 仓库
    echo "正在更新包含 Docker 仓库的软件包列表..."
    # Debian 9 需要忽略过期校验
    if [[ "$OS" == "debian" && "$VERSION_ID" == "9" ]]; then
      sudo apt-get update --allow-unauthenticated -o Acquire::Check-Valid-Until=false || true
    else
      sudo apt-get update --allow-unauthenticated || true
    fi
    
    echo ">>> [3/8] 安装 Docker CE 兼容版本..."
    echo "正在安装 Docker CE..."
    sudo apt-get install -y --allow-unauthenticated --fix-broken docker-ce docker-ce-cli containerd.io || true
    
    # 检查 Docker 是否安装成功
    if command -v docker &> /dev/null; then
      echo "✅ Docker CE 安装成功"
    else
      echo "❌ Docker CE 安装失败，尝试备用方法..."
      # 尝试从多个源下载 Docker 二进制包
      echo "正在下载 Docker 二进制包..."
      DOCKER_BINARY_DOWNLOADED=false
      
      if command -v curl &> /dev/null; then
        # 源1: 阿里云镜像
        echo "尝试从阿里云镜像下载 Docker 二进制包..."
        if sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从阿里云镜像下载成功"
        else
          echo "❌ 阿里云镜像下载失败，尝试下一个源..."
        fi
        
        # 源2: 腾讯云镜像
        if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
          echo "尝试从腾讯云镜像下载 Docker 二进制包..."
          if sudo curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
            DOCKER_BINARY_DOWNLOADED=true
            echo "✅ 从腾讯云镜像下载成功"
          else
            echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
          fi
        fi
        
        # 源3: 华为云镜像
        if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
          echo "尝试从华为云镜像下载 Docker 二进制包..."
          if sudo curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
            DOCKER_BINARY_DOWNLOADED=true
            echo "✅ 从华为云镜像下载成功"
          else
            echo "❌ 华为云镜像下载失败"
          fi
        fi
      elif command -v wget &> /dev/null; then
        # 源1: 阿里云镜像
        echo "尝试从阿里云镜像下载 Docker 二进制包..."
        if sudo wget -O /tmp/docker.tgz https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz --timeout=60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从阿里云镜像下载成功"
        else
          echo "❌ 阿里云镜像下载失败，尝试下一个源..."
        fi
        
        # 源2: 腾讯云镜像
        if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
          echo "尝试从腾讯云镜像下载 Docker 二进制包..."
          if sudo wget -O /tmp/docker.tgz https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz --timeout=60; then
            DOCKER_BINARY_DOWNLOADED=true
            echo "✅ 从腾讯云镜像下载成功"
          else
            echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
          fi
        fi
        
        # 源3: 华为云镜像
        if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
          echo "尝试从华为云镜像下载 Docker 二进制包..."
          if sudo wget -O /tmp/docker.tgz https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz --timeout=60; then
            DOCKER_BINARY_DOWNLOADED=true
            echo "✅ 从华为云镜像下载成功"
          else
            echo "❌ 华为云镜像下载失败"
          fi
        fi
      else
        echo "❌ 无法下载 Docker 二进制包，curl 和 wget 都不可用"
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" && -f /tmp/docker.tgz ]]; then
        echo "正在解压 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /tmp
        sudo cp /tmp/docker/* /usr/bin/
        sudo chmod +x /usr/bin/docker*
        echo "✅ Docker CE 二进制安装成功"
      else
        echo "❌ Docker 二进制下载失败"
      fi
    fi
    
    echo ">>> [3.5/8] 安装 Docker Compose 兼容版本..."
    # Debian 9 使用较老版本的 docker-compose
    echo "正在下载兼容的 Docker Compose..."
    
    # 确定 Docker Compose 架构标识
    if [[ "$ARCH" == "x86_64" ]]; then
      COMPOSE_ARCH="x86_64"
    elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
      COMPOSE_ARCH="aarch64"
    else
      COMPOSE_ARCH="$DOCKER_ARCH"
    fi
    
    DOCKER_COMPOSE_DOWNLOADED=false
    
    # 尝试从多个源下载兼容版本
    echo "正在尝试从多个源下载 Docker Compose 兼容版本..."
    
    # 源1: 阿里云镜像
    if command -v curl &> /dev/null; then
      echo "尝试从阿里云镜像下载兼容版本..."
      if sudo curl -L "https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.25.5/docker-compose-linux-${COMPOSE_ARCH}" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载兼容版本成功"
      fi
    elif command -v wget &> /dev/null; then
      echo "尝试从阿里云镜像下载兼容版本..."
      if sudo wget -O /usr/local/bin/docker-compose "https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.25.5/docker-compose-linux-${COMPOSE_ARCH}" --timeout=30; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载兼容版本成功"
      fi
    fi
    
    # 源2: 腾讯云镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      if command -v curl &> /dev/null; then
        echo "尝试从腾讯云镜像下载兼容版本..."
        if sudo curl -L "https://mirrors.cloud.tencent.com/docker-toolbox/linux/compose/1.25.5/docker-compose-linux-${COMPOSE_ARCH}" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载兼容版本成功"
        fi
      elif command -v wget &> /dev/null; then
        echo "尝试从腾讯云镜像下载兼容版本..."
        if sudo wget -O /usr/local/bin/docker-compose "https://mirrors.cloud.tencent.com/docker-toolbox/linux/compose/1.25.5/docker-compose-linux-${COMPOSE_ARCH}" --timeout=30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载兼容版本成功"
        fi
      fi
    fi
    
    # 源3: 华为云镜像
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      if command -v curl &> /dev/null; then
        echo "尝试从华为云镜像下载兼容版本..."
        if curl -L "https://mirrors.huaweicloud.com/docker-toolbox/linux/compose/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从华为云镜像下载兼容版本成功"
        fi
      elif command -v wget &> /dev/null; then
        echo "尝试从华为云镜像下载兼容版本..."
        if sudo wget -O /usr/local/bin/docker-compose "https://mirrors.huaweicloud.com/docker-toolbox/linux/compose/1.25.5/docker-compose-$(uname -s)-$(uname -m)" --timeout=30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从华为云镜像下载兼容版本成功"
        fi
      fi
    fi
    
    # 源4: 最后尝试 GitHub
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      if command -v curl &> /dev/null; then
        echo "尝试从 GitHub 下载兼容版本..."
        if sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从 GitHub 下载兼容版本成功"
        fi
      elif command -v wget &> /dev/null; then
        echo "尝试从 GitHub 下载兼容版本..."
        if sudo wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" --timeout=30; then
          DOCKER_COMPOSE_DOWNLOADED=true
          echo "✅ 从 GitHub 下载兼容版本成功"
        fi
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
      echo "❌ GitHub 下载失败，尝试包管理器安装..."
      if sudo apt-get install -y --allow-unauthenticated docker-compose; then
        DOCKER_COMPOSE_DOWNLOADED=true
        echo "✅ 通过包管理器安装 docker-compose 成功"
      else
        echo "❌ 包管理器安装也失败了"
      fi
    fi
    
    if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "true" ]]; then
      sudo chmod +x /usr/local/bin/docker-compose
      sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
      echo "✅ Docker Compose 兼容版本安装完成"
    else
      echo "❌ Docker Compose 安装失败"
    fi
    
  else
    # 现代版本的 Ubuntu/Debian/Kali 使用标准安装方法
    sudo apt-get update
    
    # 安装必要的依赖包，添加错误处理和容错机制
    echo "正在安装必要的依赖包..."
    if sudo apt-get install -y --fix-missing ca-certificates curl gnupg lsb-release; then
      echo "✅ 必要依赖包安装成功"
    else
      echo "⚠️  批量安装失败，尝试逐个安装..."
      
      # 逐个安装依赖包
      if sudo apt-get install -y --fix-missing ca-certificates; then
        echo "✅ ca-certificates 安装成功"
      else
        echo "⚠️  ca-certificates 安装失败，将尝试继续..."
      fi
      
      if sudo apt-get install -y --fix-missing curl; then
        echo "✅ curl 安装成功"
      else
        echo "⚠️  curl 安装失败，将尝试继续..."
      fi
      
      if sudo apt-get install -y --fix-missing gnupg; then
        echo "✅ gnupg 安装成功"
      else
        echo "⚠️  gnupg 安装失败，将尝试继续..."
      fi
      
      if sudo apt-get install -y --fix-missing lsb-release; then
        echo "✅ lsb-release 安装成功"
      else
        echo "⚠️  lsb-release 安装失败，将尝试继续..."
      fi
      
      # 检查关键工具是否安装成功
      if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        echo "⚠️  curl 和 wget 都未安装，某些功能可能受限..."
      fi
      
      if ! command -v gpg &> /dev/null; then
        echo "⚠️  gpg 未安装，某些功能可能受限..."
      fi
      
      if ! command -v lsb_release &> /dev/null; then
        echo "⚠️  lsb-release 未安装，将使用备用方法检测系统版本..."
        # 如果 lsb-release 未安装，使用 /etc/os-release 作为备用
        if [[ -f /etc/os-release ]]; then
          DEBIAN_CODENAME_BACKUP=$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release | tr -d '"' 2>/dev/null || echo "")
        fi
      fi
    fi

    # Kali Linux 需要使用 Debian 仓库
    DOCKER_OS="$OS"
    # 如果 lsb-release 安装成功，使用它；否则使用备用方法
    if command -v lsb_release &> /dev/null; then
      DEBIAN_CODENAME=$(lsb_release -cs)
    elif [[ -n "$DEBIAN_CODENAME_BACKUP" ]]; then
      DEBIAN_CODENAME="$DEBIAN_CODENAME_BACKUP"
      echo "⚠️  使用备用方法检测到系统代号: $DEBIAN_CODENAME"
    else
      # 最后的备用方法
      DEBIAN_CODENAME=$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release | tr -d '"' 2>/dev/null || echo "bookworm")
      echo "⚠️  使用 /etc/os-release 检测到系统代号: $DEBIAN_CODENAME"
    fi
    
    # 检测 Debian Testing/Unstable 并映射到稳定版本
    if [[ "$OS" == "debian" ]]; then
      # 检查是否为 Debian Testing/Unstable（代号可能是 forky、trixie、sid 等）
      VERSION_CODENAME=$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release | tr -d '"' 2>/dev/null || echo "")
      
      # Debian Testing 的常见代号：forky（当前）、trixie（未来）
      # Debian Unstable 的代号：sid（固定）
      # Docker 官方仓库不支持 Testing/Unstable 版本，需要映射到对应的稳定版本
      if [[ "$DEBIAN_CODENAME" == "forky" ]] || [[ "$VERSION_CODENAME" == "forky" ]] || \
         [[ "$DEBIAN_CODENAME" == "trixie" ]] || [[ "$VERSION_CODENAME" == "trixie" ]] || \
         [[ "$DEBIAN_CODENAME" == "sid" ]] || [[ "$VERSION_CODENAME" == "sid" ]] || \
         [[ -n "$VERSION_CODENAME" && ("$VERSION_CODENAME" == "testing" || "$VERSION_CODENAME" == "unstable") ]]; then
        echo "⚠️  检测到 Debian Testing/Unstable (codename: $DEBIAN_CODENAME)"
        echo "⚠️  Docker 官方仓库不支持 Testing/Unstable 版本，将使用 Debian 12 (bookworm) 仓库"
        DEBIAN_CODENAME="bookworm"
      fi
    fi
    
    if [[ "$OS" == "kali" ]]; then
      DOCKER_OS="debian"
      # Kali Rolling 基于 Debian Testing，使用 bookworm 作为稳定版本
      # 根据 Kali 版本映射到对应的 Debian 代号
      case "$DEBIAN_CODENAME" in
        kali-rolling|kali-dev)
          DEBIAN_CODENAME="bookworm"
          ;;
        *)
          # 其他情况默认使用 bookworm
          DEBIAN_CODENAME="bookworm"
          ;;
      esac
      echo "⚠️  Kali Linux 将使用 Debian Docker 仓库 (codename: $DEBIAN_CODENAME)"
    fi

    if [[ "$OS" == "deepin" ]]; then
      DOCKER_OS="debian"
      DEEPIN_ORIG_CODENAME="$DEBIAN_CODENAME"
      # Docker 无 linux/deepin；Deepin 自有代号（如 crimson、beige）需映射到 Debian stable suite
      case "$DEBIAN_CODENAME" in
        crimson|beige|nymph|martian)
          DEBIAN_CODENAME="bookworm"
          ;;
        apricot|eagle)
          DEBIAN_CODENAME="bullseye"
          ;;
        *)
          if [[ -n "$DEBIAN_CODENAME" ]]; then
            echo "⚠️  Deepin 代号 $DEBIAN_CODENAME 未在映射表，默认使用 bookworm Docker 源（若失败请反馈）"
          fi
          DEBIAN_CODENAME="bookworm"
          ;;
      esac
      echo "ℹ️  Deepin $VERSION_ID（${DEEPIN_ORIG_CODENAME:-unknown}）→ Docker 使用 debian/$DEBIAN_CODENAME"
    fi
    
    # 检测 Ubuntu 版本并处理
    if [[ "$OS" == "ubuntu" ]]; then
      VERSION_CODENAME=$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release | tr -d '"' 2>/dev/null || echo "")
      ORIGINAL_CODENAME="$DEBIAN_CODENAME"
      
      # Ubuntu LTS 版本（Docker 官方支持）：bionic (18.04), focal (20.04), jammy (22.04), noble (24.04)
      # Ubuntu 非 LTS 版本：plucky (25.04) 等，Docker 官方可能支持也可能不支持
      case "$DEBIAN_CODENAME" in
        bionic|focal|jammy|noble)
          # 这些是支持的 LTS 版本，保持原样
          ;;
        plucky)
          # Ubuntu 25.04 (Plucky Puffin) - 2025年4月发布的非LTS版本
          # Docker 官方可能尚未完全支持，先尝试使用 plucky，失败后会自动回退到 noble
          echo "ℹ️  检测到 Ubuntu 25.04 (Plucky Puffin)"
          echo "ℹ️  将首先尝试使用 Ubuntu 25.04 仓库，如果失败将回退到 Ubuntu 24.04 LTS (noble)"
          # 先保持 plucky，让脚本尝试，失败时会自动回退
          ;;
        warty|hoary|breezy|dapper|edgy|feisty|gutsy|hardy|intrepid|jaunty|karmic|lucid|maverick|natty|oneiric|precise|quantal|raring|saucy|trusty|utopic|vivid|wily|xenial|yakkety|zesty|artful|cosmic|disco|eoan|groovy|hirsute|impish|kinetic|lunar|mantic)
          # 这些都是很旧的版本或过期的版本，直接映射到最新的 LTS 版本 noble (24.04)
          echo "⚠️  检测到 Ubuntu 旧版本 (codename: $DEBIAN_CODENAME)"
          echo "⚠️  Docker 官方仓库不支持此版本，将使用 Ubuntu 24.04 LTS (noble) 仓库"
          DEBIAN_CODENAME="noble"
          ;;
        "")
          # 无法检测到版本代号，使用最新的 LTS
          echo "⚠️  无法检测 Ubuntu 版本代号，将使用 Ubuntu 24.04 LTS (noble)"
          DEBIAN_CODENAME="noble"
          ;;
        *)
          # 未知的新版本，先尝试使用自身，失败后会回退
          echo "ℹ️  检测到 Ubuntu 新版本 (codename: $DEBIAN_CODENAME)"
          echo "ℹ️  将首先尝试使用此版本的仓库，如果失败将回退到 Ubuntu 24.04 LTS (noble)"
          ;;
      esac
    fi

    sudo install -m 0755 -d /etc/apt/keyrings
    
    # 清理可能存在的旧配置
    sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
    
    # GPG 密钥下载和验证辅助函数
    download_and_verify_gpg_key() {
      local gpg_url=$1
      local key_file="/etc/apt/keyrings/docker.gpg"
      local error_output="/tmp/docker_gpg_error.log"
      
      # 下载并处理 GPG 密钥
      if curl -fsSL "$gpg_url" 2>"$error_output" | sudo gpg --dearmor -o "$key_file" 2>"$error_output"; then
        # 验证密钥文件是否存在且大小合理（应该大于 1000 字节）
        if [[ -f "$key_file" ]] && [[ $(stat -f%z "$key_file" 2>/dev/null || stat -c%s "$key_file" 2>/dev/null || echo 0) -gt 1000 ]]; then
          # 设置正确的权限
          sudo chmod 644 "$key_file" 2>/dev/null || true
          rm -f "$error_output" 2>/dev/null
          return 0
        else
          echo "⚠️  GPG 密钥文件大小异常或不存在"
          rm -f "$key_file" "$error_output" 2>/dev/null
          return 1
        fi
      else
        if [[ -f "$error_output" ]]; then
          echo "⚠️  GPG 密钥下载/处理失败: $(cat "$error_output" 2>/dev/null | head -1)"
          rm -f "$error_output" 2>/dev/null
        fi
        rm -f "$key_file" 2>/dev/null
        return 1
      fi
    }
    
    # 尝试多个国内镜像源配置 Docker 仓库
    echo "正在配置 Docker 源..."
    DOCKER_REPO_ADDED=false
    
    # 源1: 阿里云镜像
    echo "尝试配置阿里云 Docker 源..."
    sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
    if download_and_verify_gpg_key "https://mirrors.aliyun.com/docker-ce/linux/$DOCKER_OS/gpg"; then
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.aliyun.com/docker-ce/linux/$DOCKER_OS \
        $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
      # 捕获 apt-get update 的详细错误信息
      update_output="/tmp/docker_apt_update.log"
      if sudo apt-get update >"$update_output" 2>&1; then
        DOCKER_REPO_ADDED=true
        echo "✅ 阿里云 Docker 源配置成功"
        rm -f "$update_output" 2>/dev/null
      else
        echo "❌ 阿里云 Docker 源配置失败"
        if [[ -f "$update_output" ]]; then
          # 显示关键错误信息
          if grep -q "NO_PUBKEY\|GPG error\|NO_PUBKEY" "$update_output" 2>/dev/null; then
            echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
          fi
          rm -f "$update_output" 2>/dev/null
        fi
        echo "   尝试下一个源..."
      fi
    else
      echo "❌ 阿里云 Docker GPG 密钥下载失败，尝试下一个源..."
    fi
    
    # 源2: 腾讯云镜像（使用正确的域名）
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "尝试配置腾讯云 Docker 源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://mirrors.cloud.tencent.com/docker-ce/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.cloud.tencent.com/docker-ce/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 腾讯云 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 腾讯云 Docker 源配置失败"
          if [[ -f "$update_output" ]]; then
            if grep -q "NO_PUBKEY\|GPG error" "$update_output" 2>/dev/null; then
              echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
            fi
            rm -f "$update_output" 2>/dev/null
          fi
          echo "   尝试下一个源..."
        fi
      else
        echo "❌ 腾讯云 Docker GPG 密钥下载失败，尝试下一个源..."
      fi
    fi
    
    # 源3: 华为云镜像
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "尝试配置华为云 Docker 源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://mirrors.huaweicloud.com/docker-ce/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.huaweicloud.com/docker-ce/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 华为云 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 华为云 Docker 源配置失败"
          if [[ -f "$update_output" ]]; then
            if grep -q "NO_PUBKEY\|GPG error" "$update_output" 2>/dev/null; then
              echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
            fi
            rm -f "$update_output" 2>/dev/null
          fi
          echo "   尝试下一个源..."
        fi
      else
        echo "❌ 华为云 Docker GPG 密钥下载失败，尝试下一个源..."
      fi
    fi
    
    # 源4: 中科大镜像
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "尝试配置中科大 Docker 源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://mirrors.ustc.edu.cn/docker-ce/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.ustc.edu.cn/docker-ce/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 中科大 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 中科大 Docker 源配置失败"
          if [[ -f "$update_output" ]]; then
            if grep -q "NO_PUBKEY\|GPG error" "$update_output" 2>/dev/null; then
              echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
              # 如果是 NO_PUBKEY 错误，显示缺失的密钥 ID
              if grep -q "NO_PUBKEY" "$update_output" 2>/dev/null; then
                missing_key=$(grep -oP "NO_PUBKEY \K[0-9A-F]{16}" "$update_output" | head -1)
                if [[ -n "$missing_key" ]]; then
                  echo "   缺失的 GPG 密钥 ID: $missing_key"
                  echo "   尝试手动添加密钥..."
                  # 尝试从 keyserver 获取密钥
                  if command -v gpg &>/dev/null && command -v apt-key &>/dev/null 2>/dev/null; then
                    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$missing_key" 2>/dev/null || \
                    sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys "$missing_key" 2>/dev/null || true
                  fi
                fi
              fi
            fi
            rm -f "$update_output" 2>/dev/null
          fi
          echo "   尝试下一个源..."
        fi
      else
        echo "❌ 中科大 Docker GPG 密钥下载失败，尝试下一个源..."
      fi
    fi
    
    # 源5: 清华大学镜像
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "尝试配置清华大学 Docker 源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 清华大学 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 清华大学 Docker 源配置失败"
          if [[ -f "$update_output" ]]; then
            if grep -q "NO_PUBKEY\|GPG error" "$update_output" 2>/dev/null; then
              echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
            fi
            rm -f "$update_output" 2>/dev/null
          fi
          echo "   尝试下一个源..."
        fi
      else
        echo "❌ 清华大学 Docker GPG 密钥下载失败，尝试下一个源..."
      fi
    fi
    
    # 源6: 网易镜像
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "尝试配置网易 Docker 源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://mirrors.163.com/docker-ce/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.163.com/docker-ce/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 网易 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 网易 Docker 源配置失败"
          if [[ -f "$update_output" ]]; then
            if grep -q "NO_PUBKEY\|GPG error" "$update_output" 2>/dev/null; then
              echo "   错误详情: $(grep -i "NO_PUBKEY\|GPG error" "$update_output" | head -1)"
            fi
            rm -f "$update_output" 2>/dev/null
          fi
          echo "   尝试下一个源..."
        fi
      else
        echo "❌ 网易 Docker GPG 密钥下载失败，尝试下一个源..."
      fi
    fi
    
    # 如果所有国内源都失败，尝试官方源
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "所有国内源都失败，尝试官方源..."
      sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
      if download_and_verify_gpg_key "https://download.docker.com/linux/$DOCKER_OS/gpg"; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DOCKER_OS \
          $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        update_output="/tmp/docker_apt_update.log"
        if sudo apt-get update >"$update_output" 2>&1; then
          DOCKER_REPO_ADDED=true
          echo "✅ 官方 Docker 源配置成功"
          rm -f "$update_output" 2>/dev/null
        else
          echo "❌ 官方 Docker 源也配置失败"
          if [[ -f "$update_output" ]]; then
            echo "   最后尝试的错误信息:"
            grep -i "NO_PUBKEY\|GPG error\|404\|Not Found" "$update_output" 2>/dev/null | head -3
            rm -f "$update_output" 2>/dev/null
          fi
        fi
      else
        echo "❌ 官方 Docker GPG 密钥下载失败"
      fi
    fi
    
    # 如果所有源都失败，且使用的是 Ubuntu 新版本（如 plucky），尝试回退到 LTS 版本
    if [[ "$DOCKER_REPO_ADDED" == "false" ]] && [[ "$OS" == "ubuntu" ]]; then
      # 检查原始版本代号，判断是否需要回退
      if [[ "$ORIGINAL_CODENAME" == "plucky" ]] || [[ "$DEBIAN_CODENAME" == "plucky" ]]; then
        # Ubuntu 25.04 (Plucky Puffin) 配置失败，回退到 Ubuntu 24.04 LTS (noble)
        echo "⚠️  Ubuntu 25.04 (Plucky Puffin) 源配置失败，回退到 Ubuntu 24.04 LTS (noble)..."
        DEBIAN_CODENAME="noble"
        sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
        
        # 再次尝试官方源（最可靠）
        if download_and_verify_gpg_key "https://download.docker.com/linux/$DOCKER_OS/gpg"; then
          echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DOCKER_OS \
            $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          
          update_output="/tmp/docker_apt_update.log"
          if sudo apt-get update >"$update_output" 2>&1; then
            DOCKER_REPO_ADDED=true
            echo "✅ 使用 Ubuntu 24.04 LTS (noble) 源配置成功"
            rm -f "$update_output" 2>/dev/null
          else
            rm -f "$update_output" 2>/dev/null
          fi
        fi
      elif [[ "$DEBIAN_CODENAME" == "noble" ]] && [[ "$ORIGINAL_CODENAME" != "noble" ]]; then
        # 如果已经是 noble 但原始不是 noble，说明已经回退过了，再回退到 jammy
        echo "⚠️  Ubuntu 24.04 LTS (noble) 源配置失败，尝试回退到 Ubuntu 22.04 LTS (jammy)..."
        DEBIAN_CODENAME="jammy"
        sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
        
        # 再次尝试官方源（最可靠）
        if download_and_verify_gpg_key "https://download.docker.com/linux/$DOCKER_OS/gpg"; then
          echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DOCKER_OS \
            $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          
          update_output="/tmp/docker_apt_update.log"
          if sudo apt-get update >"$update_output" 2>&1; then
            DOCKER_REPO_ADDED=true
            echo "✅ 使用 Ubuntu 22.04 LTS (jammy) 源配置成功"
            rm -f "$update_output" 2>/dev/null
          else
            rm -f "$update_output" 2>/dev/null
          fi
        fi
      elif [[ -n "$ORIGINAL_CODENAME" ]] && [[ "$DEBIAN_CODENAME" != "$ORIGINAL_CODENAME" ]]; then
        # 其他新版本，尝试回退到 noble
        echo "⚠️  Ubuntu $ORIGINAL_CODENAME 源配置失败，尝试回退到 Ubuntu 24.04 LTS (noble)..."
        DEBIAN_CODENAME="noble"
        sudo rm -f /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list 2>/dev/null
        
        if download_and_verify_gpg_key "https://download.docker.com/linux/$DOCKER_OS/gpg"; then
          echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DOCKER_OS \
            $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          
          update_output="/tmp/docker_apt_update.log"
          if sudo apt-get update >"$update_output" 2>&1; then
            DOCKER_REPO_ADDED=true
            echo "✅ 使用 Ubuntu 24.04 LTS (noble) 源配置成功"
            rm -f "$update_output" 2>/dev/null
          else
            rm -f "$update_output" 2>/dev/null
          fi
        fi
      fi
    fi
    
    if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
      echo "❌ 所有 Docker 源都配置失败，无法继续安装"
      echo ""
      echo "可能的原因："
      echo "  1. 网络连接问题"
      echo "  2. Ubuntu 版本太新，Docker 官方仓库暂不支持"
      echo "  3. GPG 密钥验证失败"
      echo ""
      echo "建议解决方案："
      echo "  1. 检查网络连接"
      echo "  2. 手动添加 Docker GPG 密钥："
      echo "     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
      echo "  3. 手动配置 Docker 源："
      echo "     echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list"
      echo "  4. 更新软件包列表："
      echo "     sudo apt-get update"
      exit 1
    fi

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
    
  # 源6: 网易镜像
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "尝试从网易镜像下载..."
    if sudo curl -L "https://mirrors.163.com/docker-toolbox/linux/compose/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 10 --max-time 30; then
      DOCKER_COMPOSE_DOWNLOADED=true
      echo "✅ 从网易镜像下载成功"
    else
      echo "❌ 网易镜像下载失败，尝试下一个源..."
    fi
  fi
  
  # 源7: 最后尝试 GitHub (如果网络允许)
    # 源7: 最后尝试 GitHub (如果网络允许)
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
      if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$OS" == "deepin" ]]; then
        if sudo apt-get install -y docker-compose-plugin; then
          echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
          DOCKER_COMPOSE_DOWNLOADED=true
        else
          echo "❌ 包管理器安装也失败了"
        fi
      elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "rocky" || "$OS" == "ol" || "$OS" == "kylin" || "$OS" == "uos" || "$OS" == "uniontechos" ]]; then
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
  
  # 尝试多个国内镜像源
  echo "正在配置 Docker 源..."
  DOCKER_REPO_ADDED=false
  
  # 创建Docker仓库配置文件，直接使用国内镜像地址
  echo "正在创建 Docker 仓库配置..."
  
  # 根据系统版本选择正确的仓库路径
  # 使用数值比较以支持版本10及以上
  VERSION_MAJOR="${VERSION_ID%%.*}"
  if [[ "$VERSION_MAJOR" -ge 10 ]]; then
    # CentOS Stream 10+ 使用 CentOS 9 仓库（兼容处理）
    CENTOS_VERSION="9"
    echo "检测到 CentOS/RHEL/Rocky Linux ${VERSION_ID}，使用 CentOS 9 仓库（兼容模式）"
  elif [[ "$VERSION_MAJOR" == "9" ]]; then
    CENTOS_VERSION="9"
    echo "检测到 CentOS/RHEL/Rocky Linux 9，使用 CentOS 9 仓库"
  elif [[ "$VERSION_MAJOR" == "8" ]]; then
    CENTOS_VERSION="8"
    echo "检测到 CentOS/RHEL/Rocky Linux 8，使用 CentOS 8 仓库"
  else
    CENTOS_VERSION="7"
    echo "检测到 CentOS/RHEL/Rocky Linux 7，使用 CentOS 7 仓库"
  fi
  
  # 源1: 阿里云镜像
  echo "尝试配置阿里云 Docker 源..."
  sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
  
  if sudo yum makecache; then
    DOCKER_REPO_ADDED=true
    echo "✅ 阿里云 Docker 源配置成功"
  else
    echo "❌ 阿里云 Docker 源配置失败，尝试下一个源..."
  fi
  
  # 源2: 腾讯云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置腾讯云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 腾讯云 Docker 源配置成功"
    else
      echo "❌ 腾讯云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源3: 华为云镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置华为云 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.huaweicloud.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 华为云 Docker 源配置成功"
    else
      echo "❌ 华为云 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源4: 中科大镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置中科大 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.ustc.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 中科大 Docker 源配置成功"
    else
      echo "❌ 中科大 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源5: 清华大学镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置清华大学 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 清华大学 Docker 源配置成功"
    else
      echo "❌ 清华大学 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 源6: 网易镜像
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "尝试配置网易 Docker 源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.163.com/docker-ce/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.163.com/docker-ce/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 网易 Docker 源配置成功"
    else
      echo "❌ 网易 Docker 源配置失败，尝试下一个源..."
    fi
  fi
  
  # 如果所有国内源都失败，尝试官方源
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "所有国内源都失败，尝试官方源..."
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/centos/${CENTOS_VERSION}/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
EOF
    
    if sudo yum makecache; then
      DOCKER_REPO_ADDED=true
      echo "✅ 官方 Docker 源配置成功"
    else
      echo "❌ 官方 Docker 源也配置失败"
    fi
  fi
  
  if [[ "$DOCKER_REPO_ADDED" == "false" ]]; then
    echo "❌ 所有 Docker 源都配置失败，无法继续安装"
    echo "请检查网络连接或手动配置 Docker 源"
    exit 1
  fi

  echo ">>> [3/8] 安装 Docker CE 最新版..."
  
  # 临时禁用 set -e，允许错误处理
  set +e
  
  echo "正在尝试安装 Docker CE（这可能需要几分钟，请耐心等待）..."
  echo "如果安装过程卡住，可能是网络问题或依赖解析中，请等待..."
  
  # 尝试安装 Docker，使用超时机制（30分钟超时）
  INSTALL_OUTPUT=""
  INSTALL_STATUS=1
  
  # 使用 timeout 命令（如果可用）或直接执行
  # 注意：使用 bash -c 确保 sudo 函数在子 shell 中可用
  if command -v timeout &> /dev/null; then
    INSTALL_OUTPUT=$(timeout 1800 bash -c "sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin --nobest" 2>&1)
    INSTALL_STATUS=$?
    if [[ $INSTALL_STATUS -eq 124 ]]; then
      echo "❌ 安装超时（30分钟），可能是网络问题或依赖解析失败"
      INSTALL_STATUS=1
    fi
  else
    INSTALL_OUTPUT=$(sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin --nobest 2>&1)
    INSTALL_STATUS=$?
  fi
  
  # 重新启用 set -e
  set -e
  
  if [[ $INSTALL_STATUS -eq 0 ]]; then
    echo "✅ Docker CE 安装成功"
  else
    # 显示详细错误信息
    echo ""
    echo "❌ Docker CE 批量安装失败"
    echo "错误详情："
    echo "$INSTALL_OUTPUT" | tail -20
    echo ""
    
    # 检查错误类型
    if echo "$INSTALL_OUTPUT" | grep -qiE "(timeout|timed out|connection|网络|network)"; then
      echo "⚠️  检测到可能的网络问题，请检查网络连接"
    fi
    if echo "$INSTALL_OUTPUT" | grep -qiE "(repo|repository|仓库|not found|找不到)"; then
      echo "⚠️  检测到可能的仓库配置问题，请检查 Docker 源配置"
    fi
    
    echo "正在尝试逐个安装组件..."
    
    # 临时禁用 set -e
    set +e
    
    # 逐个安装组件
    echo "  - 正在安装 containerd.io..."
    CONTAINERD_OUTPUT=$(sudo yum install -y containerd.io --nobest 2>&1)
    CONTAINERD_STATUS=$?
    if [[ $CONTAINERD_STATUS -eq 0 ]]; then
      echo "  ✅ containerd.io 安装成功"
    else
      echo "  ❌ containerd.io 安装失败"
      echo "  错误信息: $(echo "$CONTAINERD_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce-cli..."
    DOCKER_CLI_OUTPUT=$(sudo yum install -y docker-ce-cli --nobest 2>&1)
    DOCKER_CLI_STATUS=$?
    if [[ $DOCKER_CLI_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce-cli 安装成功"
    else
      echo "  ❌ docker-ce-cli 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CLI_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-ce..."
    DOCKER_CE_OUTPUT=$(sudo yum install -y docker-ce --nobest 2>&1)
    DOCKER_CE_STATUS=$?
    if [[ $DOCKER_CE_STATUS -eq 0 ]]; then
      echo "  ✅ docker-ce 安装成功"
    else
      echo "  ❌ docker-ce 安装失败"
      echo "  错误信息: $(echo "$DOCKER_CE_OUTPUT" | tail -5)"
    fi
    
    echo "  - 正在安装 docker-buildx-plugin..."
    BUILDX_OUTPUT=$(sudo yum install -y docker-buildx-plugin --nobest 2>&1)
    BUILDX_STATUS=$?
    if [[ $BUILDX_STATUS -eq 0 ]]; then
      echo "  ✅ docker-buildx-plugin 安装成功"
    else
      echo "  ⚠️  docker-buildx-plugin 安装失败（可选组件，不影响核心功能）"
    fi
    
    # 重新启用 set -e
    set -e
    
    # 检查是否至少安装了核心组件
    if ! command -v docker &> /dev/null; then
      echo "❌ 包管理器安装完全失败，尝试二进制安装..."
      
      # 二进制安装备选方案
      echo "正在下载 Docker 二进制包..."
      
      # 尝试多个下载源
      DOCKER_BINARY_DOWNLOADED=false
      
      # 源1: 阿里云镜像
      echo "尝试从阿里云镜像下载 Docker 二进制包..."
      if curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
        DOCKER_BINARY_DOWNLOADED=true
        echo "✅ 从阿里云镜像下载成功"
      else
        echo "❌ 阿里云镜像下载失败，尝试下一个源..."
      fi
      
      # 源2: 腾讯云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从腾讯云镜像下载..."
        if curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从腾讯云镜像下载成功"
        else
          echo "❌ 腾讯云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源3: 华为云镜像
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从华为云镜像下载..."
        if curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从华为云镜像下载成功"
        else
          echo "❌ 华为云镜像下载失败，尝试下一个源..."
        fi
      fi
      
      # 源4: 官方源
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "false" ]]; then
        echo "尝试从官方源下载..."
        if curl -fsSL https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-20.10.24.tgz -o /tmp/docker.tgz --connect-timeout 10 --max-time 60; then
          DOCKER_BINARY_DOWNLOADED=true
          echo "✅ 从官方源下载成功"
        else
          echo "❌ 官方源下载失败"
        fi
      fi
      
      if [[ "$DOCKER_BINARY_DOWNLOADED" == "true" ]]; then
        echo "正在解压并安装 Docker 二进制包..."
        sudo tar -xzf /tmp/docker.tgz -C /usr/bin --strip-components=1
        sudo chmod +x /usr/bin/docker*
        
        # 创建 systemd 服务文件
        sudo tee /etc/systemd/system/docker.service > /dev/null <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service time-set.target
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

        # 创建 docker.socket 文件
        sudo tee /etc/systemd/system/docker.socket > /dev/null <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

        # 创建 docker 用户组
        sudo groupadd docker 2>/dev/null || true
        
        echo "✅ Docker 二进制安装成功"
      else
        echo "❌ 所有下载源都失败，无法安装 Docker"
        echo "请检查网络连接或手动安装 Docker"
        exit 1
      fi
    fi
  fi
  
  sudo systemctl enable docker
  sudo systemctl start docker
  
  echo ">>> [3.5/8] 安装 Docker Compose..."
  # 安装最新版本的 docker-compose，直接使用 GitHub 官方源
  echo "正在下载 Docker Compose..."
  
  # 直接使用 GitHub 官方源（最可靠）
  echo "正在从 GitHub 官方源下载 Docker Compose..."
  if sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose --connect-timeout 30 --max-time 120; then
    DOCKER_COMPOSE_DOWNLOADED=true
    echo "✅ 从 GitHub 官方源下载成功"
  else
    echo "❌ GitHub 官方源下载失败"
    echo "💡 建议检查网络连接或使用代理"
  fi
  
  # 检查是否下载成功
  if [[ "$DOCKER_COMPOSE_DOWNLOADED" == "false" ]]; then
    echo "❌ 所有下载源都失败了，尝试使用包管理器安装..."
    
    # 使用包管理器作为备选方案
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$OS" == "deepin" ]]; then
      if sudo apt-get install -y docker-compose-plugin; then
        echo "✅ 通过包管理器安装 docker-compose-plugin 成功"
        DOCKER_COMPOSE_DOWNLOADED=true
      else
        echo "❌ 包管理器安装也失败了"
      fi
    elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "rocky" || "$OS" == "ol" || "$OS" == "kylin" || "$OS" == "uos" || "$OS" == "uniontechos" ]]; then
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
  echo "❌ 暂不支持该系统: $OS"
  echo "💡 若需适配本系统，请到轩辕镜像官网提交工单寻求支持："
  echo "   https://xuanyuan.cloud/tickets"
  exit 1
fi

echo ">>> [5/8] 配置国内镜像..."

# 循环等待用户选择镜像版本
while true; do
    echo "请选择版本:"
    echo "1) 轩辕镜像免费版 (域名: docker.xuanyuan.me)"
    echo "2) 轩辕镜像专业版 (专属域名 *.xuanyuan.run / *.xuanyuan.dev 不含免费版域名)"
    echo "3) 恢复/重置镜像相关配置"
    read -p "请输入选择 [1/2/3]: " choice
    
    if [[ "$choice" == "1" || "$choice" == "2" ]]; then
        break
    elif [[ "$choice" == "3" ]]; then
        restore_docker_daemon_config
        exit $?
    else
        echo "❌ 无效选择，请输入 1、2 或 3"
        echo ""
    fi
done

mirror_list=""

if [[ "$choice" == "2" ]]; then
  read -p "请输入您的轩辕镜像专属域名 (访问官网获取：https://xuanyuan.cloud): " custom_domain

  # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
  if [[ "$custom_domain" == *.xuanyuan.run ]]; then
    custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
    mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_dev"
]
EOF
)
  elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
    custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
    mirror_list=$(cat <<EOF
[
  "https://$custom_domain",
  "https://$custom_domain_run"
]
EOF
)
  else
    mirror_list=$(cat <<EOF
[
  "https://$custom_domain"
]
EOF
)
  fi
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
  # 清理用户输入的域名，移除协议前缀
  custom_domain=$(echo "$custom_domain" | sed 's|^https\?://||')
  
  # 专业版：*.xuanyuan.run / *.xuanyuan.dev 成对配置（不含 docker.xuanyuan.me）
  if [[ "$custom_domain" == *.xuanyuan.run ]]; then
    custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
    insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_dev"
]
EOF
)
  elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
    custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
    insecure_registries=$(cat <<EOF
[
  "$custom_domain",
  "$custom_domain_run"
]
EOF
)
  else
    insecure_registries=$(cat <<EOF
[
  "$custom_domain"
]
EOF
)
  fi
else
  # 免费版：仅配置 docker.xuanyuan.me
  insecure_registries=$(cat <<EOF
[
  "docker.xuanyuan.me"
]
EOF
)
fi

# 准备 DNS 配置字符串
dns_config=""
if [[ "$SKIP_DNS" != "true" ]]; then
  if ! grep -q "nameserver" /etc/resolv.conf; then
     dns_config=',
  "dns": ["119.29.29.29", "114.114.114.114"]'
  else
     echo "ℹ️  检测到系统已配置 DNS，跳过 Docker DNS 配置以避免冲突"
  fi
fi

cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
  "registry-mirrors": $mirror_list,
  "insecure-registries": $insecure_registries$dns_config
}
EOF

# 避免在容器/无 systemd 环境反复调用 systemctl 导致 “PID 1 / bus” 报错
SCRIPT_SYSTEMD_OK=false
if command -v systemctl &>/dev/null; then
  PID1_COMM_SCRIPT=$(tr -d '\0' < /proc/1/comm 2>/dev/null || echo "")
  if [[ "$PID1_COMM_SCRIPT" == "systemd" ]] && systemctl show-environment &>/dev/null 2>&1; then
    SCRIPT_SYSTEMD_OK=true
  fi
fi

if [[ "$SCRIPT_SYSTEMD_OK" == "true" ]]; then
  sudo systemctl daemon-reexec || true
  sudo systemctl restart docker || true
else
  echo "ℹ️  未检测到可用 systemd，跳过 systemctl 重载 Docker（容器或无 dbus 环境常见）"
fi

echo ">>> [6/8] 安装完成！"
echo "🎉Docker 镜像已配置完成"
echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
echo "官方网站: https://xuanyuan.cloud/"

echo ">>> [7/8] 重载 Docker 配置并重启服务..."
if [[ "$SCRIPT_SYSTEMD_OK" == "true" ]]; then
  sudo systemctl daemon-reexec || true
  sudo systemctl restart docker || true
else
  echo "ℹ️  无 systemd 时请在完整系统执行: sudo systemctl restart docker，或手动: sudo dockerd &"
fi

# 等待 Docker 服务完全启动
echo "等待 Docker 服务启动..."
sleep 3

# 验证 Docker：优先 docker info（无 systemd 时 systemctl 不可用）
DOCKER_VERIFIED=false
if docker info &>/dev/null; then
  DOCKER_VERIFIED=true
elif [[ "$SCRIPT_SYSTEMD_OK" == "true" ]] && systemctl is-active --quiet docker 2>/dev/null; then
  DOCKER_VERIFIED=true
fi

if [[ "$DOCKER_VERIFIED" == "true" ]]; then
    echo "✅ Docker 服务已成功启动"
    echo "✅ 镜像配置已生效"
    
    # 显示当前配置的镜像源
    echo "当前配置的镜像源:"
    if [[ "$choice" == "2" ]]; then
        if [[ "$custom_domain" == *.xuanyuan.run ]]; then
            custom_domain_dev="${custom_domain%.xuanyuan.run}.xuanyuan.dev"
            echo "  - https://$custom_domain (优先)"
            echo "  - https://$custom_domain_dev (备用)"
        elif [[ "$custom_domain" == *.xuanyuan.dev ]]; then
            custom_domain_run="${custom_domain%.xuanyuan.dev}.xuanyuan.run"
            echo "  - https://$custom_domain (优先)"
            echo "  - https://$custom_domain_run (备用)"
        else
            echo "  - https://$custom_domain"
        fi
    else
        echo "  - https://docker.xuanyuan.me"
    fi
    
    echo ""
    echo "🎉 安装和配置完成！"
    echo ""
    
    # 将执行脚本的用户添加到 docker 组
    echo ">>> [8/8] 配置用户权限..."
    
    # 定义函数：安全地添加用户到 docker 组
    add_user_to_docker_group() {
        local target_user="$1"
        if ! groups "$target_user" | grep -q "\bdocker\b"; then
            echo "⚠️  注意：将用户 $target_user 加入 docker 组意味着赋予该用户 root 级权限。"
            echo "⚠️  这可能会带来安全风险。如果您不确定，请选择 'n'。"
            read -p "是否继续将 $target_user 添加到 docker 组？[Y/n] " confirm_add_group
            confirm_add_group=${confirm_add_group:-Y}
            
            if [[ "$confirm_add_group" =~ ^[Yy]$ ]]; then
                sudo usermod -aG docker "$target_user" 2>/dev/null || true
                echo "✅ 已将用户 $target_user 添加到 docker 组"
                echo "⚠️  请重新登录或执行 'newgrp docker' 使权限生效"
            else
                echo "ℹ️  已跳过用户组配置"
            fi
        else
            echo "✅ 用户 $target_user 已在 docker 组中"
        fi
    }

    if [ -n "$SUDO_USER" ]; then
        # 如果通过 sudo 执行
        add_user_to_docker_group "$SUDO_USER"
    elif [ "$(id -u)" -ne 0 ]; then
        # 如果直接以非 root 用户执行
        add_user_to_docker_group "$USER"
    else
        # 如果已经是 root 用户，提示信息
        echo "ℹ️  当前以 root 用户执行，无需添加到 docker 组"
    fi
    
    echo ""
    echo "轩辕镜像 · 专业版 - 开发者首选的专业 Docker 镜像高效稳定拉取服务"
    echo "官方网站: https://xuanyuan.cloud/"
else
    echo "❌ 无法连接到 Docker daemon（可能未安装 docker-ce 或未启动）。/etc/docker/daemon.json 已写入。"
    echo "💡 统信等环境可先执行: sudo dnf remove -y docker-runc && sudo dnf install -y --allowerasing docker-ce"
    echo "💡 在物理机/虚拟机: sudo systemctl enable --now docker；无 systemd 环境可尝试: sudo dockerd &"
    exit 1
fi