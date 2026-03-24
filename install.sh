#!/usr/bin/env bash
set -e

# ── Modern App Overlay for GNOME — Install Script ──────────────────────────
# Tested on Pop!_OS 22.04 / GNOME Shell 42.x
# Backs up every file before touching it.
# ---------------------------------------------------------------------------

COSMIC_DIR="/usr/share/gnome-shell/extensions/pop-cosmic@system76.com"
THEME_CSS="/usr/share/themes/Pop-dark/gnome-shell/gnome-shell.css"
DARK_CSS="$COSMIC_DIR/dark.css"
APP_JS="$COSMIC_DIR/applications.js"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo "  Modern App Overlay for GNOME — Installer"
echo "  ─────────────────────────────────────────"
echo ""

# ── Checks ──────────────────────────────────────────────────────────────────
command -v gnome-shell >/dev/null 2>&1 || error "gnome-shell not found."
[[ -d "$COSMIC_DIR" ]] || error "pop-cosmic extension not found at $COSMIC_DIR\n  This tool requires Pop!_OS with the pop-cosmic extension."
[[ -f "$THEME_CSS" ]]  || warn "Pop-dark theme CSS not found at $THEME_CSS — skipping that step."

GNOME_VER=$(gnome-shell --version 2>/dev/null | grep -oP '\d+' | head -1)
info "Detected GNOME Shell $GNOME_VER"

if [[ "$GNOME_VER" -lt 42 ]]; then
    error "This patch targets GNOME 42+. Your version ($GNOME_VER) is not supported."
fi

# ── Backups ──────────────────────────────────────────────────────────────────
info "Creating backups..."
sudo cp "$DARK_CSS"  "${DARK_CSS}.bak"   2>/dev/null && info "Backed up dark.css"
sudo cp "$APP_JS"    "${APP_JS}.bak"     2>/dev/null && info "Backed up applications.js"
[[ -f "$THEME_CSS" ]] && sudo cp "$THEME_CSS" "${THEME_CSS}.bak" && info "Backed up gnome-shell.css"

# ── Patch 1: dark.css ────────────────────────────────────────────────────────
info "Writing new dark.css..."
sudo tee "$DARK_CSS" > /dev/null << 'CSS_EOF'
/* ── Modern App Overlay for GNOME — dark.css ── */

.cosmic-applications-dialog {
    background-color: rgba(238, 238, 238, 0.82);
    border-radius: 28px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    box-shadow:
        0 24px 60px rgba(0, 0, 0, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.95),
        inset 0 0 0 1px rgba(255, 255, 255, 0.35);
    padding: 28px 32px 32px 32px;
    color: rgba(20, 20, 20, 0.92);
}

.cosmic-app-tray-title {
    font-size: 24px;
    font-weight: 700;
    color: rgba(15, 15, 15, 0.92);
}

.cosmic-applications-search-entry {
    width: 340px;
    background-color: rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.09);
    border-radius: 999px;
    padding: 8px 18px;
    color: rgba(20, 20, 20, 0.9);
    caret-color: rgba(20, 20, 20, 0.7);
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
    font-size: 13px;
}

.cosmic-applications-search-entry:focus {
    background-color: rgba(0, 0, 0, 0.1);
    border-color: rgba(0, 0, 0, 0.18);
}

.cosmic-close-button {
    width: 28px;
    height: 28px;
    border-radius: 999px;
    background-color: rgba(0, 0, 0, 0.07);
    border: 1px solid rgba(0, 0, 0, 0.12);
    color: rgba(20, 20, 20, 0.6);
    margin-left: 12px;
}

.cosmic-close-button:hover {
    background-color: rgba(0, 0, 0, 0.14);
    color: rgba(20, 20, 20, 0.9);
}

.cosmic-category-tab {
    color: rgba(60, 60, 60, 0.42);
    font-size: 13px;
    font-weight: 500;
    padding: 2px 2px 6px 2px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
    border-bottom-color: transparent;
    background-color: transparent;
    border-top-width: 0;
    border-left-width: 0;
    border-right-width: 0;
}

.cosmic-category-tab:hover {
    color: rgba(15, 15, 15, 0.85);
    background-color: transparent;
}

