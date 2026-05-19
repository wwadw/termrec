INSTALL_DIR = $(HOME)/bin
PREFIX = /usr/local

.PHONY: install uninstall clean package help

help:
	@echo "termrec - 终端命令记录工具"
	@echo ""
	@echo "用法:"
	@echo "  make install    安装 termrec"
	@echo "  make uninstall  卸载 termrec"
	@echo "  make package    打包发布文件"
	@echo "  make clean      清理临时文件"
	@echo ""
	@echo "安装选项:"
	@echo "  INSTALL_DIR=$(INSTALL_DIR)  安装目录"

install:
	@chmod +x install.sh
	@./install.sh

uninstall:
	@chmod +x uninstall.sh
	@./uninstall.sh

package: clean
	@echo "打包中..."
	@mkdir -p dist
	@tar czf dist/termrec-1.0.0.tar.gz \
		--transform 's,^,termrec-1.0.0/,' \
		bin/ docs/ install.sh uninstall.sh Makefile README.md
	@echo "✓ 打包完成: dist/termrec-1.0.0.tar.gz"
	@ls -lh dist/termrec-1.0.0.tar.gz

clean:
	@rm -rf dist
	@echo "✓ 清理完成"
