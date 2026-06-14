# chezmoi Operations Reference

chezmoi manages configuration files in this repository. The source tree lives at
`~/.local/share/chezmoi/` (this repository); `chezmoi apply` deploys source →
live (`dot_` prefix → `.`, e.g. `dot_config/` → `~/.config/`).

---

## Edit a managed file

```sh
# Edit and apply in one step
chezmoi edit --apply ~/.config/zsh/.zshrc

# Or edit then review before applying
chezmoi edit ~/.config/zsh/.zshrc
chezmoi diff
chezmoi apply
```

After editing, commit and push:

```sh
chezmoi git add -- .
chezmoi git commit -- -m "..."
chezmoi git push
```

---

## Add a new file to chezmoi management

```sh
# Copy a live file into the source
chezmoi add ~/.config/foo/bar

# Verify the source was created
chezmoi status

# Commit and push
chezmoi git add -- .
chezmoi git commit -- -m "..."
chezmoi git push
```

---

## Pull and apply changes from another machine

```sh
chezmoi update
```

---

## Check status and diff

```sh
chezmoi status              # list differences between source and live
chezmoi diff                # show what chezmoi apply would change
chezmoi diff ~/.config/...  # diff for a specific file
```

`chezmoi status` symbols:

| Symbol | Meaning |
|--------|---------|
| `M` | Source is newer than live (will be updated on apply) |
| `A` | Exists in source but not in live (will be created on apply) |
| `D` | Removed from source (will be deleted from live on apply) |
| `R` | `run_onchange_` script is pending execution |

