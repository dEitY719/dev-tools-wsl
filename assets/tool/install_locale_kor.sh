#!/usr/bin/env bash
# install_locale_kor.sh
# WSL에서 ko_KR.UTF-8 로케일을 설치하고 설정하는 스크립트

set -e

echo "🌏 [1/5] 현재 로케일 상태 확인 중..."
locale || echo "⚠️ 현재 로케일을 불러올 수 없습니다."

echo "📦 [2/5] locales 패키지 설치 중 (sudo 필요)..."
sudo apt update && sudo apt install -y locales

echo "🛠 [3/5] ko_KR.UTF-8 로케일 생성 중..."
sudo locale-gen ko_KR.UTF-8

echo "🔧 [4/5] 시스템 기본 로케일을 ko_KR.UTF-8로 설정 중..."
sudo update-locale LANG=ko_KR.UTF-8

echo "✅ [5/5] 설정 완료! 현재 로케일 확인:"
locale

echo ""
echo "🎉 로케일 설치가 완료되었습니다!"
echo "👉 만약 .bashrc 또는 .zshrc에 LANG/LC_ALL 환경 변수를 설정하려면 아래 내용을 추가하세요:"
echo "   export LANG=ko_KR.UTF-8"
echo "   export LC_ALL=ko_KR.UTF-8"
echo ""
echo "🧐 설치된 로케일 목록을 확인하려면:"
echo "   locale -a | grep ko_KR"
echo ""
