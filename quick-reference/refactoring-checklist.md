# Refactoring Quick Reference
**When and how to tidy your code**

Print this. Keep it at your desk. Use it before every commit.

---

## 🎯 The Three Options

Before making any change, you have three choices:

```
┌─────────────────────────────────────────────────┐
│ 1. TIDY FIRST, then add feature                 │
│    Clean the code, commit, then add feature     │
│                                                 │
│ 2. FEATURE FIRST, then tidy (maybe)             │
│    Add feature first, refactor later if needed  │
│                                                 │
│ 3. NEVER TIDY (technical debt)                  │
│    Add to tech debt ledger, tidy in future      │
└─────────────────────────────────────────────────┘
```

→ Decision framework: [reference/refactoring-decisions.md](../reference/refactoring-decisions.md)

---

## ✅ Safe Refactorings (No Approval Needed)

**These micro-tidyings you can do anytime:**

### Code Readability
- [ ] **Delete dead code** - Unused methods, commented code
- [ ] **Normalize symmetries** - Consistent naming patterns
- [ ] **Explicit parameters** - Replace booleans with enums
- [ ] **Chunk statements** - Group related lines with blank lines

### Conditional Logic
- [ ] **Guard clauses** - Early returns for edge cases
- [ ] **Unsurprising conditionals** - Positive conditions first
- [ ] **Extract helper methods** - Complex conditions to named methods

### Structure
- [ ] **Move declaration closer to usage** - Reduce variable scope
- [ ] **Explaining variables** - Complex expressions to named variables
- [ ] **Explaining constants** - Magic numbers to named constants
- [ ] **One pile method** - Similar code blocks together

### Code Health
- [ ] **New interface, old implementation** - Deprecate cleanly
- [ ] **Reading order** - Related methods close together
- [ ] **Cohesion order** - Methods ordered by abstraction level

---

## ⚠️ Requires Approval

**Get approval before doing these:**

- Changing public APIs or interfaces
- Renaming widely-used methods/classes
- Moving files between bounded contexts
- Large-scale architectural changes
- Refactoring taking > 2 hours

→ Approval process: [reference/refactoring-decisions.md](../reference/refactoring-decisions.md)

---

## 🚦 Quick Decision Tree

```
Do I need to change this file?
│
├─ YES → Is the code already clean?
│         ├─ YES → Make your feature change
│         └─ NO → Continue below
│
└─ Will tidying make the feature easier?
   │
   ├─ YES → How long will tidying take?
   │        ├─ < 30 min → Tidy first, commit, then feature
   │        ├─ 30-120 min → Ask: "Is the benefit worth it?"
   │        │               ├─ YES → Get approval, tidy first
   │        │               └─ NO → Feature first, tidy later
   │        └─ > 2 hours → Log as tech debt, plan separately
   │
   └─ NO → Make feature change
           └─ Did you make it messier?
              ├─ YES → Tidy after feature
              └─ NO → Done!
```

---

## 📋 Pre-Refactoring Checklist

**Before tidying ANY code:**

- [ ] Tests exist and pass
- [ ] You understand what the code does
- [ ] You know why it was written this way
- [ ] The refactoring won't break existing behavior
- [ ] You can explain the benefit

**After tidying:**

- [ ] All tests still pass
- [ ] Code is more readable
- [ ] Behavior unchanged
- [ ] Commit message explains "why"

---

## 🛡️ Safe Refactoring Workflow

```bash
# 1. Ensure tests pass
npm test  # or your test command

# 2. Make ONE small refactoring
# (e.g., extract a single method)

# 3. Run tests again
npm test

# 4. Commit immediately
git add .
git commit -m "refactor: extract validateUser method"

# 5. Repeat for next refactoring
```

**Golden rule:** One refactoring, one commit

---

## 🔍 Common Refactoring Patterns

### Pattern 1: Guard Clauses
**Before:**
```php
public function processOrder($order) {
    if ($order->isValid()) {
        if ($order->hasItems()) {
            if ($order->customer->isActive()) {
                // 20 lines of logic here
            }
        }
    }
}
```

**After:**
```php
public function processOrder($order) {
    if (!$order->isValid()) return;
    if (!$order->hasItems()) return;
    if (!$order->customer->isActive()) return;

    // 20 lines of logic here (now at top level)
}
```

---

### Pattern 2: Extract Helper Method
**Before:**
```php
if ($user->role === 'admin' || $user->role === 'owner' ||
    ($user->role === 'editor' && $user->hasPermission('publish'))) {
    // do something
}
```

