#!/bin/bash
# termrec 安装脚本

set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

INSTALL_DIR="$HOME/bin"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  termrec 安装程序${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# 检查是否已安装
if [ -f "$INSTALL_DIR/termrec" ]; then
    echo -e "${YELLOW}检测到已安装 termrec${NC}"
    read -p "是否覆盖安装？(y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo -e "${YELLOW}已取消安装${NC}"
        exit 0
    fi
fi

# 创建安装目录
echo -e "${CYAN}[1/4] 创建安装目录...${NC}"
mkdir -p "$INSTALL_DIR"
echo -e "  ✓ $INSTALL_DIR"

# 复制文件
echo -e "${CYAN}[2/4] 安装文件...${NC}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/bin/termrec" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/bin/termrec-bash.sh" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/termrec"
echo -e "  ✓ termrec"
echo -e "  ✓ termrec-bash.sh"

# 检测 shell 类型
echo -e "${CYAN}[3/4] 配置 Shell...${NC}"
SHELL_CONFIG=""
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    bash)
        SHELL_CONFIG="$BASHRC"
        ;;
    zsh)
        SHELL_CONFIG="$ZSHRC"
        ;;
    *)
        SHELL_CONFIG="$PROFILE"
        ;;
esac

# 检查是否已配置
if grep -q "termrec-bash.sh" "$SHELL_CONFIG" 2>/dev/null; then
    echo -e "  ✓ 已配置 $SHELL_CONFIG"
else
    # 添加配置
    cat >> "$SHELL_CONFIG" << 'EOF'

# termrec - 终端命令记录工具
if [ -f ~/bin/termrec-bash.sh ]; then
    source ~/bin/termrec-bash.sh
fi
EOF
    echo -e "  ✓ 已添加配置到 $SHELL_CONFIG"
fi

# 完成
echo -e "${CYAN}[4/4] 安装完成!${NC}"
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  安装成功!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "使用方法:"
echo -e "  ${YELLOW}source $SHELL_CONFIG${NC}      # 重新加载配置"
echo -e "  ${YELLOW}termrec start [名称]${NC}  # 开始记录"
echo -e "  ${YELLOW}termrec stop${NC}          # 停止记录"
echo -e "  ${YELLOW}termrec list${NC}          # 查看记录"
echo -e "  ${YELLOW}termrec help${NC}          # 查看帮助"
echo ""
echo -e "文档: ${CYAN}$INSTALL_DIR/../docs/README.md${NC}"
echo ""
echo -e "或者重新打开终端即可使用。"
