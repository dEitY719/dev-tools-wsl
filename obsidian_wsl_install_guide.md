# WSL2 (Windows Subsystem for Linux 2) 에 Obsidian 설치 가이드

이 문서는 Windows Subsystem for Linux 2 (WSL2) 환경에 Obsidian AppImage를 설치하고 실행하는 과정을 안내합니다. 이 가이드는 특히 Python 개발자이며 TDD, SOLID 원칙, 유지보수/확장성 좋은 아키텍처를 지향하는 분들을 위해 작성되었습니다.

## 1. Obsidian AppImage 다운로드

Obsidian 공식 웹사이트에서 리눅스용 AppImage 파일을 다운로드합니다.
권장 버전: `Obsidian-1.8.10.AppImage` (또는 최신 안정 버전)

## 2. AppImage 파일 WSL2 환경으로 이동

다운로드한 `Obsidian-1.8.10.AppImage` 파일을 WSL2 리눅스 환경의 원하는 디렉터리로 이동합니다. 일반적으로 사용자 홈 디렉터리 내의 `~/application` 또는 `~/bin`과 같은 곳에 두는 것을 권장합니다.

예시:

```bash
# 윈도우 다운로드 폴더에서 WSL2 홈 디렉터리로 복사 (WSL 터미널에서 실행)
# cp /mnt/c/Users/YourWindowsUsername/Downloads/Obsidian-1.8.10.AppImage ~/application/
````

> 여기서 `YourWindowsUsername`은 실제 윈도우 사용자 이름으로 변경해야 합니다.

## 3\. 필수 라이브러리 설치

Obsidian AppImage는 실행을 위해 특정 라이브러리들을 필요로 합니다. WSL2 환경에는 이러한 라이브러리들이 기본적으로 설치되어 있지 않을 수 있습니다.

### 3.1. FUSE 라이브러리 설치

AppImage는 FUSE (Filesystem in Userspace)를 사용하여 자체 압축된 파일 시스템을 마운트합니다. 이 라이브러리가 없으면 `dlopen(): error loading libfuse.so.2` 오류가 발생합니다.

WSL2 터미널에서 다음 명령어를 실행하여 `libfuse2`를 설치합니다.

```bash
sudo apt update
sudo apt install libfuse2
```

### 3.2. ALSA 사운드 라이브러리 설치

Obsidian은 사운드 기능을 위해 ALSA (Advanced Linux Sound Architecture) 관련 라이브러리를 필요로 합니다. 이 라이브러리가 없으면 `error while loading shared libraries: libasound.so.2` 오류가 발생합니다.

WSL2 Ubuntu 환경에서는 `libasound2`가 가상 패키지이므로, 실제 필요한 패키지인 `libasound2t64`를 설치해야 합니다.

```bash
sudo apt install libasound2t64
```

## 4\. AppImage 실행 권한 부여

다운로드한 AppImage 파일에 실행 권한을 부여해야 합니다. AppImage 파일이 있는 디렉터리로 이동한 후 다음 명령어를 입력합니다.

```bash
cd ~/application # AppImage 파일이 있는 디렉터리로 이동
chmod +x Obsidian-1.8.10.AppImage
```

## 5\. Obsidian 실행

실행 권한 부여 및 필수 라이브러리 설치가 완료되었다면, 다음 명령어로 Obsidian을 실행할 수 있습니다.

```bash
./Obsidian-1.8.10.AppImage
```

Obsidian 창이 정상적으로 나타나는 것을 확인할 수 있습니다.

## 6\. Obsidian 실행을 위한 Alias 설정 (선택 사항)

매번 전체 경로를 입력하지 않고 `obsidian` 명령어로 실행할 수 있도록 `.bashrc` 또는 별도의 셸 설정 파일에 alias를 추가하는 것을 권장합니다.

예시 (`~/.bashrc` 또는 `~/dotfiles/bash/app/obsidian.bash` 파일에 추가):

```bash
# Obsidian AppImage 실행을 위한 alias
alias obsidian='~/application/Obsidian-1.8.10.AppImage'
```

alias를 추가한 후에는 변경 사항을 적용하기 위해 셸을 다시 시작하거나 다음 명령어를 실행합니다.

```bash
source ~/.bashrc # 또는 source ~/dotfiles/bash/app/obsidian.bash
```

이제 WSL2 터미널에서 `obsidian`이라고 입력하면 Obsidian이 실행됩니다.

## 7\. Obsidian 활용 팁 (개발자를 위한)

* **PARA 구조와 제텔카스텐 방법론 적용:**

  * **Projects (프로젝트):** 현재 개발 중인 웹 앱의 각 기능(예: 사용자 인증, 데이터베이스 연동)을 위한 허브 노트를 만들고 관련 아이디어를 연결합니다.
  * **Areas (영역):** Python OOP, TDD, SOLID 원칙, Dash Mantine Components 사용법 등 지속적인 학습 및 개발 지식 영역을 위한 영구 노트를 축적합니다. 각 원칙이나 패턴에 대한 원자적인 노트를 만들고 서로 연결하여 깊이 있는 지식 그래프를 구축합니다.
  * **Resources (자료):** 개발 관련 블로그, 문서, 강의 등을 읽으면서 얻은 핵심 내용을 문헌 노트로 요약하고, 이를 바탕으로 영구 노트를 생성하여 기존 지식과 연결합니다.
  * **Archives (아카이브):** 완료된 프로젝트나 더 이상 활발히 사용하지 않는 지식은 아카이브로 분류하지만, Obsidian 내에서는 여전히 검색 및 참조가 가능하도록 유지합니다.

* **플러그인 활용:** Obsidian의 커뮤니티 플러그인을 활용하여 개발 워크플로우에 맞는 기능을 추가합니다. 예를 들어, 코드 블록 강조, Mermaid 다이어그램, LaTeX 수식 지원, Git 통합 플러그인 등을 활용할 수 있습니다.

* **버전 관리:** Obsidian 볼트(Vault)를 Git으로 관리하여 노트의 변경 이력을 추적하고 백업합니다. 이는 코드 버전 관리와 동일하게 지식의 안정성을 확보하는 좋은 방법입니다.

## FYI: install_obsidian_library.sh 스크립트 사용 방법: **

1. 위 내용을 `install_obsidian_library.sh` 파일로 저장합니다.
2. WSL 터미널에서 해당 파일에 실행 권한을 부여합니다.

    ```bash
    chmod +x install_obsidian_library.sh
    ```

3. 스크립트를 실행합니다.

    ```bash
    ./install_obsidian_library.sh
    ```

이 가이드와 스크립트가 멘토님의 WSL 환경에서 Obsidian을 원활하게 사용하시고, 개발 지식을 체계적으로 관리하는 데 큰 도움이 되기를 바랍니다\!