**After:**
```php
if ($this->canPublish($user)) {
    // do something
}

private function canPublish(User $user): bool {
    return $user->role === 'admin'
        || $user->role === 'owner'
        || ($user->role === 'editor' && $user->hasPermission('publish'));
}
```

---

### Pattern 3: Explaining Constants
**Before:**
```php
if ($subscription->daysRemaining() < 7) {
    $this->sendRenewalReminder($subscription);
}
```

**After:**
```php
private const RENEWAL_REMINDER_THRESHOLD_DAYS = 7;

if ($subscription->daysRemaining() < self::RENEWAL_REMINDER_THRESHOLD_DAYS) {
    $this->sendRenewalReminder($subscription);
}
```

---

## ⏱️ Time-Based Guidelines

**< 5 minutes:** Just do it
- Delete dead code
- Add blank lines for chunking
- Rename single variable

**5-30 minutes:** Tidy first, then feature
- Extract 2-3 helper methods
- Add guard clauses
- Introduce explaining constants

**30-120 minutes:** Evaluate carefully
- Discuss with team
- Consider impact on feature timeline
- Get approval from tech lead

**> 2 hours:** Separate initiative
- Log in tech debt ledger
- Schedule for dedicated refactoring sprint
- Get stakeholder approval

---

## 📊 Refactoring Budget

**OneSyntax policy:**

- **20% of sprint capacity** reserved for refactoring
- **Individual refactorings < 30 min:** No approval needed
- **Refactoring > 2 hours:** Requires tech lead approval
- **Tech debt stories:** Planned in sprint planning

→ Full details: [reference/technical-debt-management.md](../reference/technical-debt-management.md)

---

## 🎯 Refactoring Anti-Patterns

**DON'T:**
- ❌ Refactor without tests
- ❌ Mix refactoring with feature changes in one commit
- ❌ Refactor for "consistency" without clear benefit
- ❌ Spend hours gold-plating working code
- ❌ Refactor code you don't understand

**DO:**
- ✅ Tidy code you're about to change
- ✅ Leave code better than you found it
- ✅ Make small, safe refactorings frequently
- ✅ Commit refactorings separately from features
- ✅ Ask "Does this add value?" before tidying

---

## 🔥 Code Smells Checklist

**When you see these, consider refactoring:**

### Method-Level Smells
- [ ] Method > 20 lines
- [ ] Method does more than one thing
- [ ] Nested conditionals > 3 levels deep
- [ ] Duplicate logic in multiple places
- [ ] Boolean flags as parameters

### Class-Level Smells
- [ ] Class > 300 lines
- [ ] Too many dependencies (> 5)
- [ ] Low cohesion (unrelated methods)
- [ ] God class (knows too much)
- [ ] Anemic domain model (all getters/setters)

### Architecture Smells
- [ ] Dependency rule violations (Clean Architecture)
- [ ] Domain logic in controllers
- [ ] Business logic in entities
- [ ] Missing bounded context boundaries
- [ ] Circular dependencies

→ Full architecture rules: [quick-reference/clean-architecture-cheatsheet.md](clean-architecture-cheatsheet.md)

---

## 💡 When In Doubt

**Ask yourself:**
1. Will this make the code easier to change?
2. Will this reduce bugs?
3. Will this help the next person understand the code?
4. Is the benefit worth the time investment?
5. Can I explain why this is better?

**If 3+ are "YES" → Refactor**
**If 3+ are "NO" → Skip it**

---

## 📝 Commit Message Template

```
refactor: [what you changed]

- Why: [business or technical reason]
- Benefit: [how this helps]
- Tests: [still passing? added new ones?]
```

**Example:**
```
refactor: extract order validation to separate method

- Why: Validation logic was duplicated in 3 places
- Benefit: Single source of truth, easier to test
- Tests: All existing tests passing, added validation tests
```

---

## 🎓 Learning Resources

- **15 Safe Refactorings:** [reference/safe-refactorings.md](../reference/safe-refactorings.md)
- **When to Refactor:** [reference/refactoring-decisions.md](../reference/refactoring-decisions.md)
- **Managing Tech Debt:** [reference/technical-debt-management.md](../reference/technical-debt-management.md)

---

## Remember

> "Make the change easy, then make the easy change."
> — Kent Beck

**Refactoring isn't about perfection. It's about continuous improvement.**

---

## Questions?

- **Slack:** #architecture
- **Owner:** Kalpa
- **Email:** kalpa@onesyntax.com

**Full playbook:** [README.md](../README.md)

---

*Version 1.0 | Last Updated: November 2025*