.cosmic-category-tab:checked {
    color: rgba(15, 15, 15, 0.92);
    border-bottom-color: rgba(15, 15, 15, 0.65);
    background-color: transparent;
}

.cosmic-app-icon {
    height: 140px;
    width: 140px;
    border-radius: 20px;
}

.cosmic-app-icon:hover {
    background-color: rgba(0, 0, 0, 0.07);
}

.cosmic-app-icon:selected,
.cosmic-app-icon:focus {
    background-color: rgba(0, 0, 0, 0.1);
}

.overview-label {
    font-size: 13px;
    font-weight: 600;
    color: rgba(15, 15, 15, 0.88);
}

.cosmic-app-scroll-view {
    border-radius: 16px;
}

.cosmic-applications-box {
    spacing: 14px;
}

.cosmic-applications-separator {
    background-color: rgba(0, 0, 0, 0.08);
    margin: 4px 16px;
}

.cosmic-applications-folder-title {
    color: rgba(20, 20, 20, 0.95);
    font-size: 18px;
    font-weight: 600;
}

.cosmic-base-folder-button {
    width: 0px;
    height: 0px;
    opacity: 0;
}

.cosmic-applications-icon {
    color: rgba(40, 40, 40, 0.65);
}

.cosmic-applications-search-results {
    spacing: 24px;
}

.cosmic-applications-available {
    color: rgba(20, 20, 20, 0.5);
    font-size: 13px;
    font-weight: 500;
}

.cosmic-folder-edit-button {
    background-color: rgba(0, 0, 0, 0.05);
    border: 1px solid rgba(0, 0, 0, 0.08);
    border-radius: 10px;
    padding: 6px 8px;
}

.cosmic-folder-edit-button:hover {
    background-color: rgba(0, 0, 0, 0.1);
}

.cosmic-applications-dialog .app-well-app-running-dot {
    background-color: rgba(0, 0, 0, 0.35);
    width: 4px;
    height: 4px;
    border-radius: 2px;
}
CSS_EOF
info "dark.css written"

# ── Patch 2: applications.js ─────────────────────────────────────────────────
info "Patching applications.js..."
sudo python3 << 'PYEOF'
path = '/usr/share/gnome-shell/extensions/pop-cosmic@system76.com/applications.js'
with open(path, 'r') as f:
    src = f.read()

# Hide folder box
src = src.replace(
    "this.add_actor(this._folderBox);",
    "this.add_actor(this._folderBox);\n        this._folderBox.hide();",
    1
)

# Hide separator
src = src.replace(
    "this.add_actor(new St.Widget({ height: 1, style_class: 'cosmic-applications-separator' }));",
    "// separator hidden",
    1
)

# Change icon size
src = src.replace("this.icon.setIconSize(72)", "this.icon.setIconSize(64)", 1)

# Replace box construction
old = """        const box = new St.BoxLayout({ vertical: true, style_class: 'cosmic-applications-box' });
        box.add_child(this._header);
        box.add_child(stack);"""

