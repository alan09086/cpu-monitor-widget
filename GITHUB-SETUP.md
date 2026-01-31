# Linking to Online Git Repository

This guide covers how to push your CPU Monitor Widget to GitHub, GitLab, or other git hosting services.

## Option 1: GitHub (Most Popular)

### Step 1: Create Repository on GitHub

1. Go to https://github.com/new
2. Fill in details:
   - **Repository name**: `cpu-monitor-widget` (or your choice)
   - **Description**: "A vibrant KDE Plasma 6 widget for real-time system monitoring"
   - **Visibility**: Public (for sharing) or Private (for personal use)
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
3. Click "Create repository"

### Step 2: Link Local Repository to GitHub

```bash
cd ~/projects/cpu-monitor

# Add GitHub as remote (replace USERNAME with your GitHub username)
git remote add origin git@github.com:USERNAME/cpu-monitor-widget.git

# Verify remote was added
git remote -v
```

### Step 3: Push to GitHub

```bash
# Push main branch and set upstream
git push -u origin main

# Push any tags (for releases)
git push --tags
```

### Step 4: Verify

Visit: `https://github.com/USERNAME/cpu-monitor-widget`

You should see all your files and commits!

---

## Option 2: Using HTTPS Instead of SSH

If you haven't set up SSH keys with GitHub:

```bash
# Use HTTPS URL instead
git remote add origin https://github.com/USERNAME/cpu-monitor-widget.git

# You'll be prompted for username and password/token when pushing
git push -u origin main
```

**Note**: GitHub now requires Personal Access Tokens instead of passwords.

### Create GitHub Personal Access Token:
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: "CPU Monitor Widget"
4. Select scopes: `repo` (full control of private repositories)
5. Click "Generate token"
6. **SAVE THE TOKEN** - you won't see it again!
7. Use this token as your password when pushing

---

## Option 3: GitHub CLI (Easiest!)

If you have `gh` installed:

```bash
cd ~/projects/cpu-monitor

# Authenticate (first time only)
gh auth login

# Create repo and push in one command
gh repo create cpu-monitor-widget --public --source=. --push

# Or for private repo
gh repo create cpu-monitor-widget --private --source=. --push
```

This automatically:
- Creates the repository on GitHub
- Adds the remote
- Pushes your code

---

## Option 4: GitLab

### Step 1: Create Project on GitLab
1. Go to https://gitlab.com/projects/new
2. Click "Create blank project"
3. Fill in:
   - **Project name**: `cpu-monitor-widget`
   - **Visibility**: Public or Private
   - **DO NOT** initialize with README
4. Click "Create project"

### Step 2: Link and Push

```bash
cd ~/projects/cpu-monitor

# Add GitLab as remote
git remote add origin git@gitlab.com:USERNAME/cpu-monitor-widget.git

# Push
git push -u origin main
git push --tags
```

---

## Option 5: Self-Hosted Git (Gitea, Forgejo, etc.)

```bash
cd ~/projects/cpu-monitor

# Add your self-hosted git server
git remote add origin git@your-server.com:username/cpu-monitor-widget.git

# Push
git push -u origin main
```

---

## Setting Up SSH Keys (Recommended)

SSH keys allow you to push without entering passwords.

### Generate SSH Key (if you don't have one)

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "alan.c.gaudet@gmail.com"

# Press Enter to accept default location (~/.ssh/id_ed25519)
# Enter passphrase (optional but recommended)

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
```

### Add SSH Key to GitHub

1. Go to: https://github.com/settings/keys
2. Click "New SSH key"
3. Title: "Plex Server - CachyOS"
4. Paste the public key from `~/.ssh/id_ed25519.pub`
5. Click "Add SSH key"

### Test SSH Connection

```bash
# GitHub
ssh -T git@github.com
# Should say: "Hi USERNAME! You've successfully authenticated..."

# GitLab
ssh -T git@gitlab.com
```

---

## After Setting Up Remote

### Daily Workflow

```bash
# Make changes to files
# ...

# Stage and commit
git add -A
git commit -m "Your commit message"

# Push to GitHub/GitLab
git push
```

### Pull Changes (if working from multiple machines)

```bash
git pull
```

### Check Remote Status

```bash
# View configured remotes
git remote -v

# See remote branches
git branch -r

# Compare local vs remote
git status
```

---

## Multiple Remotes

You can push to multiple services:

```bash
# Add GitHub
git remote add github git@github.com:USERNAME/cpu-monitor-widget.git

# Add GitLab
git remote add gitlab git@gitlab.com:USERNAME/cpu-monitor-widget.git

# Add backup
git remote add backup git@backup-server.com:repos/cpu-monitor.git

# Push to specific remote
git push github main
git push gitlab main
git push backup main

# Or push to all
git remote | xargs -L1 git push --all
```

---

## Repository Settings

### After Pushing to GitHub

Consider configuring:

1. **Add Topics**: Settings → Topics → Add: `kde-plasma`, `widget`, `system-monitor`, `qml`, `python`
2. **Set Description**: "A vibrant KDE Plasma 6 widget for real-time system monitoring"
3. **Add Website**: Link to KDE Store page if you publish there
4. **Enable Issues**: For bug reports and feature requests
5. **Create Releases**:
   - Go to Releases → Create a new release
   - Tag: `v1.0`
   - Title: "CPU Monitor Widget v1.0"
   - Upload `cpu-monitor.plasmoid` as release asset
   - Copy description from DISTRIBUTION-DESCRIPTION.txt

### Set Up GitHub Pages (Optional)

To create a project website:

1. Settings → Pages
2. Source: Deploy from a branch
3. Branch: `main` → `/docs`
4. Create `/docs/index.html` with project info

---

## Troubleshooting

### "Repository already exists"
If you accidentally initialized the GitHub repo with README:
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Permission Denied (SSH)
- Check SSH key is added to GitHub: `ssh -T git@github.com`
- Make sure you're using the correct remote URL: `git remote -v`

### "Failed to push some refs"
```bash
# Fetch and merge remote changes first
git pull --rebase origin main
git push -u origin main
```

### Change Remote URL
```bash
# View current remote
git remote -v

# Change to SSH
git remote set-url origin git@github.com:USERNAME/cpu-monitor-widget.git

# Change to HTTPS
git remote set-url origin https://github.com/USERNAME/cpu-monitor-widget.git
```

---

## Quick Reference

```bash
# Add remote
git remote add origin URL

# Push first time
git push -u origin main

# Push after commits
git push

# Pull changes
git pull

# View remotes
git remote -v

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin github
```

---

## Next Steps After Pushing

1. **Share the link**: Send GitHub URL to others
2. **Create release**: Tag v1.0 and upload .plasmoid file
3. **Add badge to README**:
   ```markdown
   ![GitHub release](https://img.shields.io/github/v/release/USERNAME/cpu-monitor-widget)
   ```
4. **Enable Actions**: Set up automated testing (optional)
5. **Add license**: Create LICENSE file (MIT, GPL, etc.)
6. **Submit to KDE Store**: Share with KDE community

---

Ready to share your widget with the world! 🌍
