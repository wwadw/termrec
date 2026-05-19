# termrec

终端命令记录工具 - 记录、查看、导出终端会话中的所有命令。

## 功能特性

- 📝 记录终端会话中的所有命令
- ⏱️ 自动记录命令执行时间
- 📊 统计命令数量和会话时长
- 📤 导出命令记录为文本文件
- 🎨 彩色终端输出
- 🔧 支持 Bash 和 Zsh

## 快速安装

### 方法一：从发布包安装

```bash
# 下载发布包
wget https://github.com/yourusername/termrec/releases/download/v1.0.0/termrec-1.0.0.tar.gz

# 解压
tar xzf termrec-1.0.0.tar.gz
cd termrec-1.0.0

# 安装
./install.sh
```

### 方法二：从源码安装

```bash
git clone https://github.com/yourusername/termrec.git
cd termrec
make install
```

### 方法三：手动安装

```bash
# 复制文件
cp bin/termrec ~/bin/
cp bin/termrec-bash.sh ~/bin/
chmod +x ~/bin/termrec

# 添加到 .bashrc 或 .zshrc
echo 'if [ -f ~/bin/termrec-bash.sh ]; then source ~/bin/termrec-bash.sh; fi' >> ~/.bashrc

# 重新加载
source ~/.bashrc
```

## 使用方法

### 基本命令

```bash
# 开始记录
termrec start [会话名称]

# 停止记录
termrec stop

# 查看记录列表
termrec list

# 查看具体记录
termrec show <记录ID>

# 导出记录
termrec export <记录ID>

# 删除记录
termrec delete <记录ID>

# 清理所有记录
termrec clean

# 查看状态
termrec status
```

### 使用示例

```bash
# 开始一个调试会话
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
```

## 记录文件

所有记录保存在 `~/.termrec/` 目录：

| 文件 | 说明 |
|------|------|
| `.meta` | 元数据（会话名、时间等）|
| `.history` | Bash 历史记录 |
| `.cmdlog` | 命令日志（带时间戳）|
| `.log` | 终端完整输出 |
| `.timing` | 时间信息（用于回放）|

## 卸载

```bash
# 方法一：使用卸载脚本
./uninstall.sh

# 方法二：使用 make
make uninstall

# 方法三：手动卸载
rm ~/bin/termrec ~/bin/termrec-bash.sh
rm -rf ~/.termrec
# 编辑 ~/.bashrc 删除 termrec 相关配置
```

## 从源码打包

```bash
# 创建发布包
make package

# 生成文件: dist/termrec-1.0.0.tar.gz
```

## 系统要求

- Bash 4.0+ 或 Zsh
- Linux 或 macOS
- 核心工具: `script`, `date`, `grep`, `sed`

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 作者

Your Name <your.email@example.com>
