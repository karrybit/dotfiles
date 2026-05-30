# tmux Usage

## Prefix Key

Changed from the default `Ctrl+b` to **`Ctrl+t`**.

`<prefix>` = `Ctrl+t` throughout this document.

---

## Sessions

| Action | Key / Command |
|--------|---------------|
| New session | `tmux new -s <name>` |
| List sessions | `tmux ls` |
| Attach to session | `tmux attach -t <name>` |
| Detach from session | `<prefix> d` |
| List & switch sessions | `<prefix> s` |
| Rename session | `<prefix> $` |

---

## Windows

| Action | Key |
|--------|-----|
| New window | `<prefix> c` |
| Next window | `<prefix> n` |
| Previous window | `<prefix> p` |
| Go to window by number | `<prefix> <number>` |
| List windows | `<prefix> w` |
| Rename window | `<prefix> ,` |
| Close window | `<prefix> &` |
| Move window left | `<prefix> <` |
| Move window right | `<prefix> >` |

> Windows are numbered from 1 and automatically renumbered after closing.

---

## Panes (tmux-pain-control)

### Splitting

| Action | Key |
|--------|-----|
| Split left/right | `<prefix> \|` |
| Split top/bottom | `<prefix> -` |
| Split left/right (full width) | `<prefix> \` |
| Split top/bottom (full height) | `<prefix> _` |

### Navigation (vim keys)

| Action | Key |
|--------|-----|
| Focus left pane | `<prefix> h` |
| Focus lower pane | `<prefix> j` |
| Focus upper pane | `<prefix> k` |
| Focus right pane | `<prefix> l` |

### Resizing

| Action | Key |
|--------|-----|
| Expand left | `<prefix> H` |
| Expand down | `<prefix> J` |
| Expand up | `<prefix> K` |
| Expand right | `<prefix> L` |

### Other

| Action | Key |
|--------|-----|
| Close pane | `<prefix> x` |
| Zoom / unzoom pane | `<prefix> z` |

---

## Copy Mode (vi keys)

| Action | Key |
|--------|-----|
| Enter copy mode | `<prefix> [` |
| Move cursor | `h` / `j` / `k` / `l` |
| Start selection | `v` |
| Copy | `y` |
| Paste | `<prefix> ]` |
| Exit copy mode | `q` |

---

## Sidebar (tmux-sidebar)

| Action | Key |
|--------|-----|
| Toggle sidebar (file tree) | `<prefix> Tab` |
| Focus sidebar | `<prefix> Backspace` |

---

## Open Files & URLs (tmux-open)

With text selected in copy mode:

| Action | Key |
|--------|-----|
| Open with default app | `o` |
| Open with `$EDITOR` | `Ctrl+o` |
| Search with Google | `S` |

---

## Miscellaneous

| Action | Key |
|--------|-----|
| Reload config | `<prefix> r` |
| Command prompt | `<prefix> :` |
| List key bindings | `<prefix> ?` |

---

## Plugins (TPM)

| Action | Key |
|--------|-----|
| Install plugins | `<prefix> I` |
| Update plugins | `<prefix> U` |
| Remove unused plugins | `<prefix> Alt+u` |

> Plugins are auto-installed on first launch if not present.

### Installed Plugins

| Plugin | Description |
|--------|-------------|
| tmux-plugins/tpm | Plugin manager |
| arcticicestudio/nord-tmux | Nord color theme |
| tmux-plugins/tmux-prefix-highlight | Status bar indicator for prefix / copy / sync mode |
| tmux-plugins/tmux-sensible | Sensible default settings |
| tmux-plugins/tmux-pain-control | Enhanced pane keybindings |
| tmux-plugins/tmux-sidebar | File tree sidebar |
| tmux-plugins/tmux-open | Open files and URLs from copy mode |