new = """        // Title + Search + Close
        const titleLabel = new St.Label({
            text: 'Applications',
            style_class: 'cosmic-app-tray-title',
            y_align: Clutter.ActorAlign.CENTER,
            x_expand: true,
        });

        const closeBtn = new St.Button({
            style_class: 'cosmic-close-button',
            child: new St.Icon({ icon_name: 'window-close-symbolic', icon_size: 14 }),
            y_align: Clutter.ActorAlign.CENTER,
        });
        closeBtn.connect('clicked', () => this.hideDialog());

        const titleRow = new St.BoxLayout({ vertical: false, style: 'spacing: 16px;' });
        titleRow.add_child(titleLabel);
        titleRow.add_child(this._header);
        titleRow.add_child(closeBtn);

        // Category tabs — real .desktop category filtering
        const CATEGORIES = [
            { label: 'All',       cats: null },
            { label: 'Internet',  cats: ['Network', 'WebBrowser', 'Email', 'Chat', 'InstantMessaging'] },
            { label: 'Utilities', cats: ['Utility', 'Accessibility', 'TerminalEmulator', 'TextEditor', 'Archiving', 'Compression'] },
            { label: 'System',    cats: ['System', 'Settings', 'PackageManager', 'Monitor', 'Security', 'HardwareSettings'] },
            { label: 'Office',    cats: ['Office', 'WordProcessor', 'Spreadsheet', 'Presentation', 'Education', 'Science', 'Database'] },
            { label: 'Media',     cats: ['AudioVideo', 'Audio', 'Video', 'Graphics', 'Photography', 'Music', 'Player', 'Recorder'] },
        ];

        const appDisplayRef = this.appDisplay;

        this._catRow = new St.BoxLayout({ vertical: false, style: 'spacing: 20px;' });
        const catRow = this._catRow;

        CATEGORIES.forEach((cat, i) => {
            const btn = new St.Button({
                label: cat.label,
                style_class: 'cosmic-category-tab',
                toggle_mode: true,
                checked: i === 0,
            });
            btn.connect('clicked', () => {
                catRow.get_children().forEach(b => { b.checked = false; });
                btn.checked = true;
                appDisplayRef._box.get_children().forEach(icon => {
                    try {
                        const appInfo = icon.app.app_info;
                        if (!appInfo) { icon.visible = false; return; }
                        const allowed = appDisplayRef._parentalControlsManager.shouldShowApp(appInfo);
                        if (!allowed) { icon.visible = false; return; }
                        if (!cat.cats) {
                            icon.visible = true;
                        } else {
                            const appCats = (appInfo.get_categories() || '').split(';').map(s => s.trim()).filter(Boolean);
                            icon.visible = cat.cats.some(c => appCats.includes(c));
                        }
                    } catch(e) { icon.visible = false; }
                });
            });
            catRow.add_child(btn);
        });

        const box = new St.BoxLayout({ vertical: true, style_class: 'cosmic-applications-box' });
        box.add_child(titleRow);
        box.add_child(catRow);
        box.add_child(stack);"""

src = src.replace(old, new, 1)

# Reset to All on every open
old = "        this.appDisplay.reset();\n\n        // Update 'checked' state of Applications button"
new = """        this.appDisplay.reset();

        // Reset category to All on every open
        try {
            if (this._catRow) {
                this._catRow.get_children().forEach((b, i) => { b.checked = i === 0; });
                this.appDisplay._box.get_children().forEach(icon => {
                    try {
                        const appInfo = icon.app.app_info;
                        icon.visible = appInfo ?
                            this.appDisplay._parentalControlsManager.shouldShowApp(appInfo) : false;
                    } catch(e) {}
                });
            }
        } catch(e) {}

        // Update 'checked' state of Applications button"""

src = src.replace(old, new, 1)

with open(path, 'w') as f:
    f.write(src)

print("applications.js patched")
PYEOF
info "applications.js patched"

# ── Patch 3: Pop-dark theme — make modal-dialog transparent ─────────────────
if [[ -f "$THEME_CSS" ]]; then
    info "Patching Pop-dark gnome-shell.css..."
    sudo sed -i 's/  background-color: #33302F;/  background-color: transparent;/' "$THEME_CSS"
    sudo sed -i '/\.modal-dialog {/,/}/ s/border-radius: 6px/border-radius: 28px/' "$THEME_CSS"
    info "gnome-shell.css patched"
else
    warn "Pop-dark theme not found — skipping. If your app tray background is still opaque, manually set .modal-dialog { background-color: transparent; } in your active shell theme's gnome-shell.css."
fi

# ── Patch 4: icon cell size 168 → 140 ───────────────────────────────────────
sudo sed -i 's/168 \* 3/140 * 3/g; s/168 \* 7/140 * 7/g; s|\/ 168) \* 168|/ 140) * 140|g; s/168px/140px/g' "$APP_JS"
sudo sed -i 's/width: 504px/width: 480px/' "$APP_JS"
info "Icon cell size updated"

# ── Restart GNOME Shell ──────────────────────────────────────────────────────
info "Restarting GNOME Shell..."
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Applying Modern App Overlay…")' 2>/dev/null || \
    warn "Could not auto-restart (Wayland?). Please log out and back in."

echo ""
echo "  ✅  Done! Open your app launcher to see the changes."
echo "  To undo everything: ./uninstall.sh"
echo ""
