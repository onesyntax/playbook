# Refactoring Decisions
## When to Tidy, When to Ship, When to Create Tech Debt

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Based on Kent Beck's "Tidy First?" - refactoring is an economic decision

---

## Table of Contents

1. [The Core Question](#the-core-question)
2. [The Three Options](#the-three-options)
3. [Decision Framework](#decision-framework)
4. [Cost-Benefit Analysis](#cost-benefit-analysis)
5. [When to Choose Each Option](#when-to-choose-each-option)
6. [Real Examples from OneSyntax](#real-examples-from-onesyntax)
7. [Getting Approval](#getting-approval)
8. [Tracking Decisions](#tracking-decisions)

---

## The Core Question

### The Situation You Face Daily

You're about to add a feature. You open the code and find:
- Anemic entities with logic in services
- 300-line methods
- Framework dependencies in domain layer
- No tests
- Confusing variable names
- Duplicated code everywhere

**The question:**
> "Do I clean this up first, or just add my feature to the mess?"

### Why This Matters at OneSyntax

**Our standards say:** Follow DDD + Clean Architecture  
**Reality says:** Lots of existing code doesn't follow these standards  
**The tension:** You want to do it right, but you have deadlines

**Without clear guidance:**
- Developers get paralyzed (don't know what's allowed)
- Technical debt accumulates invisibly
- Everyone feels guilty about "bad" code
- Juniors afraid to refactor (might break things)
- Seniors refactor everything (miss deadlines)

### Kent Beck's Insight

> "The question isn't WHETHER to refactor, but WHEN to refactor - before your change, after your change, or never."

**This is an economic decision, not a moral one.**

---

## The Three Options

### Option 1: Tidy First, Then Add Feature

**Process:**
1. Refactor the messy code
2. Ensure all tests still pass
3. Commit refactoring separately
4. Add your feature to clean code
5. Commit feature separately

**Time split:** 40% refactoring, 60% feature

**Example:**
```php
// Step 1: Tidy First
// Extract anemic Order entity to rich domain model
// Commit: "Refactor: Extract order total calculation to Order entity"

// Step 2: Add Feature
// Now easy to add discount calculation to Order
// Commit: "feat: Add bulk discount calculation"
```

### Option 2: Add Feature, Then Tidy

**Process:**
1. Add your feature to messy code
2. Make it work (tests pass)
3. Commit feature
4. Refactor both old and new code
5. Commit refactoring separately

**Time split:** 70% feature, 30% refactoring

**Example:**
```php
// Step 1: Add Feature
// Add discount to existing messy OrderService
// Commit: "feat: Add bulk discount (needs refactoring)"

// Step 2: Tidy After
// Extract all pricing logic to Order entity
// Commit: "Refactor: Move pricing logic to Order aggregate"
```

### Option 3: Never Tidy (Add Tech Debt)

**Process:**
1. Add your feature to messy code
2. Make it work (tests pass)
3. Commit feature
4. Create technical debt ticket
5. Move on (plan to fix later)

**Time split:** 100% feature, 0% refactoring now

**Example:**
```php
// Add discount to messy OrderService
// Commit: "feat: Add bulk discount"
// Create ticket: "Tech Debt: Refactor OrderService to DDD pattern (#123)"
// Add to tech debt log
```

---

## Decision Framework

### The Decision Tree

**When you encounter messy code:**

```
START: I need to change messy code
│
├─ Is this code in the critical path of my feature?
│  ├─ No → Option 3: Don't tidy, add feature, create ticket
│  │
│  └─ Yes
│      │
│      ├─ Would tidying take < 30 minutes?
│      │  └─ Yes → Option 1: Tidy first (always worth it)
│      │
│      ├─ Is this code touched frequently? (> 1x per month)
│      │  └─ Yes → Option 1: Tidy first (high ROI)
│      │
│      ├─ Is this in core domain? (core business logic)
│      │  └─ Yes → Option 1: Tidy first (strategic importance)
│      │
│      ├─ Am I blocked by the mess? (can't add feature without tidying)
│      │  └─ Yes → Option 1: Tidy first (no choice)
│      │
│      ├─ Is deadline urgent? (< 2 days)
│      │  └─ Yes → Option 3: Add tech debt, ship feature
│      │
│      ├─ Is tidying large? (> 4 hours estimated)
│      │  └─ Yes → Option 3: Create ticket, get approval for big refactor
│      │
│      └─ Default → Option 2: Feature first, tidy after
```

### Quick Reference Rules

**Tidy First when:**
- ✅ Quick (< 30 min)
- ✅ High change frequency
- ✅ Core domain
- ✅ Blocking your feature
- ✅ Clear how to fix
- ✅ Tests exist to protect refactoring

**Add Tech Debt when:**
- 🟡 Large refactoring (> 4 hours)
- 🟡 Urgent deadline
- 🟡 Unclear how to fix
- 🟡 No tests (risky to refactor)
- 🟡 Low change frequency
- 🟡 Supporting domain (not core)

**Never tidy:**
- ❌ Code you're not changing
- ❌ Code that works fine
- ❌ "I don't like the style"
- ❌ Speculative future needs

---

## Cost-Benefit Analysis

### How to Calculate

**Cost of tidying NOW:**
- Time spent refactoring (estimate in hours)
- Risk of breaking things
- Delayed feature delivery

**Benefit of tidying NOW:**
- Faster to add current feature
- Easier to add future features
- Fewer bugs
- Better team understanding

**Cost of NOT tidying:**
- Slower to add current feature (working around mess)
- Much slower for future features (technical debt compounds)
- More bugs (complexity breeds errors)
- Team frustration

### The Formula

```
Should I tidy first?

IF: (Time saved on this feature + Time saved on future features) > (Time spent tidying)
THEN: Tidy first
ELSE: Add tech debt
```

### Estimating Future Impact

**High change frequency (> 1x per month):**
- Multiply tidying time by 5x for breakeven
- Example: 2 hours tidying saves 10+ hours over next year

**Medium change frequency (quarterly):**
- Multiply tidying time by 2x for breakeven
- Example: 2 hours tidying saves 4+ hours over next year

**Low change frequency (rarely):**
- May never break even
- Only tidy if blocking current work

---

## When to Choose Each Option

### Option 1: Tidy First (Most Common)

**Use when:**

**Quick wins (< 30 minutes):**
```php
// Before: Confusing variable names
$x = $order->getTotal();
$y = $customer->getDiscount();
$z = $x - $y;

// Tidy: 5 minutes
$orderTotal = $order->getTotal();
$customerDiscount = $customer->getDiscount();
$finalAmount = $orderTotal->subtract($customerDiscount);

// Now add feature
$bulkDiscount = $this->calculateBulkDiscount($orderTotal);
$finalAmount = $finalAmount->subtract($bulkDiscount);
```

**Frequent changes:**
```php
// This OrderService is touched every sprint
// Current: 500 lines, anemic entities, logic everywhere
// Impact: Every feature takes 2x longer than it should

// Decision: Tidy first
// - Extract to rich Order aggregate
// - Worth 4 hours now to save 20+ hours over next 6 months
```

**Core domain:**
```php
// This is order processing - core to business
// Mess here affects revenue, customer experience
// Strategic importance: Fix it right

// Decision: Tidy first
// - Core domain deserves clean architecture
// - Sets pattern for rest of team
```

**Blocking your work:**
```php
// Need to add email validation to User
// But User is anemic entity with logic scattered everywhere
// Can't add email validation without restructuring

// Decision: Tidy first (forced by circumstance)
// - Extract Email value object
// - Move validation to domain layer
// - Then add new feature
```

### Option 2: Feature First, Then Tidy

**Use when:**

**Learning as you go:**
```php
// Not sure how to refactor this yet
// Add feature first to understand the domain better
// Then refactor with better understanding

// Example:
// 1. Add discount feature to messy OrderService
// 2. Now I understand discount domain better
// 3. Extract Discount value object
// 4. Move logic to Order aggregate
```

**Feature is simple, refactoring is complex:**
```php
// Adding one line to existing method (easy)
// But proper refactoring requires restructuring 5 classes (hard)

// Decision: Feature first
// - Get feature working quickly
// - Schedule refactoring as separate task
// - Both get done, just not same PR
```

**Tests don't exist:**
```php
// Legacy code with no tests
// Too risky to refactor without tests

// Decision: Feature first
// 1. Add tests for current behavior
// 2. Add feature
// 3. Add tests for new behavior
// 4. NOW safe to refactor
// 5. Tidy with test coverage
```

### Option 3: Never Tidy (Create Tech Debt)

**Use when:**

**Large refactoring needed:**
```php
// Proper fix requires:
// - Restructuring 3 aggregates
// - Changing database schema
// - Updating 10+ files
// - Estimated time: 2-3 days

// Decision: Add tech debt
// - Feature is urgent (client demo Friday)
// - Create ticket: "Refactor order domain model (#456)"
// - Add to tech debt log
// - Schedule for next sprint
// - Ship feature now to messy code
```

**Unclear solution:**
```php
// This code is messy but I don't know the right pattern yet
// Several design options, need team discussion

// Decision: Add tech debt
// - Ship feature with existing pattern
// - Document options in architecture review
// - Get team consensus on approach
// - Refactor later with clear direction
```

**Low-impact area:**
```php
// This is internal admin tool used quarterly
// Not core domain, low change frequency

// Decision: Add tech debt
// - Not worth investment now
// - If touched 3 times, then refactor
// - For now, feature works, ship it
```

**No time/capacity:**
```php
// Team at capacity (other priorities)
// Client deadline imminent
// Quality standards still met (tests pass, no architectural violations)

// Decision: Add tech debt
// - Better to ship working feature with tech debt
// - Than to miss deadline or cut corners on new code
// - Allocate refactoring budget next sprint
```

---

## Real Examples from OneSyntax

### Example 1: Order Total Calculation

**Scenario:** Need to add tax calculation to orders.

**Current state:**
- Order entity is anemic (just getters/setters)
- Total calculation in OrderService (150 lines)
- No tests
- Changed every 2-3 sprints

**Analysis:**
```
Cost of tidying:
- Extract to Order aggregate: 3 hours
- Add tests: 2 hours
- Total: 5 hours

Benefit:
- This sprint: Save 1 hour (easier to add tax)
- Future: Save 2 hours every time we touch it
- Over 6 months (3 changes): 6 hours saved
- ROI: 6 hours saved vs 5 hours invested = POSITIVE

Change frequency: High
Domain: Core
```

**Decision: TIDY FIRST**

**Approach:**
1. Add tests for current behavior (2 hours)
2. Extract Order.calculateTotal() (2 hours)
3. Extract Money value object (1 hour)
4. Add tax calculation cleanly (1 hour)
5. Total: 6 hours (vs 8 hours fighting the mess)

### Example 2: Admin Report Generation

**Scenario:** Need to add new field to internal admin report.

**Current state:**
- Report query is 200-line SQL in controller
- Used quarterly by 2 internal users
- Not core domain
- Works fine, just ugly

**Analysis:**
```
Cost of tidying:
- Extract to proper query object: 4 hours
- Add repository pattern: 2 hours
- Total: 6 hours

Benefit:
- This sprint: Save 0 hours (adding field is same effort)
- Future: Maybe touched 1x per year
- ROI: Negative (6 hours cost, minimal benefit)

Change frequency: Very low
Domain: Supporting (not core)
```

**Decision: ADD TECH DEBT**

**Approach:**
1. Add field to existing SQL query (30 min)
2. Test it works (15 min)
3. Ship it
4. Create ticket: "Refactor admin reports (#789)"
5. Prioritize: Low (only if touched 3 more times)
6. Total: 45 minutes

### Example 3: Email Validation

**Scenario:** Need to add email verification flow to registration.

**Current state:**
- User entity has string email (no value object)
- Email validation in controller (wrong layer)
- Format validation only, no business rules
- Registration touched every sprint

**Analysis:**
```
Cost of tidying:
- Create Email value object: 1 hour
- Move validation to domain: 30 min
- Update User entity: 30 min
- Total: 2 hours

Benefit:
- This sprint: Save 1 hour (clean place to add verification)
- Future: Save 30 min every time email logic changes
- This is core domain pattern that should be right
- Sets example for other value objects

Change frequency: High
Domain: Core
Blocking: Yes (can't add verification without proper Email object)
```

**Decision: TIDY FIRST**

**Approach:**
1. Extract Email value object (1 hour)
2. Move existing validation to Email (30 min)
3. Update User aggregate (30 min)
4. Add verification flow cleanly (2 hours)
5. Total: 4 hours (vs 6 hours fighting framework dependencies)

### Example 4: Payment Gateway Integration

**Scenario:** Client switched from Stripe to PayPal, need to support both.

**Current state:**
- Payment logic tightly coupled to Stripe
- No abstraction layer
- Payment code scattered in 5 files
- This is rare change (maybe once a year)

**Analysis:**
```
Cost of tidying properly:
- Extract Payment interface: 2 hours
- Create PaymentGateway abstraction: 4 hours
- Refactor Stripe to adapter pattern: 4 hours
- Add PayPal adapter: 4 hours
- Total: 14 hours

Cost of quick solution:
- Add if/else for PayPal: 3 hours
- Make it work: 1 hour
- Total: 4 hours

Future: Unlikely to add more gateways
```

**Decision: ADD TECH DEBT (strategic tech debt)**

**Approach:**
1. Add PayPal with if/else (quick and dirty)
2. Ship to client (they're happy)
3. Create ticket: "Refactor payment gateway abstraction (#234)"
4. Schedule when/if we add 3rd gateway
5. For now: 2 gateways don't justify full abstraction

---

## Getting Approval

### Who Can Approve What

**No approval needed (< 30 min):**
- Renaming variables
- Extracting small methods
- Deleting dead code
- Adding guard clauses
- Improving comments
- Fixing obvious bugs

**Team lead approval (30 min - 2 hours):**
- Extracting value objects
- Moving logic between layers
- Small architectural improvements
- Refactoring single class/file

**Senior/Kalpa approval (2+ hours):**
- Multi-file refactoring
- Changing aggregate boundaries
- Database schema changes
- Architectural restructuring
- Anything affecting multiple features

### How to Request Approval

**Slack message template:**
```
@senior-dev Quick refactoring approval needed

Context: Working on [feature]
Problem: [describe messy code]
Proposal: [how you'll tidy it]
Estimated time: [X hours]
Benefit: [why worth it]
Alternative: [add tech debt ticket instead?]

Can I proceed? Or should we defer?
```

**Example:**
```
@kalpa Quick refactoring approval needed

Context: Adding bulk discount feature
Problem: Order total calculation is 150-line method in OrderService, 
anemic Order entity, no tests
Proposal: 
- Extract Order.calculateTotal() (2h)
- Add Money value object (1h)
- Add tests (2h)
- Then add discount cleanly (1h)
Total: 6 hours

Benefit: 
- This code touched every 2-3 sprints
- Will save ~2 hours each time
- Core domain should be clean

Alternative: Add discount to existing mess (4h), 
create tech debt ticket for "someday"

Can I proceed with 6-hour refactor? Or ship with tech debt?
```

### Approval Criteria

**Approve refactoring if:**
- ✅ Cost-benefit math makes sense
- ✅ Developer can articulate the benefit
- ✅ Timeline allows for it
- ✅ Tests exist or will be added
- ✅ Clear plan to completion

**Defer to tech debt if:**
- ❌ Math doesn't work (high cost, low benefit)
- ❌ Unclear how to solve
- ❌ No capacity this sprint
- ❌ Too risky without tests
- ❌ Can be postponed without major pain

---

## Tracking Decisions

### Refactoring Decision Log

**Every time you choose an option, log it:**

```markdown
## Refactoring Decision: [Feature Name]

**Date:** [Date]
**Developer:** [Name]
**Decision:** [Option 1/2/3]

### Context
- Feature: [What you're building]
- Messy code: [What's wrong]
- Location: [File/class names]

### Analysis
- Tidying time: [X hours]
- Change frequency: [High/Medium/Low]
- Domain: [Core/Supporting/Generic]
- Urgency: [Deadline if any]

### Decision & Reasoning
[Why you chose this option]

### Outcome (fill in later)
- Actual time spent: [X hours]
- Was it worth it? [Yes/No/TBD]
- What did we learn?
```

### In PR Description

**For Option 1 (Tidy First):**
```markdown
## Changes
Refactoring (2 commits):
- Extracted Order.calculateTotal() to aggregate
- Created Money value object

Feature (1 commit):
- Added bulk discount calculation

## Refactoring Decision
- Chose to tidy first
- Estimated time: 3h, Actual: 3.5h
- Reason: Core domain, high change frequency
- Result: Feature was much easier to add cleanly
```

**For Option 3 (Tech Debt):**
```markdown
## Changes
- Added bulk discount to OrderService

## Technical Debt
Created ticket #456: "Refactor OrderService to DDD pattern"

**Why deferred:**
- Large refactor (6h estimated)
- Urgent client deadline (Friday)
- Low change frequency (touched quarterly)

**Plan:** Revisit in Q2 2025 or if touched 3 more times
```

### Tech Debt Ticket Template

```markdown
Title: [Tech Debt] Refactor [Component] to [Pattern]

## Context
Created while implementing: [Feature]
Developer: [Name]
Date: [Date]

## The Problem
[Describe what's messy]

## Proposed Solution
[How to fix it]

## Estimated Effort
[X hours]

## Priority Criteria
- [ ] Touched > 3 times since creation
- [ ] Causing bugs or confusion
- [ ] Blocking new features
- [ ] Core domain (should be clean)
- [ ] Team has capacity

## Cost-Benefit
- Time to fix: [X hours]
- Time saved per change: [Y hours]
- Change frequency: [N times per quarter]
- ROI: [Calculation]

## Alternative Approaches
[If multiple ways to solve it]
```

---

## Common Scenarios & Decisions

### Scenario 1: Legacy Code with No Tests

**Your feature:** Add email notifications to user registration

**Problem:** User registration code has no tests, 300-line method

**Decision tree:**
```
1. Can I add feature without understanding existing code?
   └─ No (need to modify registration flow)
   
2. Can I add tests first?
   └─ Yes (characterization tests)
   
3. With tests, is refactoring safe?
   └─ Yes
   
4. Is tidying worth it?
   └─ Yes (core domain, high change frequency)
```

**Decision: Option 1 (Tidy First)**

**Approach:**
1. Add characterization tests (2h) - capture current behavior
2. Extract email notification concern (1h)
3. Break up 300-line method (2h)
4. Add new email notification feature (1h)
5. Total: 6 hours

**Alternative (Option 3):**
- Add email notification to existing 300-line method (3h)
- Create tech debt ticket (refactor registration)
- Total: 3h now + defer 5h work

**Why Option 1 wins:**
- Tests are mandatory anyway (our standard)
- Registration touched every 2-3 sprints
- Breaking up method makes tests easier
- 6 hours now saves 10+ hours over next year

### Scenario 2: Quick Feature, Messy Code

**Your feature:** Change button text from "Buy" to "Purchase"

**Problem:** Button is in component with 50 other UI concerns mixed

**Decision tree:**
```
1. Is feature blocked by mess?
   └─ No (can change text without restructuring)
   
2. Would tidying improve this feature?
   └─ No (same effort either way)
   
3. Is this code touched frequently?
   └─ Yes (UI changes every sprint)
```

**Decision: Option 2 (Feature First, Then Tidy)**

**Approach:**
1. Change button text (5 min) - commit
2. Extract Button component properly (30 min) - commit
3. Total: 35 min

**Why not Option 1:**
- Tidying doesn't help current feature
- But should tidy because touched frequently
- Do both, just different order

### Scenario 3: Unclear How to Fix

**Your feature:** Add multi-currency support

**Problem:** Money is primitive (float), used everywhere

**Decision tree:**
```
1. Is current code blocking feature?
   └─ Yes (can't add currency without restructuring)
   
2. Do I know how to fix it?
   └─ No (multiple approaches possible)
   
3. Is this decision architectural?
   └─ Yes (affects whole system)
```

**Decision: Option 3 + Architecture Review**

**Approach:**
1. Add multi-currency to existing code (hacky but works) - 2h
2. Ship feature
3. Schedule architecture review
4. Team decides on Money/Currency value object pattern
5. Refactor with consensus in next sprint

**Why not Option 1:**
- Don't know right pattern yet
- Too risky to guess
- Need team input
- Feature can't wait for architecture decision

---

## Refactoring Time Budget

### Sprint Capacity Allocation

**Every sprint:**
```
Total capacity: 80 hours (2 developers × 40 hours)
├─ Feature work: 60 hours (75%)
├─ Refactoring: 16 hours (20%)
└─ Meetings/overhead: 4 hours (5%)
```

**That 20% refactoring time can be:**
- Tidying before features
- Tidying after features
- Paying down tech debt tickets
- Adding missing tests
- Improving infrastructure

**This is BUDGETED, not OPTIONAL.**

### How to Use Refactoring Budget

**At sprint planning:**
1. Estimate feature work (60 hours)
2. Reserve 16 hours for refactoring
3. Decide: tidy proactively or pay down debt?

**Option A: Tidy as you go**
- Developers use 20% for tidying before features
- Natural part of feature work
- Reduces tech debt creation

**Option B: Dedicated refactoring stories**
- Create explicit refactoring tickets
- Tackle big tech debt items
- Whole team sees refactoring work

**Recommendation: Mix of both**
- 10 hours: Tidy as you go (small improvements)
- 6 hours: Tackle one tech debt ticket from backlog

### Tracking Refactoring Time

**In standup:**
> "Yesterday: Spent 2 hours refactoring OrderService before adding discount feature. Today: Adding the discount feature."

**In sprint review:**
> "This sprint: Completed 3 features + refactored 2 legacy modules. Tech debt reduced by 4 tickets."

**In retrospective:**
> "Did we use our 20% refactoring budget? Was it worth it? Should we adjust?"

---

## Red Flags & Anti-Patterns

### Red Flag 1: "No Time to Refactor"

**What it sounds like:**
> "I know this code is messy but we don't have time to fix it. Ship it now, fix it later."

**Problem:** "Later" never comes. Tech debt compounds.

**Solution:**
- Use the 20% refactoring budget
- Frame as economic decision, not moral failing
- Create tech debt ticket if truly no time
- Review tech debt every sprint

### Red Flag 2: "Refactor Everything"

**What it sounds like:**
> "I can't add this feature until I rewrite the entire module. Give me 2 weeks."

**Problem:** Gold-plating. Perfect is enemy of done.

**Solution:**
- What's the MINIMUM tidying needed?
- Can you tidy just the part you're changing?
- Is this really blocking, or perfectionism?
- Consider Option 2 (feature first, then tidy)

### Red Flag 3: "Just Ship It"

**What it sounds like:**
> "Code quality doesn't matter, just ship the feature."

**Problem:** Violates our standards. Creates mounting tech debt.

**Solution:**
- Code quality IS speed (over time)
- Use decision framework
- If urgent, create tech debt ticket
- Don't make cutting corners the norm

### Red Flag 4: "Always Tidy First"

**What it sounds like:**
> "I spend 4 hours refactoring before every feature, regardless of need."

**Problem:** Refactoring without clear benefit. Wasted time.

**Solution:**
- Run the cost-benefit math
- Is this ACTUALLY improving anything?
- Is change frequency high enough?
- Sometimes messy code is fine if rarely touched

### Red Flag 5: "Never Create Tech Debt"

**What it sounds like:**
> "All code must be perfect before merge. No compromises."

**Problem:** Unrealistic. Blocks shipping. Kills momentum.

**Solution:**
- Tech debt is a tool, not a failure
- Strategic tech debt is smart
- Track it, plan to pay it down
- Ship features, improve code over time

---

## Success Metrics

### Individual Level

**You're making good refactoring decisions when:**
- You can articulate cost-benefit of tidying
- You're not blocked by legacy code
- You create tech debt tickets when appropriate
- You use the 20% refactoring budget
- Your PRs have clear refactoring commits

### Team Level

**Team is making good decisions when:**
- Tech debt is tracked and visible
- Refactoring budget is used (not hoarded or exceeded)
- Legacy code gradually improving
- Features ship on time
- Code quality trends positive
- Developers not paralyzed by mess

---

## Remember

**Refactoring is an economic decision, not a moral one.**

- Sometimes tidying first is smart (high ROI)
- Sometimes shipping with tech debt is smart (urgent value)
- Sometimes tidying after is smart (learning as you go)

**The goal is sustainable velocity, not perfect code.**

- Clean code helps you go fast
- But refactoring everything slows you down
- Find the balance through cost-benefit analysis

**Use the framework, track your decisions, learn from outcomes.**

---

*Related: [Safe Refactorings](safe-refactorings.md) | [Technical Debt Management](technical-debt-management.md) | [Simple Design](simple-design.md)*
