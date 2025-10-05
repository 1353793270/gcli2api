#!/bin/zsh
# macOS (Apple Silicon) 安装脚本

# 确保 Homebrew 已安装
if ! command -v brew &> /dev/null; then
    echo "未检测到 Homebrew，开始安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 更新 brew 并安装 git
brew update
brew install git

# 安装 uv (Python 环境管理工具)
curl -Ls https://astral.sh/uv/install.sh | sh

# 确保 uv 在 PATH 中
export PATH="$HOME/.local/bin:$PATH"

# 克隆或进入项目目录
if [ -f "./web.py" ]; then
    # 已经在目标目录
    :
elif [ -f "./gcli2api/web.py" ]; then
    cd ./gcli2api
else
    git clone https://github.com/su-kaka/gcli2api.git
    cd ./gcli2api
fi

# 拉取最新代码
git pull

# 创建并同步虚拟环境
uv sync

# 激活虚拟环境
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
else
    echo "❌ 未找到虚拟环境，请检查 uv 是否安装成功"
    exit 1
fi

# 如果存在 requirements.txt，则安装
if [ -f "requirements.txt" ]; then
    echo "检测到 requirements.txt，开始安装依赖..."
    pip install -r requirements.txt
fi

# 启动项目
python3 web.py
