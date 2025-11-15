# Collective Ownership with Individual Accountability
## Everyone Can Improve Anything, But Someone Always Owns Quality

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Shared access, individual accountability

---

## Table of Contents

1. [The OneSyntax Model](#the-onesyntax-model)
2. [What Collective Ownership Means Here](#what-collective-ownership-means-here)
3. [Code Stewardship Concept](#code-stewardship-concept)
4. [Pre-Commit Checklist](#pre-commit-checklist)
5. [Clean Up After Others Protocol](#clean-up-after-others-protocol)
6. [Ownership vs. Stewardship](#ownership-vs-stewardship)
7. [When to Modify Others' Code](#when-to-modify-others-code)
8. [Knowledge Sharing Requirements](#knowledge-sharing-requirements)

---

## The OneSyntax Model

### Reconciling Two Philosophies

**Traditional XP:** "Everyone owns everything, no one owns anything"
**OneSyntax:** "Everyone can improve anything, but someone owns quality"

**The Tension:**
- XP wants shared responsibility to prevent bottlenecks
- Our enforcement system demands individual accountability
- We need both flexibility AND accountability

**Our Solution:**
- **Access:** Any developer can modify any code
- **Stewardship:** If you touch code, you temporarily own its quality
- **Accountability:** Original author + modifier both responsible for outcomes

### Core Principle

> "You can modify any code in the system, but when you do, you become co-responsible for its quality with the original author."

This creates:
- âœ… Freedom to fix issues anywhere
- âœ… Accountability for changes made
- âœ… Knowledge spreading through the team
- âœ… No "that's not my code" excuses

---

## What Collective Ownership Means Here

### You CAN:

**✅ Fix bugs anywhere**
- See a bug in someone else's module? Fix it
- Don't wait for "the owner" to be available
- Submit PR with clear explanation

**✅ Improve code quality**
- Refactor poorly structured code
- Add missing tests
- Extract value objects from primitives
- Remove code smells

**✅ Add features to existing modules**
- Extend functionality where needed
- Follow existing patterns in the module
- Improve patterns if they violate standards

**✅ Update documentation**
- Fix outdated README files
- Add missing API documentation
- Clarify confusing code comments

### You CANNOT:

**❌ Make major architectural changes alone**
- Changing bounded context boundaries requires discussion
- Major refactors need senior developer approval
- Breaking changes need team consensus

**❌ Lower quality standards**
- "Quick fixes" that skip tests
- Removing existing tests
- Adding framework dependencies to domain layer
- Creating new technical debt

**❌ Ignore the module's patterns**
- Every module has an established style
- Match existing patterns unless improving them
- Don't mix architectural styles

**❌ Blame the original author**
- If you modified it, you own it
- "But I just changed one line" isn't an excuse
- When you commit, you're responsible

---

## Code Stewardship Concept

### What Is a Code Steward?

**Definition:** A temporary co-owner who ensures quality while modifying code they didn't originally write.

**Responsibilities:**
1. Understand the module's purpose before changing it
2. Run existing tests to ensure they pass
3. Add tests for new changes
4. Follow established patterns or improve them
5. Leave code better than you found it
6. Document non-obvious changes

### Stewardship Duration

**During modification:**
- You're a full co-owner
- Subject to same quality standards
- Accountable in code reviews

**After merge:**
- Responsible for bugs introduced by your changes
- Must fix issues you created
- Can't pass back to original author

**Permanent stewardship triggers:**
- You make 3+ significant changes to a module
- You become the primary maintainer
- You understand it better than original author

---

## Pre-Commit Checklist

Before modifying someone else's code, complete this checklist:

### Understanding Phase

- [ ] **Can I explain this module's purpose in one sentence?**
  - If no: Read the code until you can
  - Ask original author if needed

- [ ] **Do I understand the bounded context this code belongs to?**
  - Check context diagram
  - Verify domain concepts used

- [ ] **Have I read the tests to understand expected behavior?**
  - Run the tests
  - Understand what they're testing
  - Note any missing test coverage

- [ ] **Do I understand the existing patterns used?**
  - Repository pattern implementation
  - Value object usage
  - Entity structure
  - Use case organization

### Modification Phase

- [ ] **Have I run the existing tests?**
  - All tests must pass before changes
  - Fix failing tests first if any

- [ ] **Am I following the module's established patterns?**
  - Or intentionally improving them?
  - Document why if changing patterns

- [ ] **Have I added tests for my changes?**
  - New functionality = new tests
  - Bug fixes = regression tests
  - Refactors = same test coverage

- [ ] **Does my change maintain architectural boundaries?**
  - No new framework dependencies in domain
  - Repository pattern preserved
  - Clean Architecture layers respected

### Quality Phase

- [ ] **Is this code better than before I touched it?**
  - "Leave it better than you found it"
  - Fix nearby code smells if simple
  - Refactor obvious issues

- [ ] **Would I be proud to have my name on this?**
  - Quality standard same as my own code
  - No shortcuts because "it wasn't mine"

- [ ] **Can I explain my changes in the PR?**
  - Clear description of what and why
  - Call out pattern changes
  - Note any potential issues

---

## Clean Up After Others Protocol

### The Boy Scout Rule

> "Always leave the campground cleaner than you found it."

**Applied to code:**
- If you're in a file, improve something
- Don't fix everything, but fix something
- Small improvements compound over time

### What to Clean Up

**Quick wins (< 5 minutes):**
- Rename confusing variables
- Extract magic numbers to constants
- Add missing type hints
- Fix formatting issues
- Add docblock comments

**Medium effort (5-30 minutes):**
- Extract long methods
- Create value objects from primitives
- Add missing tests for existing code
- Refactor duplicated logic
- Improve variable names

**Large efforts (30+ minutes):**
- Discuss with team first
- Create separate PR for major refactors
- Don't mix cleanup with feature work
- Get approval before big changes

### When NOT to Clean Up

**Don't clean up if:**
- Urgent bug fix in progress
- You don't understand the code well enough
- Tests don't exist to protect refactoring
- Change would affect many other files
- Cleanup is major architectural change

**In these cases:**
- Create a ticket for future cleanup
- Document the issue in code comments
- Raise in next architecture review
- Let someone with more context handle it

---

## Ownership vs. Stewardship

### Who Owns What?

| Scenario | Owner | Steward | Accountability |
|----------|-------|---------|----------------|
| Original code | Developer A | - | 100% Developer A |
| Bug fix in A's code | Developer A | Developer B | 50% A, 50% B |
| Feature added to A's code | Developer A | Developer B | B owns new feature, A owns original |
| Major refactor of A's code | Developer B | - | 100% Developer B (becomes new owner) |
| Small improvement | Developer A | Developer B | A owns module, B owns improvement |

### Transition Points

**You become the owner when:**
- You refactor >50% of the module
- You make 3+ significant changes
- Original author leaves the company
- You're designated module maintainer

**You remain a steward when:**
- Quick bug fixes
- Small improvements
- Feature additions that don't change structure
- Documentation updates

---

## When to Modify Others' Code

### Green Lights (Go Ahead)

**✅ Urgent bug fixes**
- Production issue needs immediate fix
- Don't wait for original author
- Fix it, then notify them

**✅ Obvious improvements**
- Clear code smell
- Missing test coverage
- Simple refactoring opportunity
- Documentation gaps

**✅ Feature work requiring changes**
- Your feature needs modification to existing code
- Follow patterns, make improvements
- Clear PR explanation

### Yellow Lights (Discuss First)

**⚠️ Architectural changes**
- Changing bounded context structure
- Major refactoring
- Pattern changes affecting multiple files
- Breaking API changes

**⚠️ Uncertain impact**
- Not sure if tests cover the area
- Complex business logic you don't fully understand
- Changes that might affect other teams
- Performance-critical code

**⚠️ Disagreement with approach**
- Original author made different choice than you would
- Want to change architectural pattern
- Think there's a better way

**Action:** Ping in Slack, quick sync call, or code review discussion

### Red Lights (Don't Do It)

**❌ Just to "make it your way"**
- Code works fine but you'd write it differently
- Personal preference, not quality improvement
- "I don't like this style"

**❌ Removing tests**
- Never remove tests without understanding why they exist
- If test is bad, improve it, don't delete it

**❌ Adding technical debt**
- Framework code in domain layer
- Skipping tests for speed
- Hardcoding values
- Bypassing architectural boundaries

---

## Knowledge Sharing Requirements

### When You Modify Someone's Code

**Notify original author:**
- Tag in PR: "@originalAuthor - modified your module, please review"
- Slack DM with context: "Hey, I fixed a bug in X, want to see what I found?"
- Don't surprise people with major changes

**Document your changes:**
- Clear PR description
- Code comments for non-obvious changes
- Update README if behavior changes
- Add to CHANGELOG if significant

**Share learnings:**
- Found a bug? Document the root cause
- Made improvement? Share the pattern in Slack
- Discovered edge case? Add to documentation

### When Your Code Is Modified

**Review the changes:**
- You're tagged on the PR automatically
- Review with same rigor as your own code
- Ask questions if you don't understand

**Learn from improvements:**
- Did they fix a bug you missed?
- Did they use a better pattern?
- Can you apply this elsewhere?

**Update your mental model:**
- If major changes, you need to re-learn your own code
- Don't assume you know how it works anymore
- Run tests, read changes, ask questions

### Team Knowledge Sharing

**Weekly architecture reviews:**
- Discuss interesting modifications
- Share patterns discovered
- Review controversial changes

**Pair programming rotations:**
- Work on someone else's code together
- Learn their patterns
- Share your knowledge

**Documentation culture:**
- Every module has a README
- Every bounded context has documentation
- Every major pattern has an example

---

## Examples

### Example 1: Bug Fix

**Scenario:** Sarah finds a bug in David's payment processing code.

**Wrong approach:**
```
Sarah: "David, there's a bug in your payment code, can you fix it?"
David: "I'm on client call all day, can it wait?"
Sarah: "It's blocking my work..."
Result: Delays, frustration
```

**Right approach:**
```
1. Sarah reads the payment module code
2. Sarah runs existing tests (they pass)
3. Sarah writes failing test demonstrating bug
4. Sarah fixes bug
5. Sarah ensures all tests pass
6. Sarah submits PR: "@David found bug in payment validation, added test + fix"
7. David reviews and approves
Result: Fast fix, improved tests, shared knowledge
```

### Example 2: Code Improvement

**Scenario:** Mike sees anemic entity in Lisa's code.

**Wrong approach:**
```
Mike refactors entire module without asking
Lisa sees PR: "WTF, why did you rewrite my code?"
Mike: "Your entities were anemic, fixed them"
Result: Conflict, wasted time, tension
```

**Right approach:**
```
1. Mike creates example showing the improvement
2. Mike posts in Slack: "@Lisa saw anemic entity in Order, happy to refactor if you want? Here's what it would look like..."
3. Lisa: "Oh nice catch! Yes please, I'd do it but busy with feature"
4. Mike refactors, following Lisa's existing patterns
5. Mike submits PR with clear explanation
6. Lisa reviews, learns the pattern
Result: Improvement, learning, collaboration
```

### Example 3: Feature Addition

**Scenario:** Alex needs to add email notifications to Jordan's user registration module.

**Right approach:**
```
1. Alex reads existing user registration code
2. Alex understands the bounded context (User Management)
3. Alex checks where notifications belong (could be separate context)
4. Alex discusses approach in architecture review
5. Team decides: notification is application service, separate from domain
6. Alex implements following established patterns
7. Alex submits PR with architectural decision documented
8. Jordan reviews domain changes, another senior reviews notification service
Result: Clean separation, proper patterns, team learning
```

---

## Success Metrics

### Individual Level

**You're doing collective ownership well when:**
- You've modified code from 3+ other developers
- Others have modified your code without issues
- No "not my code" excuses in code reviews
- You proactively improve code you encounter
- You can explain most modules in the system

### Team Level

**Team is doing collective ownership well when:**
- No bottlenecks waiting for "the expert"
- Quality remains high across all modules
- Knowledge spreads naturally through modifications
- No sacred code that people are afraid to touch
- New developers contribute everywhere within 3 months

---

## Common Questions

**Q: What if I break something?**
A: Tests catch it. If tests don't catch it, write a test. You're responsible for fixing what you break, but that's true of any code you write.

**Q: How much should I clean up while I'm there?**
A: Follow the Boy Scout Rule. Make one small improvement beyond your main change. Don't go on a refactoring spree unless that's the explicit purpose.

**Q: What if the original author disagrees with my changes?**
A: Discuss in the PR. If it's a standards issue, standards win. If it's architectural preference, senior developers decide. If it's minor style, original author's style wins.

**Q: Can I refactor an entire module if it's badly written?**
A: Not without discussion. Create a proposal, discuss in architecture review, get consensus. Major refactors affect everyone.

**Q: What if I don't have time to understand the code properly?**
A: Then don't modify it. Either make time to understand it, or ask for help. Blind modifications cause bugs.

---

## Remember

**Collective ownership is not permission to be reckless.**

It's **trust** that you'll treat every module with the same care as your own code. It's **responsibility** to maintain quality standards everywhere. It's **humility** to learn from others' code and improve your own.

**When you modify someone else's code, you're not just changing code—you're maintaining the partnership that makes OneSyntax work.**

---

*Related: [Development System](development-system.md) | [Code Review](code-review.md) | [Our Values](our-values.md)*
