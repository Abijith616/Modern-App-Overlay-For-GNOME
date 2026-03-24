#!/usr/bin/env bash
set -e

# ── Modern App Overlay for GNOME — Uninstall Script ────────────────────────

COSMIC_DIR="/usr/share/gnome-shell/extensions/pop-cosmic@system76.com"
THEME_CSS="/usr/share/themes/Pop-dark/gnome-shell/gnome-shell.css"
DARK_CSS="$COSMIC_DIR/dark.css"
APP_JS="$COSMIC_DIR/applications.js"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo "  Modern App Overlay for GNOME — Uninstaller"
echo "  ────────────────────────────────────────────"
echo ""

restored=0

restore() {
    local file="$1"
    if [[ -f "${file}.bak" ]]; then
        sudo cp "${file}.bak" "$file"
        info "Restored: $file"
        restored=$((restored + 1))
    else
        warn "No backup found for $file — skipping"
    fi
}

restore "$DARK_CSS"
restore "$APP_JS"
restore "$THEME_CSS"

if [[ $restored -eq 0 ]]; then
    error "No backup files found. Nothing was restored."
fi

info "Restarting GNOME Shell..."
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Reverting Modern App Overlay…")' 2>/dev/null || \
    warn "Could not auto-restart (Wayland?). Please log out and back in."

echo ""
echo "  ✅  Uninstall complete. Everything restored to original."
echo ""
