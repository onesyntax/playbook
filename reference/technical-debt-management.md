# Technical Debt Management
## Tracking, Prioritizing, and Paying Down Tech Debt

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Tech debt is a tool, not a failure - manage it strategically

---

## Table of Contents

1. [What Is Technical Debt](#what-is-technical-debt)
2. [Types of Technical Debt](#types-of-technical-debt)
3. [Tech Debt Ledger](#tech-debt-ledger)
4. [Sprint Refactoring Budget](#sprint-refactoring-budget)
5. [Prioritization Framework](#prioritization-framework)
6. [Debt Paydown Process](#debt-paydown-process)
7. [When Debt Is Acceptable](#when-debt-is-acceptable)
8. [Red Flags](#red-flags)

---

## What Is Technical Debt

### Definition

**Technical debt:** Code that works but doesn't follow our standards (DDD + Clean Architecture + TDD), making future changes harder and slower.

**Like financial debt:**
- Taking debt = shipping faster now
- Interest = slower development later
- Principal = effort to fix it
- Bankruptcy = unmaintainable codebase

### The OneSyntax Perspective

**Tech debt is NOT:**
- ❌ Failure or laziness
- ❌ Always bad
- ❌ Something to hide
- ❌ Code written by "bad developers"

**Tech debt IS:**
- ✅ Strategic decision
- ✅ Sometimes necessary
- ✅ Must be tracked
- ✅ Should be planned for

**Examples of good tech debt:**
```php
// Urgent client demo Friday
// Proper refactoring would take 6 hours
// Quick solution takes 2 hours
// Decision: Take tech debt, ship demo, refactor next sprint
// Result: Client happy, debt tracked and paid down
```

### The Debt Metaphor

**Taking debt (creating tech debt):**
```
Value: Ship feature faster
Cost: Future changes harder
Interest: Pay every time you touch this code
Principal: Effort to refactor properly
```

**Example calculation:**
```
Quick solution: 2 hours
Proper solution: 6 hours
Savings: 4 hours NOW

But...
Every future change: +30% time (interest)
Expected future changes: 10 over next year
Interest paid: 10 changes × 30 min extra = 5 hours
Principal to fix: Still 6 hours

Total cost: 11 hours vs 6 hours if done right initially
```

**Decision:** Good debt if urgent value > long-term cost  
**Decision:** Bad debt if you never plan to pay it back

---

## Types of Technical Debt

### 1. Deliberate & Prudent (Strategic Tech Debt)

**What:** Consciously taking shortcuts for good reasons

**Examples:**
- Urgent client deadline
- Testing hypothesis (might throw away)
- Staged rollout (v1 simple, v2 proper)
- Learning domain (understand better later)

**Characteristics:**
- ✅ Documented decision
- ✅ Tracked in backlog
- ✅ Plan to pay back
- ✅ Cost-benefit makes sense

**Example:**
```php
// Decision: Use if/else for payment gateways now
// Reason: Only 2 gateways, proper abstraction overkill
// Plan: If we add 3rd gateway, extract pattern
// Tracked: Ticket #234 "Payment gateway abstraction"
```

---

### 2. Deliberate & Reckless (Dangerous Debt)

**What:** Shortcuts with no plan to fix

**Examples:**
- "We don't have time for tests"
- "Just hardcode it for now"
- "We'll fix it later" (but no plan)
- "Nobody will notice"

**Characteristics:**
- ❌ No documentation
- ❌ Not tracked
- ❌ No plan to fix
- ❌ Compounds quietly

**Example:**
```php
// Just ship it, we'll fix later (but no ticket)
// Skip tests (deadline pressure)
// Hardcode values (too lazy for config)
// Framework in domain layer (don't know better)
```

**This is the debt that kills projects.**

---

### 3. Accidental & Prudent (Learning Debt)

**What:** Did our best, but learned better approach later

**Examples:**
- Used wrong pattern (learning)
- Didn't know about value objects
- Misunderstood domain
- Better pattern emerged

**Characteristics:**
- 🟡 Done with good intent
- 🟡 Knowledge evolved
- 🟡 Should refactor now
- 🟡 Part of learning process

**Example:**
```php
// We wrote this 6 months ago following tutorials
// It works but we now know better patterns
// With current knowledge, we'd do it differently
// Not a failure - natural evolution
```

---

### 4. Accidental & Reckless (Incompetence Debt)

**What:** Bad code from lack of skill or care

**Examples:**
- No architectural boundaries
- No tests
- Copy-paste coding
- No understanding of domain

**Characteristics:**
- ❌ Should not have been written this way
- ❌ Requires education or removal
- ❌ High-priority fix

**Example:**
```php
// 1000-line God class
// SQL in controllers
// No validation
// No separation of concerns
// Written by someone who doesn't know better
```

**At OneSyntax:** Our enforcement system prevents this going forward.

---

## Tech Debt Ledger

### What to Track

**Every time you choose Option 3 (ship with debt), create a ledger entry.**

### Ledger Template

```markdown
# Technical Debt Ledger

## Active Debt

### [Priority: HIGH] Refactor OrderService to DDD Pattern
**Created:** 2024-11-15  
**By:** Sarah  
**Ticket:** #456  

**Context:**
- Added bulk discount feature
- Order logic scattered across 3 services
- Order entity is anemic
- No domain events

**The Problem:**
- 500 lines of logic in services
- Business rules not in domain layer
- Hard to add new discount types
- Tests are integration tests (should be unit)

**Proposed Solution:**
- Extract rich Order aggregate
- Create Discount value object
- Add domain events for order changes
- Move all pricing logic to domain

**Estimated Effort:** 6 hours

**Priority Criteria:**
- [x] Core domain (high priority)
- [x] Touched frequently (every 2-3 sprints)
- [x] Blocking new features (yes, discount system needs this)
- [ ] Causing bugs (not yet)
- [ ] Team confusion (somewhat)

**ROI Calculation:**
```
Fix time: 6 hours
Time saved per change: 1.5 hours
Expected changes per year: 12
Annual savings: 18 hours
Break-even: After 4 changes (10 months)
Priority: HIGH
```

**Debt Age:** 14 days  
**Interest Paid:** 2 hours (one feature took longer)  
**Status:** Scheduled for Sprint 12

---

### [Priority: MEDIUM] Extract Email Value Object
**Created:** 2024-11-10  
**By:** Mike  
**Ticket:** #423  

**Context:**
- Email validation scattered in 5 places
- String used instead of value object
- Inconsistent validation rules

**The Problem:**
- Duplicated validation logic
- No single source of truth
- Easy to forget validation

**Proposed Solution:**
- Create Email value object
- Centralize validation
- Update all uses

**Estimated Effort:** 3 hours

**Priority Criteria:**
- [ ] Core domain (supporting)
- [x] Touched frequently (yes)
- [ ] Blocking features (no)
- [ ] Causing bugs (not yet)
- [x] Team confusion (yes, which validation is correct?)

**ROI Calculation:**
```
Fix time: 3 hours
Time saved per change: 30 min
Expected changes per year: 8
Annual savings: 4 hours
Break-even: 9 months
Priority: MEDIUM
```

**Debt Age:** 19 days  
**Interest Paid:** 1 hour  
**Status:** Backlog

---

### [Priority: LOW] Admin Report SQL Optimization
**Created:** 2024-11-01  
**By:** David  
**Ticket:** #389  

**Context:**
- Admin report has 200-line SQL query
- Slow (5 seconds) but rarely used
- Works correctly

**The Problem:**
- Hard to maintain query
- No query builder/ORM
- Slow performance

**Proposed Solution:**
- Extract to query object
- Use query builder
- Optimize with indexes

**Estimated Effort:** 4 hours

**Priority Criteria:**
- [ ] Core domain (no, internal admin)
- [ ] Touched frequently (no, quarterly)
- [ ] Blocking features (no)
- [ ] Causing bugs (no)
- [ ] Team confusion (no, rarely touched)

**ROI Calculation:**
```
Fix time: 4 hours
Frequency: Quarterly
Time saved: Minimal
Break-even: Probably never
Priority: LOW (only if touched 3+ times)
```

**Debt Age:** 44 days  
**Interest Paid:** 0 hours  
**Status:** Backlog (low priority)
```

### Ledger Location

**Store in:**
- Notion page: "Technical Debt Ledger"
- GitHub issues with label: "tech-debt"
- Linked from project README

**Update:**
- When debt created
- When debt paid down
- When priority changes
- Monthly debt review

---

## Sprint Refactoring Budget

### The 20% Rule

**Every sprint:**
```
Total capacity: 80 hours (2 devs × 40 hours)
├─ New features: 60 hours (75%)
├─ Refactoring: 16 hours (20%)
└─ Overhead: 4 hours (5%)
```

**That 16 hours for refactoring:**
- 10 hours: Tidy as you go (small refactorings before features)
- 6 hours: Pay down 1-2 tech debt tickets

**This is mandatory, not optional.**

### How to Use It

**Sprint planning:**
```
Discussion:
"We have 16 hours for refactoring this sprint. 
Let's allocate:
- 10 hours for tidying as we work on features
- 6 hours to pay down tech debt ticket #456 (OrderService refactoring)"
```

**Sprint board:**
```
TO DO:
- Feature: Add seasonal discount (5h)
- Feature: Update email templates (3h)
- Tech Debt: Refactor OrderService (#456) (6h) ← Explicit story
- Feature: Add gift wrapping (4h)
```

**Sprint review:**
```
Completed:
- 3 features shipped ✅
- OrderService refactored ✅
- Tech debt reduced by 1 ticket
- Velocity stable
- Team happy (time to clean up code)
```

### When Refactoring Budget Not Used

**If unused:**
- Why? (Forgot? Pressure to ship? Unclear priorities?)
- Debt accumulating
- Velocity will slow down
- Address in retrospective

**Red flag:** Multiple sprints with 0% refactoring time used

---

## Prioritization Framework

### How to Prioritize Debt Paydown

**Evaluate each debt item:**

**1. Impact (How much does it hurt?)**
- Blocking new features: 🔴 HIGH
- Slowing all changes: 🔴 HIGH
- Causing bugs: 🟡 MEDIUM
- Just ugly: 🟢 LOW

**2. Frequency (How often touched?)**
- Multiple times per sprint: 🔴 HIGH
- Once per sprint: 🟡 MEDIUM
- Quarterly: 🟢 LOW
- Rarely: ⚪ IGNORE

**3. Domain (How important?)**
- Core domain: 🔴 HIGH
- Supporting domain: 🟡 MEDIUM
- Generic subdomain: 🟢 LOW

**4. Cost (How hard to fix?)**
- < 2 hours: 🟢 EASY
- 2-8 hours: 🟡 MEDIUM
- > 8 hours: 🔴 HARD

**5. Age (How long accumulating?)**
- < 1 month: 🟢 NEW
- 1-3 months: 🟡 AGING
- > 3 months: 🔴 STALE

### Priority Matrix

```
Priority = (Impact × Frequency × Domain) / (Cost × Age)

HIGH: > 5 points
MEDIUM: 2-5 points
LOW: < 2 points
```

**Examples:**

**HIGH Priority:**
```
OrderService refactoring
- Impact: Blocking (3)
- Frequency: Every sprint (3)
- Domain: Core (3)
- Cost: 6 hours (2)
- Age: 2 weeks (1)
Score: (3 × 3 × 3) / (2 × 1) = 13.5 → HIGH
```

**LOW Priority:**
```
Admin report optimization
- Impact: Just slow (1)
- Frequency: Quarterly (1)
- Domain: Supporting (2)
- Cost: 4 hours (2)
- Age: 6 weeks (1)
Score: (1 × 1 × 2) / (2 × 1) = 1 → LOW
```

### Decision Rules

**Pay down this sprint if:**
- Priority: HIGH
- AND we have capacity (20% budget)
- AND blocking work or causing pain

**Defer to backlog if:**
- Priority: MEDIUM/LOW
- OR no capacity this sprint
- OR not urgent

**Close ticket if:**
- Touched < 3 times in 6 months
- No longer relevant
- Problem solved differently

---

## Debt Paydown Process

### Week Before Sprint

**1. Review tech debt ledger**
- Which items are HIGH priority?
- Which items are aging (> 3 months)?
- Which items are blocking next sprint's work?

**2. Estimate paydown effort**
- Break large items into smaller chunks
- Identify quick wins (< 2 hours)
- Plan how to tackle in sprint

**3. Propose in sprint planning**
```
"I'd like to use 6 hours of refactoring budget to pay down 
ticket #456 (OrderService). It's blocking discount features 
and we touch it every sprint. ROI is positive after 4 uses."
```

### During Sprint

**4. Execute paydown**
- Dedicate time (don't squeeze between features)
- Follow safe refactoring practices
- Tests passing throughout
- Multiple small commits

**5. Track progress**
- Update ticket with progress
- If taking longer, communicate
- If easier than expected, tackle another

**6. Review & close**
- PR review like any code
- Deploy to staging
- Verify nothing broken
- Close ticket
- Remove from ledger

### Paydown Commit Messages

```
refactor: Extract Order aggregate from OrderService

Resolves tech debt ticket #456

Context:
- Order logic scattered across 3 services
- Anemic Order entity
- Hard to add new features

Changes:
- Created rich Order aggregate
- Moved calculateTotal, applyDiscount to Order
- Added domain events for order changes
- Tests updated to unit test domain logic

Impact:
- Future discount features easier to add
- Domain logic properly encapsulated
- Sets pattern for other aggregates

Time: 6 hours (as estimated)
```

---

## When Debt Is Acceptable

### Strategic Debt (Good Debt)

**Take debt when:**

**1. Time-to-market is critical**
```
Example: Client demo Friday, feature needs 8h to do right but 3h quick
Decision: Take 5h of debt, ship demo, refactor next week
Reason: Demo could win $200k contract
```

**2. Learning domain**
```
Example: Don't fully understand domain yet
Decision: Simple implementation now, refactor when we know more
Reason: Wrong abstraction worse than duplication
```

**3. Hypothesis testing**
```
Example: Building MVP to test idea
Decision: Skip some patterns, validate concept first
Reason: Might throw away entire feature
```

**4. Low-frequency code**
```
Example: Internal admin tool used quarterly
Decision: Working code is good enough
Reason: ROI negative for refactoring
```

**5. Planned sunset**
```
Example: This module will be replaced in 3 months
Decision: Don't invest in improving it
Reason: Waste of time on dead code
```

### Unacceptable Debt (Bad Debt)

**Never acceptable:**

**1. Violating architectural boundaries**
```
❌ Framework code in domain layer
❌ Direct database queries in controllers
❌ No repository pattern
Reason: This is our non-negotiable standard
```

**2. No tests for business logic**
```
❌ Untested domain logic
❌ "We'll add tests later"
Reason: Tests required by enforcement system
```

**3. Security issues**
```
❌ SQL injection vulnerabilities
❌ Unvalidated input
❌ Missing authentication
Reason: Security is never optional
```

**4. Data integrity problems**
```
❌ Inconsistent data
❌ No validation
❌ Corrupt state possible
Reason: Bad data is unfixable
```

---

## Red Flags

### Warning Signs

**Tech debt out of control when:**

**1. Velocity declining**
```
Sprint 1: 20 points
Sprint 2: 18 points
Sprint 3: 15 points
Sprint 4: 12 points
→ Interest payments consuming capacity
```

**2. Bug rate increasing**
```
Month 1: 2 bugs
Month 2: 5 bugs
Month 3: 8 bugs
→ Complexity breeding errors
```

**3. Team complaints**
```
"This code is impossible to work with"
"I'm afraid to change anything"
"Everything is connected to everything"
→ Team drowning in debt
```

**4. Feature estimates inflating**
```
"This should be 2 hours but in this codebase it's 8 hours"
→ Interest rate too high
```

**5. Refactoring budget never used**
```
6 sprints, 0 hours refactoring
→ Only taking debt, never paying it back
```

### Emergency Measures

**If warning signs appear:**

**1. Declare "tech debt sprint"**
- One full sprint focused on paydown
- No new features
- Address top 5 HIGH priority items
- Get system back to healthy state

**2. Adjust refactoring budget**
- Increase from 20% to 30% temporarily
- Focus on highest-pain areas
- Continue until velocity recovers

**3. Retrospective on debt**
- Why are we accumulating so much?
- What decisions led here?
- How do we prevent this?
- What needs to change?

---

## Quarterly Debt Review

### Every 3 Months

**1. Review ledger**
- What debt is still open?
- What got paid down?
- What's aging (> 3 months)?

**2. Re-prioritize**
- Impact changed?
- Frequency changed?
- Cost changed?
- Some debt no longer relevant?

**3. Set targets**
- How much debt to pay next quarter?
- Which high-priority items to tackle?
- Team capacity for refactoring?

**4. Metrics**
- Total debt items: [Number]
- Debt created this quarter: [Number]
- Debt paid this quarter: [Number]
- Net change: [+/- Number]
- Average debt age: [Days]
- Oldest debt: [Item, age]

**Healthy metrics:**
- Net change: 0 or negative (paying faster than creating)
- Average age: < 60 days
- No debt > 6 months old

---

## Success Metrics

### Individual Level

**You're managing debt well when:**
- You create ledger entry when taking debt
- You use refactoring budget proactively
- You propose debt paydown in planning
- You can articulate debt cost/benefit

### Team Level

**Team manages debt well when:**
- Debt is visible and tracked
- Refactoring budget used every sprint
- Velocity stable or improving
- Team morale good (not drowning in mess)
- Debt trends flat or declining

### Company Level

**OneSyntax manages debt well when:**
- Strategic debt taken for good reasons
- No reckless debt
- Paydown happens consistently
- Codebase improves over time
- Client features ship on time

---

## Templates

### Tech Debt Ticket Template

```markdown
Title: [Tech Debt] [Brief description]

## Context
- Created during: [Feature/Sprint]
- Created by: [Name]
- Date: [Date]
- Ticket: [Link to feature that created debt]

## The Problem
[What is messy/wrong/suboptimal]

## Why We Took This Debt
[The tradeoff we made]
- Time saved: [X hours]
- Value delivered: [What we shipped faster]
- Reason: [Deadline/Learning/Testing/etc]

## Impact
- [ ] Blocking new features
- [ ] Slowing changes (how much: ___)
- [ ] Causing bugs
- [ ] Team confusion
- [ ] Just ugly

## Frequency
- [ ] Multiple times per sprint
- [ ] Once per sprint
- [ ] Monthly
- [ ] Quarterly
- [ ] Rarely

## Domain
- [ ] Core domain
- [ ] Supporting domain
- [ ] Generic subdomain

## Proposed Solution
[How to fix it properly]

## Estimated Effort
[X hours to pay down]

## ROI Calculation
```
Fix time: X hours
Time saved per change: Y hours
Change frequency: Z per month
Break-even: After N changes (M months)
Priority: HIGH/MEDIUM/LOW
```

## Alternative Approaches
[If multiple ways to solve]

## Related Tickets
[Links to similar debt or blocked features]
```

---

## Remember

**Technical debt is a tool, not a failure.**

- Use it strategically
- Track it religiously
- Pay it down consistently
- Don't let it accumulate
- Balance speed and quality

**The goal is sustainable velocity, not zero debt.**

Good teams:
- Take strategic debt when value justifies it
- Track all debt transparently
- Pay debt before it compounds
- Maintain healthy codebase over time

---

*Related: [Refactoring Decisions](refactoring-decisions.md) | [Safe Refactorings](safe-refactorings.md) | [Simple Design](simple-design.md)*
