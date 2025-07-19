#!/usr/bin/env bash
set -euo pipefail

TARGET="${HOME}/.local/bin/env"

mkdir -p "$(dirname "$TARGET")"

# 기존 파일 백업 (있으면)
if [ -f "$TARGET" ]; then
    TS=$(date +%Y%m%d-%H%M%S)
    cp -a "$TARGET" "${TARGET}.${TS}.bak"
    echo "[INFO] Backup created: ${TARGET}.${TS}.bak"
fi

# 파일 생성 (실행권한 없이)
cat > "$TARGET" <<'EOF'
#!/bin/sh
# add binaries to PATH if they aren't added yet
# affix colons on either side of $PATH to simplify matching
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        # Prepending path in case a system-installed binary needs to be overridden
        export PATH="$HOME/.local/bin:$PATH"
        ;;
esac
EOF

chmod 644 "$TARGET"

echo "[INFO] File created: $TARGET"
