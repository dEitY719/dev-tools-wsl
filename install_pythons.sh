#!/bin/bash

# --- pyenv 설치 전 의존성 패키지 설치 (선택 사항이지만 권장) ---
log_dim "--- pyenv 의존성 패키지 설치 중... ---"
sudo apt update
sudo apt upgrade -y
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
log_info "--- 의존성 패키지 설치 완료. ---"
log_dim ""

# --- pyenv 설치 ---
log_dim "--- pyenv 설치 시작... ---"
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
    log_debug "pyenv가 성공적으로 설치되었습니다."
else
    log_warning "pyenv가 이미 설치되어 있습니다. 업데이트를 시도합니다."
    cd "$HOME/.pyenv" && git pull
fi
log_info "--- pyenv 설치 완료. ---"
log_dim ""

# --- .bashrc (또는 .zshrc)에 pyenv 설정 추가 ---
log_dim "--- .bashrc에 pyenv 설정 추가 중... ---"
BASHRC_PATH="$HOME/.bashrc"
PYENV_INIT_SNIPPET='
# pyenv 설정
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
'

# 이미 pyenv 설정이 추가되어 있는지 확인 후 추가
if ! grep -q "pyenv init" "$BASHRC_PATH"; then
    log_dim "$PYENV_INIT_SNIPPET" >> "$BASHRC_PATH"
    log_info ".bashrc에 pyenv 설정이 추가되었습니다. 변경사항을 적용하려면 'source ~/.bashrc'를 실행하거나 터미널을 재시작하세요."
else
    log_dim ".bashrc에 pyenv 설정이 이미 존재합니다. 추가 작업을 건너뜁니다."
fi
log_info "--- .bashrc 설정 완료. ---"
log_dim ""

# 변경된 환경변수 즉시 적용 (현재 스크립트 실행 환경에서만)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# --- 원하는 Python 버전 설치 ---
PYTHON_VERSIONS=(
    "3.13.5"
    "3.12.11"
    "3.11.13"
    "3.10.18"
)

log_dim "--- Python 버전 설치 시작... ---"
for version in "${PYTHON_VERSIONS[@]}"; do
    log_dim "--- Python $version 설치 중... ---"
    pyenv install "$version"
    if [ $? -eq 0 ]; then # 이전 명령어 성공 여부 확인
        log_info "Python $version 설치 완료."
        # 설치된 버전의 pip 업그레이드
        log_dim "pip를 최신 버전으로 업그레이드 중... (Python $version)"
        "$PYENV_ROOT/versions/$version/bin/python" -m pip install --upgrade pip
        log_dim "pip 업그레이드 완료 (Python $version)."
    else
        log_error "오류: Python $version 설치 실패."
        # 실패 시에도 나머지 버전 설치를 계속 진행
    fi
    log_dim ""
done
log_info "--- 모든 Python 버전 설치 시도 완료. ---"
log_dim ""

# --- 전역(global) Python 버전 설정 ---
# 가장 최신 버전인 3.13.5를 전역 버전으로 설정합니다. 필요에 따라 변경 가능.
log_dim "--- 전역 Python 버전 3.13.5 설정 중... ---"
pyenv global 3.13.5
log_info "--- 전역 Python 버전 설정 완료. ---"
log_dim ""

log_critical "--- pyenv 설치 및 Python 버전 설치 스크립트 실행 완료. ---"
log_dim "터미널을 재시작하거나 'source ~/.bashrc'를 실행하여 변경사항을 적용하세요."
log_dim "설치된 Python 버전 목록 확인: pyenv versions"
log_dim "현재 전역 Python 버전 확인: python --version"