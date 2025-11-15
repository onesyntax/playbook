# OneSyntax Playbook Setup Guide

## Quick Start (5 minutes)

This guide will help you set up the OneSyntax Playbook repository on GitHub.

---

## Step 1: Create GitHub Repository (2 minutes)

1. Go to https://github.com/new
2. Fill in:
   - **Repository name:** `onesyntax-playbook`
   - **Description:** "The definitive guide to building quality software at OneSyntax"
   - **Visibility:** Private (recommended)
   - **DO NOT** initialize with README, .gitignore, or license (we have these)
3. Click "Create repository"

---

## Step 2: Initialize Local Repository (1 minute)

Open terminal in the `onesyntax-playbook` directory and run:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create first commit
git commit -m "feat: Initial OneSyntax Playbook

- Add mission and values (why we exist)
- Add development standards (DDD + Clean Architecture + TDD)
- Add quality processes (enforcement + code review)
- Add people development (training + career framework)
- Add execution plan (90-day quality initiative)
- Add tools setup (ArchUnit + linters)

This playbook establishes OneSyntax standards and provides
clear path for team growth and quality delivery."
```

---

## Step 3: Connect to GitHub (1 minute)

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username:

```bash
# Add remote
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/onesyntax-playbook.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## Step 4: Configure Branch Protection (1 minute)

1. Go to your repo on GitHub
2. Settings → Branches → Add rule
3. Branch name pattern: `main`
4. Enable:
   - ✅ Require pull request before merging
   - ✅ Require approvals: 1
   - ✅ Include administrators
5. Save changes

---

## Repository Structure

```
onesyntax-playbook/
├── README.md              # Main navigation
├── setup.sh               # Automated setup script
├── .gitignore             # Git ignore rules
│
├── 1-mission/             # Why we exist
│   ├── why-we-exist.md   # Golden Circle (WHY, HOW, WHAT)
│   └── our-values.md     # 7 core values
│
├── 2-standards/           # What we build
│   └── development-system.md  # DDD + CA + TDD
│
├── 3-processes/           # How we work
│   ├── enforcement.md    # Quality enforcement
│   └── code-review.md    # Review process
│
├── 4-people/              # How we grow
│   ├── training.md       # 12-week program
│   └── career.md         # Career framework
│
├── 5-execution/           # How we implement
│   └── 90-day-plan.md    # Quality initiative
│
└── 6-tools/               # What we use
    └── enforcement-setup.md  # ArchUnit + linters
```

---

## What's Included

✅ **11 Complete Documents:**
- Mission & values (2)
- Development standards (1)
- Processes (2)
- People development (2)
- Execution plan (1)
- Tools (1)
- Infrastructure (2: README + setup script)

✅ **Professional Structure:**
- Clear organization
- No unnecessary nesting
- Easy to navigate
- Room to grow

✅ **Ready to Use:**
- Can launch Week 1 immediately
- All essential content complete
- Git-ready

---

## Next Steps

After setup:

1. **Share with team** → Send GitHub URL
2. **Review content** → Make sure everyone reads mission/values
3. **Start Week 1** → Begin quality initiative
4. **Grow playbook** → Add more content as needed

---

## Adding New Content

**Where to add what:**

- New values/principles → `1-mission/`
- Coding patterns → `2-standards/`
- Process documentation → `3-processes/`
- Training materials → `4-people/`
- Implementation guides → `5-execution/`
- Tool configurations → `6-tools/`

**Numbers show recommended reading order.**

---

## Maintenance

**Weekly:**
- Review and merge approved PRs
- Update based on learnings

**Monthly:**
- Add examples from real work
- Fix broken links
- Update metrics

**Quarterly:**
- Major review with team
- Incorporate feedback
- Archive outdated content

---

## Questions?

- **Setup issues:** Check GitHub documentation
- **Content questions:** #architecture channel
- **Access issues:** Kalpa or HR

---

**Congratulations! Your simplified OneSyntax Playbook is ready! 🚀**

**Let's build software that matters. Together.**
