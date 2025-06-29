# WSL2 Obsidian 한글 입력 설정 가이드

WSL2 환경에서 Obsidian 사용 시 한글 입력이 되지 않을 때, 다음 단계별 가이드를 통해 문제를 해결할 수 있습니다. 이 가이드는 **한글 폰트 설치**와 **한글 입력기(Fcitx) 설정**에 중점을 둡니다.

## 1\. 한글 폰트 설치

한글이 깨지지 않고 올바르게 표시되려면 시스템에 한글 폰트가 설치되어 있어야 합니다.

```bash
sudo apt update
sudo apt install fonts-nanum*
```

  * **`sudo apt update`**: 시스템의 패키지 목록을 최신 상태로 업데이트합니다.
  * **`sudo apt install fonts-nanum*`**: 나눔 글꼴 패키지를 설치합니다. `*`은 모든 나눔 글꼴 관련 패키지를 설치하겠다는 의미입니다.

## 2\. 한글 입력기 (Fcitx) 설치 및 설정

WSL2의 GUI 애플리케이션에서 한글을 입력하려면 `Fcitx`와 같은 한글 입력기 프레임워크가 필수적입니다. `Fcitx`는 안정적이고 설정이 비교적 간단하여 많이 사용됩니다.

### 2.1. Fcitx 및 관련 모듈 설치

WSL 터미널에서 다음 명령어를 실행하여 `Fcitx` 입력기 프레임워크와 한글 모듈(`fcitx-hangul`), 그리고 추가적인 한글 폰트(`fonts-noto-cjk`) 및 `dbus-x11`을 설치합니다. `dbus-x11`은 GUI 프로그램과의 통신에 필요합니다.

```bash
sudo apt update
sudo apt install fcitx fcitx-hangul fonts-noto-cjk dbus-x11
```

### 2.2. 입력기 시스템 설정 (im-config)

`im-config` 명령을 사용하여 시스템의 기본 입력기 프레임워크를 `fcitx`로 설정합니다.

```bash
im-config
```

명령 실행 후 다음 단계를 따릅니다.

1.  `OK`를 선택합니다.
2.  "Do you explicitly select the user configuration?" 질문에 \*\*`Yes`\*\*를 선택합니다.
3.  나타나는 목록에서 \*\*`fcitx`\*\*를 선택하고 `OK`를 선택합니다.
4.  마지막 확인 메시지에서 `OK`를 선택합니다.

### 2.3. 환경 변수 설정

Obsidian과 같은 GUI 애플리케이션이 `Fcitx`를 올바른 입력기로 인식하도록 환경 변수를 설정해야 합니다. 사용자 홈 디렉토리의 **`.bashrc`** 파일을 편집합니다.

```bash
nano ~/.bashrc
```

파일의 가장 마지막 줄에 다음 내용을 추가합니다.

```bash
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# fcitx가 아직 실행되지 않았다면 시작 (선택 사항이지만 권장)
if ! pgrep -x fcitx >/dev/null; then
    fcitx-autostart &>/dev/null
fi
```

내용을 추가한 후 \*\*`Ctrl+X`\*\*를 누르고 \*\*`Y`\*\*를 눌러 저장한 다음 \*\*`Enter`\*\*를 눌러 나옵니다.

환경 변수 변경 사항을 즉시 적용하려면 다음 명령어를 실행합니다 (또는 WSL 터미널을 완전히 닫았다가 다시 엽니다).

```bash
source ~/.bashrc
```

### 2.4. Fcitx 설정 (한영 전환 키 등)

`Fcitx` 입력기 자체의 설정을 조정하여 한영 전환 키를 설정합니다.

```bash
fcitx-config-gtk3
```

이 명령을 실행하면 **`Fcitx Configuration`** 창이 나타납니다.

  * **`Input Method` 탭**: 왼쪽 하단의 `+` 버튼을 클릭합니다. "Only Show Current Language" 체크박스를 해제하고 검색창에 `Hangul`을 입력하여 \*\*`Hangul`\*\*을 선택한 후 `OK`를 눌러 추가합니다.
  * **`Global Config` 탭**: `Trigger Input Method` 항목을 클릭하여 원하는 **한영 전환 키** (예: `Right Alt` 키 또는 `Shift + Space`)를 누릅니다. 설정이 완료되면 창을 닫습니다.

## 3\. WSL 재부팅

위의 모든 설정을 마친 후에는 WSL 자체를 완전히 재부팅하여 변경 사항이 제대로 적용되도록 합니다. Windows PowerShell (관리자 권한으로 실행)에서 다음 명령을 실행합니다.

```powershell
wsl --shutdown
```

이후 다시 WSL을 실행하고 APP(Obsidian, Pycharm)을 시작하여 한글 입력이 정상적으로 되는지 확인합니다.
