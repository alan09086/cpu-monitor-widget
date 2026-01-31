# Git Workflow for CPU Monitor Widget

## Repository Info

- **Location**: `~/projects/cpu-monitor/`
- **Branch**: `main`
- **Initial Commit**: 4b2cccb
- **Git Config**: Local (not global)
  - User: Alan
  - Email: alan@plex-server.local

## Quick Commands

### View History
```bash
cd ~/projects/cpu-monitor
git log --oneline
git log --oneline --graph --decorate
git show HEAD
```

### Check Status
```bash
git status
git diff
git diff --staged
```

### Making Changes

#### After modifying files:
```bash
# 1. Check what changed
git status
git diff

# 2. Stage specific files
git add BUILD.md README.md
# OR stage all changes
git add -A

# 3. Commit with message
git commit -m "Update documentation

- Updated README with new installation steps
- Fixed typo in BUILD.md

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# 4. View commit
git log -1
```

#### Quick commit workflow:
```bash
git add -A && git commit -m "Your commit message here"
```

### Tagging Releases

#### Create a version tag:
```bash
git tag -a v1.0 -m "Release version 1.0"
git tag -l  # List all tags
```

#### For future releases:
```bash
# Update VERSION.txt and metadata.json first
git add VERSION.txt com.plasmawidget.cpumonitor/metadata.json
git commit -m "Bump version to 1.1"
git tag -a v1.1 -m "Release version 1.1"
```

### Viewing Changes

#### Show files in last commit:
```bash
git show --name-only HEAD
```

#### Show what changed in a file:
```bash
git log -p -- README.md
```

#### Compare versions:
```bash
git diff v1.0 v1.1
git diff HEAD~1 HEAD  # Compare last 2 commits
```

### Branches (Future Development)

#### Create feature branch:
```bash
git checkout -b feature/temperature-monitoring
# Make changes
git add -A
git commit -m "Add temperature monitoring feature"
git checkout main
git merge feature/temperature-monitoring
```

#### List branches:
```bash
git branch -a
```

### Undoing Changes

#### Discard unstaged changes:
```bash
git restore FILE.md
# OR for all files
git restore .
```

#### Unstage a file:
```bash
git restore --staged FILE.md
```

#### Amend last commit (before pushing):
```bash
git add forgotten-file.md
git commit --amend --no-edit
# OR with new message
git commit --amend -m "New commit message"
```

### Remote Repository (Optional)

#### Add GitHub remote:
```bash
git remote add origin git@github.com:yourusername/cpu-monitor-widget.git
git push -u origin main
git push --tags  # Push version tags
```

#### Add local backup remote:
```bash
git remote add backup /path/to/backup/location
git push backup main
```

#### View remotes:
```bash
git remote -v
```

## Commit Message Format

Use this format for consistency:

```
Brief summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain what changed and why, not how (the diff shows how).

- Bullet points for multiple changes
- Another change
- Yet another change

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## Common Workflows

### After Building New .plasmoid Package

```bash
cd ~/projects/cpu-monitor
zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/
git add cpu-monitor.plasmoid
git commit -m "Rebuild package for version 1.0"
```

### After Modifying Source Code

```bash
# 1. Edit files in com.plasmawidget.cpumonitor/
# 2. Test changes
# 3. Rebuild package
zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/

# 4. Update backups
cp com.plasmawidget.cpumonitor/contents/code/cpuinfo.py source-backup/
cp com.plasmawidget.cpumonitor/contents/ui/main.qml source-backup/
cp com.plasmawidget.cpumonitor/metadata.json source-backup/

# 5. Commit everything
git add -A
git commit -m "Update widget: [describe changes]"
```

### Creating a Release

```bash
# 1. Update version in metadata.json
# 2. Update VERSION.txt
# 3. Update README.md changelog
git add VERSION.txt com.plasmawidget.cpumonitor/metadata.json README.md
git commit -m "Bump version to 1.1"

# 4. Create tag
git tag -a v1.1 -m "Release version 1.1

New features:
- Feature 1
- Feature 2

Bug fixes:
- Fix 1
- Fix 2"

# 5. View release
git show v1.1
```

## .gitignore

Current ignored patterns:
- Build artifacts (*.plasmoid.zip, build/, dist/)
- Python cache (__pycache__/, *.pyc)
- IDE files (.vscode/, .idea/, *.swp)
- OS files (.DS_Store, Thumbs.db)
- Temporary files (*.tmp, *.bak)

## Repository Statistics

```bash
# Count commits
git rev-list --count HEAD

# Count files tracked
git ls-files | wc -l

# Show contributors
git shortlog -sn

# Repository size
du -sh .git

# File changes over time
git log --stat
```

## Backup Strategy

### Option 1: Remote Git Server
```bash
git remote add github git@github.com:username/cpu-monitor.git
git push -u github main --tags
```

### Option 2: Local Backup
```bash
# Clone to another location
git clone ~/projects/cpu-monitor ~/backups/cpu-monitor-backup

# Or use remote
git remote add backup ~/backups/cpu-monitor.git
git push backup main
```

### Option 3: Archive
```bash
# Create timestamped archive
git archive --format=zip --output=cpu-monitor-$(date +%Y%m%d).zip HEAD
```

## Tips

- Commit early and often
- Write descriptive commit messages
- Tag all releases
- Keep .gitignore updated
- Don't commit generated files (like .plasmoid if rebuilt often)
- Review changes before committing (`git diff`)
- Use branches for experimental features

## Useful Aliases (Optional)

Add to `.git/config`:
```ini
[alias]
    st = status
    ci = commit
    br = branch
    co = checkout
    df = diff
    lg = log --oneline --graph --decorate --all
    last = log -1 HEAD
```

Then use: `git st`, `git lg`, etc.

## Integration with Claude Code

When working with Claude Code:
```bash
# After Claude makes changes
git status  # See what changed
git diff    # Review changes
git add -A  # Stage if approved
git commit -m "Description of changes

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

**Happy versioning!** 🚀
