#!/usr/bin/env bash
set -euo pipefail

# 주의 (sudo로 설치하지 말것!)
# sudo로 설치하면 /root/.local/bin 아래에 설치됨
# bwyoon@SERAPH:~/dev-tools-wsl(main)$ ./assets/tool/install_uv.sh 

# UV 설치 URL
UV_INSTALL_URL="https://astral.sh/uv/install.sh"

echo "[INFO] uv 설치를 시작합니다..."

# curl 또는 wget 확인
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$UV_INSTALL_URL" | sh
elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$UV_INSTALL_URL" | sh
else
    echo "[ERROR] curl 또는 wget이 필요합니다. 설치 후 다시 시도하세요."
    exit 1
fi

echo "[INFO] uv 설치가 완료되었습니다."
echo "[INFO] PATH에 ~/.local/bin 이 포함되어야 uv 명령어가 정상 작동합니다."
