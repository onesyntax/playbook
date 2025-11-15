# Deliberate Practice Program
**12-Week Training System for OneSyntax Standards**

Version: 1.0  
Last Updated: November 2025  
Owner: Kalpa (CEO)

---

## Overview

**Deliberate practice is how we learn DDD + Clean Architecture + TDD.**

This isn't passive reading. This is:
- ✅ Weekly coding exercises
- ✅ Immediate feedback from seniors
- ✅ Progressive difficulty
- ✅ Real-world scenarios
- ✅ Measurable improvement

**Time commitment:** 6-8 hours/week for 12 weeks

---

## Philosophy

> "We don't rise to the level of our expectations, we fall to the level of our training."

**Key principles:**
1. **Practice before production** - Learn in exercises, apply in real work
2. **Feedback is everything** - Fast, specific, actionable
3. **Repetition builds muscle memory** - Same patterns, different contexts
4. **Progressive overload** - Each week slightly harder
5. **Safe to fail** - Exercises are for learning, not evaluation

---

## Program Structure

### Weeks 1-4: Foundations
**Focus:** Rich domain models, value objects, entities

### Weeks 5-8: Architecture
**Focus:** Use cases, clean architecture, dependency rules

### Weeks 9-12: Advanced
**Focus:** Aggregates, domain events, complex scenarios

---

## Exercise Format

**Each exercise includes:**

1. **Business Scenario** - Real-world problem description
2. **Requirements** - What the code must do
3. **Constraints** - Architectural rules to follow
4. **Starter Code** - Minimal scaffolding
5. **Success Criteria** - How you know you're done
6. **Time Box** - Expected time (don't exceed by 2x)

**Submission:**
- Create PR with your solution
- Tag your assigned senior for review
- Discuss in next 1:1 or group session
- Iterate based on feedback

---

## Week 1: Rich Domain Models

### Exercise 1.1: Order with Business Rules

**Scenario:**
You're building an e-commerce system. An Order has items, a customer, and business rules about when it can be placed, cancelled, or shipped.

**Requirements:**
1. Order starts in "Draft" status
2. Must have at least 1 item to be placed
3. Can only be cancelled if not yet shipped
4. Total amount is automatically calculated from items
5. Can't add items after order is placed
6. Each item has product, quantity, and price

**Constraints:**
- ❌ No public setters (immutability)
- ❌ No anemic models (logic in Order, not service)
- ✅ Rich domain model with behavior
- ✅ Domain exceptions for violations
- ✅ Value objects for Money

**Success Criteria:**
- [ ] All business rules enforced
- [ ] Tests for each rule (TDD)
- [ ] No public setters
- [ ] Clear domain exceptions
- [ ] Money as value object

**Time Box:** 3-4 hours

---

### Exercise 1.2: User Registration with Email Validation

**Scenario:**
User registration with email validation, password strength requirements, and duplicate email prevention.

**Requirements:**
1. Email must be valid format
2. Email must be unique (check via repository)
3. Password must be 8+ chars with number and special char
4. User has firstname, lastname, email
5. User is inactive until email confirmed

**Constraints:**
- ✅ Email as value object
- ✅ Password as value object with validation
- ✅ User is entity (has identity)
- ❌ No validation in controller/service

**Time Box:** 3-4 hours

---

## Week 2-12 Exercises

[View full 12-week curriculum in the complete document]

**Week 2:** Value Objects & Entities  
**Week 3:** Aggregates & Boundaries  
**Week 4:** Domain Events  
**Week 5:** Application Layer (Use Cases)  
**Week 6:** Clean Architecture Layers  
**Week 7:** Testing Strategies  
**Week 8:** Repository Pattern  
**Week 9:** Advanced Aggregates  
**Week 10:** Event-Driven Architecture  
**Week 11:** Performance & Optimization  
**Week 12:** Real-World Complexity  

---

## Feedback & Review Process

### For Each Exercise

**Self-Review (Before submission):**
- [ ] Followed all constraints
- [ ] Tests pass
- [ ] Code is readable
- [ ] Meets success criteria

**Senior Review (Within 24 hours):**
- Architecture adherence
- Code quality
- Test coverage
- Suggest improvements

**Group Discussion (Weekly):**
- Common patterns
- Difficult scenarios
- Best solutions
- Lessons learned

---

## Success Metrics

**Individual:**
- Complete 90%+ of exercises
- Average score 8+/10
- Apply patterns in real work
- Can explain decisions

**Team:**
- Consistent architectural patterns
- Fewer code review issues
- Better test coverage
- Faster onboarding

---

## Questions?

- **Stuck on exercise:** Ask in #architecture
- **Need clarification:** Ask assigned senior
- **Want pairing:** Schedule with senior
- **General questions:** Weekly group session

---

**Remember:** Deliberate practice is hard. That's why it works.

**Let's build software that matters. Together.**
