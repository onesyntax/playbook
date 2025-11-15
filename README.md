# OneSyntax Playbook
**The definitive guide to building quality software at OneSyntax**

Version: 1.0  
Last Updated: November 2025  
Owner: Kalpa (CEO)

---

## What This Is

This playbook contains everything you need to know about how we develop software at OneSyntax:

- **Why we exist** and what we stand for
- **Standards** for DDD, Clean Architecture, and testing
- **Processes** for code review, enforcement, and quality
- **People development** - training and career growth
- **Execution plans** for implementing our system
- **Tools** and automation we use

This is not optional reading. Your success at OneSyntax depends on understanding and following this playbook.

---

## 🚀 Quick Start - Choose Your Path

**🆕 I'm new here**
→ [2-minute overview](1-mission/why-we-exist.md) then [onboarding checklist](#for-new-team-members)

**💻 I need to code something**
→ [Development standards](2-standards/development-system.md) | [Code review checklist](3-processes/code-review.md)

**📚 I want deep understanding**
→ [Reference library](#-reference-library-deep-dives) (comprehensive guides)

**🎯 Looking for something specific?**
- Code review checklist → [Code Review](3-processes/code-review.md)
- Career growth → [Career Framework](4-people/career.md)
- Quality initiative → [90-Day Plan](5-execution/90-day-plan.md)
- Setting up tools → [Enforcement Setup](6-tools/enforcement-setup.md)
- Architecture patterns → [Architecture Guide](reference/architecture-guide.md)
- Rewards & recognition → [Rewards Program](reference/rewards-program.md)

---

## What's Inside

### 🎯 Mission
**Why OneSyntax exists and what we believe**

- [Why We Exist](1-mission/why-we-exist.md) - Our Golden Circle (WHY, HOW, WHAT)
- [Our Values](1-mission/our-values.md) - 7 core values that guide our work

*Start here to understand our purpose and principles*

---

### 📐 Standards
**How we build software**

- [Development System](2-standards/development-system.md) - Complete guide to:
  - Domain-Driven Design (DDD)
  - Clean Architecture
  - Test-Driven Development (TDD)

*The technical foundation of everything we do*

---

### ⚙️ Processes
**How we maintain quality**

- [Enforcement](3-processes/enforcement.md) - 3-layer quality system
- [Code Review](3-processes/code-review.md) - Review checklist and process

*Systems that keep us honest*

---

### 👥 People
**How we learn and grow**

- [Training](4-people/training.md) - 12-week deliberate practice program
- [Career](4-people/career.md) - Career progression from IC1 to IC5/M4

*Your path to excellence*

---

### 🚀 Execution
**How we implement change**

- [90-Day Plan](5-execution/90-day-plan.md) - Complete quality initiative rollout
  - Week-by-week execution
  - Client communication
  - Risk management
  - Success metrics

*Ready-to-launch implementation guide*

---

### 🛠️ Tools
**Automation and enforcement**

- [Enforcement Setup](6-tools/enforcement-setup.md) - ArchUnit, linters, CI/CD

*Making good architecture the default path*

---

### 📋 Quick Reference (Cheat Sheets)
**One-page guides to print and keep at your desk**

Your daily tools for excellence:

- [DDD Checklist](quick-reference/ddd-checklist.md) - Entities, Value Objects, Aggregates quick reference
- [Code Review Checklist](quick-reference/code-review-checklist.md) - Author and reviewer checklists
- [Clean Architecture Cheatsheet](quick-reference/clean-architecture-cheatsheet.md) - Layer structure and dependency rules

*Print these! Keep them visible! Use them daily!*

**Pro tip:** Review the appropriate checklist before every PR.

---

### 📖 Reference Library (Deep Dives)
**Comprehensive guides for deep understanding**

When practical guides aren't enough and you need complete context:

- [Architecture Guide](reference/architecture-guide.md) - Complete Laravel Clean Architecture reference
- [System Deep Dive](reference/system-deep-dive.md) - Full DDD + Clean Architecture + TDD system (1,647 lines)
- [Enforcement Deep Dive](reference/enforcement-deep-dive.md) - Complete enforcement & accountability system (2,698 lines)
- [Execution Complete](reference/execution-complete.md) - Full 6-month execution plan with budget details
- [Promotion Framework](reference/promotion-framework.md) - Comprehensive career progression guide
- [Rewards Program](reference/rewards-program.md) - Complete rewards & recognition program

*These are your "deep dive" resources when you need full context and philosophy*

**Pro tip:** Start with practical guides in numbered directories, then consult reference library when you need more detail.

---

## Repository Structure

```
onesyntax-playbook/
├── README.md                    # You are here (start here!)
├── SETUP.md                     # Setup instructions
├── setup.sh                     # Quick setup script
│
├── 1-mission/                   # Why we exist
│   ├── why-we-exist.md         # Golden Circle (WHY, HOW, WHAT)
│   └── our-values.md           # Core values
│
├── 2-standards/                 # What we build
│   └── development-system.md   # DDD + Clean Architecture + TDD
│
├── 3-processes/                 # How we work
│   ├── enforcement.md          # Quality enforcement
│   └── code-review.md          # Code review process
│
├── 4-people/                    # How we grow
│   ├── training.md             # 12-week program
│   └── career.md               # Career framework
│
├── 5-execution/                 # How we implement
│   └── 90-day-plan.md          # Quality initiative
│
├── 6-tools/                     # What we use
│   └── enforcement-setup.md    # ArchUnit, linters, CI/CD
│
├── quick-reference/             # Printable cheat sheets
│   ├── ddd-checklist.md        # DDD patterns quick reference
│   ├── code-review-checklist.md # Code review guide
│   └── clean-architecture-cheatsheet.md # CA layers & rules
│
└── reference/                   # Deep dive guides
    ├── architecture-guide.md   # Laravel Clean Architecture
    ├── system-deep-dive.md     # Complete DDD/CA/TDD guide
    ├── enforcement-deep-dive.md # Full enforcement system
    ├── execution-complete.md   # 6-month execution plan
    ├── promotion-framework.md  # Complete career guide
    └── rewards-program.md      # Rewards & recognition
```

**📌 Navigation:**
- **Numbers (1-6)** → Recommended reading order for practical guides
- **quick-reference/** → Printable cheat sheets for daily use
- **reference/** → Deep dives when you need comprehensive coverage

---

## Contributing

This playbook is a living document. If you find:
- Unclear explanations
- Outdated information
- Missing content
- Better examples

**Process:**
1. Create a branch
2. Make your changes
3. Submit PR to Kalpa or senior developers
4. Get approval
5. Merge to main

See our [Code Review](processes/code-review.md) process for details.

---

## Getting Started

### For New Team Members

**Week 1:**
- [ ] Read [Why We Exist](1-mission/why-we-exist.md)
- [ ] Read [Our Values](1-mission/our-values.md)
- [ ] Skim [Development System](2-standards/development-system.md)

**Week 2:**
- [ ] Deep dive [Development System](2-standards/development-system.md)
- [ ] Start [Training Program](4-people/training.md)
- [ ] Review [Code Review](3-processes/code-review.md) checklist

**Week 3:**
- [ ] Complete first training exercises
- [ ] Participate in code reviews
- [ ] Apply standards in real work

**Week 4+:**
- [ ] Continue deliberate practice
- [ ] Master the standards
- [ ] Help onboard others

---

### For Existing Team Members

If you're part of the quality initiative:

**Week -1:**
- [ ] Read entire playbook
- [ ] Review [90-Day Plan](5-execution/90-day-plan.md)
- [ ] Prepare questions for launch meeting

**Week 1:**
- [ ] Attend all-hands kickoff
- [ ] Start training program
- [ ] Set up enforcement tools

**Weeks 2-13:**
- [ ] Follow [90-Day Plan](5-execution/90-day-plan.md)
- [ ] Complete training exercises
- [ ] Apply standards to projects

---

## Philosophy

> "This playbook exists to support OneSyntax's mission of true partnership through accountable, professional development."

Our standards aren't about perfection - they're about partnership. When we build software right, we honor our clients' trust and investment.

Every standard connects to our **WHY:**
- **DDD** → Understanding client's business (true partnership)
- **Clean Architecture** → Systems that last (honoring trust)
- **TDD** → Quality from day one (professional delivery)
- **Enforcement** → Discipline that protects (accountability)

---

## Questions?

- **Slack:** #architecture
- **Owner:** Kalpa
- **Email:** kalpa@onesyntax.com

**Want to discuss a standard?** Weekly architecture review meetings (Thursdays)

**Need clarification?** Ask in #architecture or your 1:1s

**Found an issue?** Open a PR or bring it up in retrospectives

---

## Setup Instructions

**To push this playbook to GitHub:**

1. Run the setup script:
   ```bash
   ./setup.sh
   ```

2. Or manually:
   ```bash
   git init
   git add .
   git commit -m "feat: Initial OneSyntax Playbook"
   git remote add origin https://github.com/YOUR_USERNAME/onesyntax-playbook.git
   git branch -M main
   git push -u origin main
   ```

3. Set up branch protection (Settings → Branches → Add rule)

See full setup instructions in comments at top of `setup.sh`

---

## Remember

**Let's build software that matters. Together.** 💪

---

*This playbook is your guide to excellence at OneSyntax. Use it. Share it. Improve it.*
