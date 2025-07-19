#!/bin/bash

# WSL2에 Obsidian AppImage 실행을 위한 필수 라이브러리 설치 스크립트

echo "WSL2 Obsidian 필수 라이브러리 설치를 시작합니다..."
echo "---------------------------------------------------"

# 패키지 목록 업데이트
echo "1. 패키지 목록 업데이트 중..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "오류: 패키지 목록 업데이트에 실패했습니다. 인터넷 연결을 확인하거나 다시 시도해주세요."
    exit 1
fi
echo "패키지 목록 업데이트 완료."

# FUSE 라이브러리 설치 (libfuse2)
echo "2. FUSE 라이브러리 (libfuse2) 설치 중..."
sudo apt install -y libfuse2
if [ $? -ne 0 ]; then
    echo "오류: libfuse2 설치에 실패했습니다."
    exit 1
fi
echo "FUSE 라이브러리 (libfuse2) 설치 완료."

# ALSA 사운드 라이브러리 설치 (libasound2t64)
echo "3. ALSA 사운드 라이브러리 (libasound2t64) 설치 중..."
sudo apt install -y libasound2t64
if [ $? -ne 0 ]; then
    echo "오류: libasound2t64 설치에 실패했습니다."
    exit 1
fi
echo "ALSA 사운드 라이브러리 (libasound2t64) 설치 완료."

echo "---------------------------------------------------"
echo "Obsidian AppImage 실행을 위한 모든 필수 라이브러리 설치가 완료되었습니다."
echo "이제 './Obsidian-1.8.10.AppImage' 명령어로 Obsidian을 실행해 보세요."