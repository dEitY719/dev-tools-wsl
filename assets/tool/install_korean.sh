#!/bin/bash

# --- 스크립트 실행 전 주의사항 ---
# 1. 이 스크립트는 Debian/Ubuntu 기반의 WSL2 환경을 가정합니다.
# 2. 'fcitx-config-gtk3' 설정은 GUI 환경이 필요하므로 스크립트가 완전히 자동화할 수 없습니다.
#    스크립트 실행 후 마지막 단계를 수동으로 진행해야 합니다.
# 3. 스크립트 실행 후 WSL을 재부팅해야 모든 변경사항이 적용됩니다.

echo "--- WSL2 한글 입력 설정 스크립트 시작 ---"

# 1. 시스템 패키지 목록 업데이트
echo "[1/4] 시스템 패키지 목록을 업데이트합니다..."
sudo apt update -y
echo "시스템 패키지 목록 업데이트 완료."

# 2. 한글 폰트 및 Fcitx 입력기 설치
echo "[2/4] 한글 폰트 (Nanum, Noto CJK) 및 Fcitx 입력기를 설치합니다..."
sudo apt install -y fonts-nanum* fcitx fcitx-hangul fonts-noto-cjk dbus-x11
echo "한글 폰트 및 Fcitx 입력기 설치 완료."

# 3. im-config를 사용하여 Fcitx를 기본 입력기로 설정
echo "[3/4] im-config를 사용하여 Fcitx를 기본 입력기로 설정합니다."
# im-config는 대화형이므로 'Yes'와 'fcitx'를 자동으로 선택하도록 합니다.
# 이 부분은 사용자 상호작용이 필요할 수 있으므로, 자동화가 완벽하지 않을 수 있습니다.
# 재부팅 후에도 적용되지 않으면 'im-config'를 수동으로 실행하여 확인해주세요.
echo "im-config 설정 시 'Yes'와 'fcitx'를 선택해주세요."
# 특정 버전의 im-config는 대화형 없이 바로 설정될 수도 있습니다.
# 아래 명령은 im-config가 대화형으로 나타날 경우를 대비합니다.
# 환경 변수 설정을 통해 자동으로 선택되도록 시도합니다.
sudo DEBIAN_FRONTEND=noninteractive im-config -n fcitx

# 4. 환경 변수 설정 (.bashrc에 추가)
echo "[4/4] ~/.bashrc 파일에 환경 변수를 설정합니다..."
BASHRC_PATH="$HOME/.bashrc"
BASHRC_CONTENT='
# --- WSL2 한글 입력 설정 (자동 추가됨) ---
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# fcitx가 아직 실행되지 않았다면 시작 (선택 사항이지만 권장)
if ! pgrep -x fcitx >/dev/null; then
    fcitx-autostart &>/dev/null
fi
# --- WSL2 한글 입력 설정 끝 ---
'

# 이미 내용이 있는지 확인하여 중복 추가 방지
if ! grep -q "export QT_IM_MODULE=fcitx" "$BASHRC_PATH"; then
    echo "$BASHRC_CONTENT" >> "$BASHRC_PATH"
    echo ".bashrc에 환경 변수 추가 완료."
else
    echo ".bashrc에 이미 환경 변수가 설정되어 있습니다. (중복 방지)"
fi

echo "--- 스크립트 실행 완료 ---"
echo ""
echo "이제 다음 단계를 수동으로 진행해야 합니다:"
echo "1. 현재 터미널에 변경사항을 적용: 'source ~/.bashrc'"
echo "2. Fcitx 설정: 'fcitx-config-gtk3'를 실행하여 Input Method에 'Hangul'을 추가하고, Global Config에서 한영 전환 키를 설정하세요 (예: Right Alt)."
echo "3. WSL2를 완전히 재부팅: PowerShell에서 'wsl --shutdown' 명령 후 WSL을 다시 실행하세요."
echo ""
echo "위 단계를 모두 완료하면 Obsidian에서 한글 입력이 가능할 것입니다."