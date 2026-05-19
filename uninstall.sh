#!/bin/bash
# termrec 卸载脚本

set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

INSTALL_DIR="$HOME/bin"
RECORD_DIR="$HOME/.termrec"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  termrec 卸载程序${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# 检查是否安装
if [ ! -f "$INSTALL_DIR/termrec" ]; then
    echo -e "${YELLOW}未检测到 termrec 安装${NC}"
    exit 0
fi

# 确认卸载
echo -e "${YELLOW}这将删除:${NC}"
echo -e "  - $INSTALL_DIR/termrec"
echo -e "  - $INSTALL_DIR/termrec-bash.sh"
echo ""
read -p "是否同时删除所有记录？(y/N): " delete_records
read -p "确定要卸载 termrec 吗？(y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${YELLOW}已取消卸载${NC}"
    exit 0
fi

# 删除文件
echo -e "${CYAN}[1/3] 删除程序文件...${NC}"
rm -f "$INSTALL_DIR/termrec"
rm -f "$INSTALL_DIR/termrec-bash.sh"
echo -e "  ✓ 已删除程序文件"

# 删除记录
if [ "$delete_records" = "y" ] || [ "$delete_records" = "Y" ]; then
    echo -e "${CYAN}[2/3] 删除记录文件...${NC}"
    rm -rf "$RECORD_DIR"
    echo -e "  ✓ 已删除 $RECORD_DIR"
else
    echo -e "${CYAN}[2/3] 保留记录文件${NC}"
    echo -e "  记录保存在: $RECORD_DIR"
fi

# 清理配置
echo -e "${CYAN}[3/3] 清理 Shell 配置...${NC}"
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    bash) CONFIG_FILE="$BASHRC" ;;
    zsh) CONFIG_FILE="$ZSHRC" ;;
    *) CONFIG_FILE="$PROFILE" ;;
esac

if [ -f "$CONFIG_FILE" ]; then
    # 删除 termrec 相关配置
    sed -i '/# termrec - 终端命令记录工具/d' "$CONFIG_FILE"
    sed -i '/if \[ -f ~\/bin\/termrec-bash.sh \]; then/d' "$CONFIG_FILE"
    sed -i '/    source ~\/bin\/termrec-bash.sh/d' "$CONFIG_FILE"
    sed -i '/fi$/d' "$CONFIG_FILE"
    echo -e "  ✓ 已清理 $CONFIG_FILE"
fi

# 完成
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  卸载完成!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "请运行 ${YELLOW}source $CONFIG_FILE${NC} 或重新打开终端"
