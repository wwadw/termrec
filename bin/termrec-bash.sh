#!/bin/bash
# termrec-bash.sh - termrec 的 bash 集成
# 在 .bashrc 中 source 此文件以启用命令记录功能

# 记录目录
TERMREC_DIR="$HOME/.termrec"
TERMREC_ACTIVE=false

# 确保目录存在
mkdir -p "$TERMREC_DIR"

# termrec 主函数（覆盖外部命令，提供更好的集成）
termrec() {
    local external_termrec="$HOME/bin/termrec"
    case "${1}" in
        start)
            _termrec_start "${2:-session}"
            ;;
        stop)
            _termrec_stop
            ;;
        list|show|export|delete|clean|status|help)
            # 调用外部脚本
            "$external_termrec" "$@"
            ;;
        *)
            "$external_termrec" "$@"
            ;;
    esac
}

_termrec_start() {
    local name="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local logprefix="$TERMREC_DIR/${timestamp}_${name}"
    
    if [ "$TERMREC_ACTIVE" = true ]; then
        echo -e "\033[0;31m错误: 已有记录在进行中\033[0m"
        echo -e "使用 \033[1;33mtermrec stop\033[0m 先停止当前记录"
        return 1
    fi
    
    # 创建元数据
    cat > "${logprefix}.meta" <<EOF
name=$name
start=$(date -Iseconds)
host=$(hostname)
shell=$SHELL
pwd=$PWD
EOF
    
    # 设置历史记录文件
    export TERMREC_HISTFILE="${logprefix}.history"
    export TERMREC_CMDLOG="${logprefix}.cmdlog"
    export TERMREC_SESSION_ID="${timestamp}_${name}"
    export TERMREC_ACTIVE=true
    export TERMREC_START_TIME=$(date +%s)
    
    # 保存原始 HISTFILE
    export TERMREC_ORIG_HISTFILE="$HISTFILE"
    
    # 设置新的 HISTFILE
    export HISTFILE="$TERMREC_HISTFILE"
    
    # 记录初始命令
    echo "# termrec 开始记录: $(date)" > "$TERMREC_CMDLOG"
    echo "# 会话: ${name}" >> "$TERMREC_CMDLOG"
    echo "# 目录: $PWD" >> "$TERMREC_CMDLOG"
    echo "" >> "$TERMREC_CMDLOG"
    
    # 设置 PROMPT_COMMAND 记录命令
    if [[ -z "$PROMPT_COMMAND" ]]; then
        export PROMPT_COMMAND='_termrec_log_command'
    else
        export PROMPT_COMMAND="$PROMPT_COMMAND; _termrec_log_command"
    fi
    
    echo -e "\033[0;32m✓ 开始记录: ${name}\033[0m"
    echo -e "  会话 ID: ${timestamp}_${name}"
    echo -e "  日志文件: ${logprefix}.cmdlog"
    echo -e "  历史文件: ${logprefix}.history"
    echo ""
    echo -e "使用 \033[1;33mtermrec stop\033[0m 停止记录"
}

_termrec_stop() {
    if [ "$TERMREC_ACTIVE" != true ]; then
        echo -e "\033[1;33m没有正在进行的记录\033[0m"
        return 0
    fi
    
    local logprefix="$TERMREC_DIR/$TERMREC_SESSION_ID"
    
    # 更新元数据
    echo "end=$(date -Iseconds)" >> "${logprefix}.meta"
    echo "duration=$(($(date +%s) - TERMREC_START_TIME))" >> "${logprefix}.meta"
    
    # 记录结束
    echo "" >> "$TERMREC_CMDLOG"
    echo "# termrec 停止记录: $(date)" >> "$TERMREC_CMDLOG"
    
    # 计算持续时间
    local duration=$(($(date +%s) - TERMREC_START_TIME))
    local hours=$((duration / 3600))
    local minutes=$(( (duration % 3600) / 60 ))
    local seconds=$((duration % 60))
    
    # 恢复原始 HISTFILE
    if [ -n "$TERMREC_ORIG_HISTFILE" ]; then
        export HISTFILE="$TERMREC_ORIG_HISTFILE"
    fi
    
    # 移除 PROMPT_COMMAND 中的 _termrec_log_command
    export PROMPT_COMMAND="${PROMPT_COMMAND//; _termrec_log_command/}"
    export PROMPT_COMMAND="${PROMPT_COMMAND//_termrec_log_command; /}"
    export PROMPT_COMMAND="${PROMPT_COMMAND//_termrec_log_command/}"
    
    # 统计命令数
    local cmd_count=0
    if [ -f "$TERMREC_HISTFILE" ]; then
        cmd_count=$(grep -c "^[^#]" "$TERMREC_HISTFILE" 2>/dev/null || echo 0)
    fi
    
    # 清理环境变量
    unset TERMREC_HISTFILE
    unset TERMREC_CMDLOG
    unset TERMREC_SESSION_ID
    unset TERMREC_START_TIME
    unset TERMREC_ORIG_HISTFILE
    export TERMREC_ACTIVE=false
    
    echo -e "\033[0;32m✓ 记录已停止\033[0m"
    echo -e "  会话: ${TERMREC_SESSION_ID}"
    echo -e "  持续时间: ${hours}小时 ${minutes}分 ${seconds}秒"
    echo -e "  命令数: ${cmd_count}"
    echo ""
    echo -e "使用 \033[1;36mtermrec show ${TERMREC_SESSION_ID}\033[0m 查看记录"
}

_termrec_log_command() {
    if [ "$TERMREC_ACTIVE" = true ]; then
        local last_cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')
        if [ -n "$last_cmd" ] && [ "$last_cmd" != "$TERMREC_LAST_CMD" ]; then
            local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
            echo "[$timestamp] $last_cmd" >> "$TERMREC_CMDLOG"
            export TERMREC_LAST_CMD="$last_cmd"
        fi
    fi
}

# 如果直接运行脚本，显示帮助
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "请在 .bashrc 中 source 此文件:"
    echo "  source ~/bin/termrec-bash.sh"
    echo ""
    echo "然后使用 termrec 命令:"
    echo "  termrec start [名称]  - 开始记录"
    echo "  termrec stop          - 停止记录"
    echo "  termrec list          - 列出记录"
fi
