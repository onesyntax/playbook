# XP Practices Quick Reference
**One-page guide to OneSyntax XP practices**

Print this. Keep it visible. Use it daily.

---

## 🤝 Collaboration Practices

### Pair Programming
**When to pair:**
- [ ] Complex features requiring design decisions
- [ ] Learning new domains or technologies
- [ ] Debugging critical production issues
- [ ] Senior/junior knowledge transfer

**Quick tips:**
- Switch driver/navigator every 25 minutes
- Keep sessions under 3 hours
- Both programmers equally engaged
- Communicate constantly

→ Full guide: [3-processes/pair-programming.md](../3-processes/pair-programming.md)

---

### Collective Ownership
**Anyone can improve any code**

**Before touching others' code:**
- [ ] Read and understand the code first
- [ ] Have tests in place or write them
- [ ] Follow existing patterns and style
- [ ] Leave it better than you found it

**Remember:** You own quality when you touch code

→ Full guide: [3-processes/collective-ownership.md](../3-processes/collective-ownership.md)

---

### Whole Team (Three Amigos)
**Dev + PM + QA/Designer collaboration**

**When to run Three Amigos:**
- [ ] Before starting any new feature
- [ ] When acceptance criteria unclear
- [ ] When technical approach impacts UX
- [ ] When estimating complex stories

**Meeting format:**
1. PM explains business need (5 min)
2. Dev outlines technical approach (5 min)
3. QA/Designer asks edge case questions (5 min)
4. Together write acceptance criteria (10 min)

→ Full guide: [4-people/whole-team.md](../4-people/whole-team.md)

---

## 📅 Planning Practices

### Planning Game (Sprint Planning)
**2-week sprints at OneSyntax**

**Sprint Planning Agenda (2 hours):**
1. Review last sprint (15 min)
2. PM presents priorities (20 min)
3. Team estimates stories (60 min)
4. Commit to sprint scope (20 min)
5. Identify risks and dependencies (5 min)

**Estimation scale:** 1, 2, 3, 5, 8, 13 (Fibonacci)
- 1-2 points: Less than a day
- 3-5 points: 1-2 days
- 8 points: 3-4 days
- 13 points: Split the story!

→ Full guide: [3-processes/planning-game.md](../3-processes/planning-game.md)

---

### Small Releases
**Deploy every 2 weeks minimum**

**Pre-deployment checklist:**
- [ ] All tests passing (unit + integration + acceptance)
- [ ] Code reviewed and approved
- [ ] Feature flags configured if needed
- [ ] Rollback plan documented
- [ ] Stakeholders notified

**Quality gates:**
- Unit test coverage > 80%
- No critical ArchUnit violations
- No high-severity linting errors

→ Full guide: [3-processes/small-releases.md](../3-processes/small-releases.md)

---

## 🎯 Quality Practices

### Acceptance Tests (Given-When-Then)
**Customer-facing test format**

**Template:**
```gherkin
Given [initial context]
When [action occurs]
Then [expected outcome]
```

**Example:**
```gherkin
Given a user has an active subscription
When they click "Cancel Subscription"
Then they see a confirmation dialog
And their subscription is marked for cancellation
And they receive a cancellation email
```

**Who writes what:**
- PM/Client: Business scenarios (what)
- QA: Test cases and edge cases
- Dev: Implementation and automation

→ Full guide: [2-standards/acceptance-tests.md](../2-standards/acceptance-tests.md)

---

### Simple Design
**Do the simplest thing that could possibly work**

**Four rules (in order):**
1. Passes all tests
2. Reveals intention (readable code)
3. No duplication (DRY)
4. Minimal elements (no speculative code)

**When to apply YAGNI:**
- [ ] Building features "just in case"
- [ ] Over-engineering simple logic
- [ ] Premature optimization
- [ ] Gold plating

**When NOT to skip architecture:**
- DDD patterns for core domain logic
- Clean Architecture layers
- Test coverage requirements
- Security and data protection

→ Full guide: [2-standards/simple-design.md](../2-standards/simple-design.md)

---

## 👥 People Practices

### Sustainable Pace
**40 hours/week average**

**Warning signs of burnout:**
- [ ] Working 50+ hours/week for 2+ weeks
- [ ] Skipping breaks or lunch
- [ ] Working weekends regularly
- [ ] Decreased code quality
- [ ] Irritability or disengagement

**What to do:**
1. Talk to your manager immediately
2. Review sprint commitments
3. Identify what to defer
4. Take time off if needed

**Manager responsibilities:**
- Protect team from overcommitment
- Monitor hours and wellbeing
- Adjust scope, not people
- Model healthy work habits

→ Full guide: [4-people/sustainable-pace.md](../4-people/sustainable-pace.md)

---

## 🎯 Quick Decision Flowchart

```
Starting a new feature?
├─ Complex or unfamiliar? → Pair program
├─ Clear requirements? NO → Schedule Three Amigos
├─ Ready to code? → Write acceptance tests first
├─ During development → Keep design simple (YAGNI)
├─ Before PR → Run code review checklist
└─ Every 2 weeks → Deploy to production
```

---

## 📊 Weekly Team Health Check

**Every Friday, ask yourself:**
- [ ] Did I pair with someone this week?
- [ ] Did I participate in Three Amigos sessions?
- [ ] Did I work reasonable hours (≤45/week)?
- [ ] Did I help improve code I didn't write?
- [ ] Are we on track for 2-week release?
- [ ] Did I write acceptance criteria for my stories?

**If 3+ are "No" → Talk to your manager**

---

## Remember

These practices support OneSyntax's mission:
**True partnership through accountable professional development**

- Pair programming → Knowledge sharing (partnership)
- Collective ownership → Shared responsibility (accountability)
- Whole team → Client collaboration (partnership)
- Sustainable pace → Long-term quality (professional)
- Small releases → Consistent delivery (accountability)

---

## Questions?

- **Slack:** #architecture
- **Owner:** Kalpa
- **Email:** kalpa@onesyntax.com

**Full playbook:** [README.md](../README.md)

---

*Version 1.0 | Last Updated: November 2025*
