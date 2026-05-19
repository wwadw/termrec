# termrec - 终端命令记录工具

## 功能
记录终端会话中运行的所有命令，支持查看、导出和回放。

## 安装
已自动安装完成，配置已添加到 `~/.bashrc`。

## 使用方法

### 1. 开始记录
```bash
termrec start [会话名称]
```
例如：
```bash
termrec start my-work      # 开始记录，命名为 my-work
termrec start               # 开始记录，使用默认名称 session
```

### 2. 停止记录
```bash
termrec stop
```

### 3. 查看记录列表
```bash
termrec list
```

### 4. 查看具体记录
```bash
termrec show <记录ID>
```
例如：
```bash
termrec show 20260519_142030_my-work
```

### 5. 导出记录
```bash
termrec export <记录ID>
```
导出到桌面为文本文件。

### 6. 删除记录
```bash
termrec delete <记录ID>
```

### 7. 清理所有记录
```bash
termrec clean
```

### 8. 查看当前状态
```bash
termrec status
```

## 记录文件位置
所有记录保存在 `~/.termrec/` 目录下：
- `.meta` - 元数据（会话名、时间等）
- `.history` - bash 历史记录
- `.cmdlog` - 命令日志（带时间戳）
- `.log` - 终端完整输出（script 格式）
- `.timing` - 时间信息（用于回放）

## 重新加载配置
如果刚安装，需要重新加载 bash 配置：
```bash
source ~/.bashrc
```

## 示例工作流

```bash
# 开始记录
$ termrec start debugging
✓ 开始记录: debugging
  会话 ID: 20260519_142030_debugging

# 正常工作...
$ ls -la
$ vim test.py
$ python test.py

# 停止记录
$ termrec stop
✓ 记录已停止
  持续时间: 0小时 15分 30秒
  命令数: 12

# 查看记录
$ termrec show 20260519_142030_debugging

# 列出所有记录
$ termrec list
```
