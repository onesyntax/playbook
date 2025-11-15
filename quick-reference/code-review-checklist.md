# Code Review Quick Checklist
**OneSyntax Code Review - Essential Checks**

Use this for every code review (author AND reviewer) ✅

---

## 🎯 Core Questions

Before you approve, answer these:

1. **Does it follow DDD/Clean Architecture?**
2. **Are business rules in the domain?**
3. **Is it testable and tested?**
4. **Would I be proud to show this to the client?**

If any answer is "no" → Request changes

---

## ✅ Author Checklist (Before Submitting PR)

### Domain-Driven Design
- [ ] Business logic is in domain layer (not use cases/controllers)
- [ ] Entities enforce their own invariants
- [ ] Value objects are immutable
- [ ] Aggregates have clear boundaries
- [ ] Ubiquitous language is used
- [ ] No anemic domain models

### Clean Architecture
- [ ] Dependencies point inward (domain ← use cases ← adapters ← IO)
- [ ] Domain has no framework dependencies
- [ ] Use cases are thin orchestrators
- [ ] Controllers only delegate to use cases
- [ ] Database/framework in IO layer

### Testing
- [ ] Unit tests for domain logic
- [ ] Integration tests for use cases
- [ ] Test names describe behavior (not implementation)
- [ ] Tests are readable and maintainable
- [ ] All tests pass locally
- [ ] Coverage is adequate (not just high %)

### Code Quality
- [ ] No commented-out code
- [ ] No console.log / debug statements
- [ ] Meaningful variable/function names
- [ ] Functions are small and focused
- [ ] No code duplication
- [ ] No magic numbers/strings

### Security
- [ ] No hardcoded credentials/secrets
- [ ] Input validation present
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Authentication/authorization checked

### Documentation
- [ ] Complex logic has comments explaining WHY
- [ ] Public APIs have JSDoc/PHPDoc
- [ ] README updated (if needed)
- [ ] Breaking changes documented

---

## ✅ Reviewer Checklist

### First Pass (5 minutes)
- [ ] PR description is clear
- [ ] Changes match the description
- [ ] Size is reasonable (<500 lines)
- [ ] Tests are present
- [ ] CI/CD passes

**If any fail → Ask author to fix before detailed review**

### Architecture Review (10-15 minutes)
- [ ] Follows DDD patterns
- [ ] Follows Clean Architecture
- [ ] Proper layer separation
- [ ] Domain is pure (no framework deps)
- [ ] Aggregates are right-sized
- [ ] Use cases are thin

### Logic Review (15-20 minutes)
- [ ] Business logic is correct
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No obvious bugs
- [ ] Performance is acceptable
- [ ] Security vulnerabilities checked

### Code Quality Review (10 minutes)
- [ ] Code is readable
- [ ] Naming is clear
- [ ] No unnecessary complexity
- [ ] SOLID principles followed
- [ ] DRY principle followed
- [ ] YAGNI principle followed

### Testing Review (10 minutes)
- [ ] Tests cover main scenarios
- [ ] Tests are readable
- [ ] Tests are meaningful (not just coverage)
- [ ] Edge cases tested
- [ ] Error cases tested
- [ ] Tests actually run (green ✅)

---

## 🚫 Auto-Reject Criteria

**Immediately request changes if:**

❌ Business logic in use cases/controllers
❌ Anemic domain models (just getters/setters)
❌ No tests for new functionality
❌ Failing tests
❌ Hardcoded credentials
❌ SQL injection vulnerabilities
❌ Framework dependencies in domain
❌ Breaking aggregate boundaries

---

## 💬 Giving Feedback

### Use This Format

**🔴 MUST FIX (blocking)**
```
❌ Business logic in use case
This validation should be in the Order entity, not the use case.
See: [DDD Guide](../2-standards/development-system.md#entities)
```

**🟡 SHOULD FIX (important but not blocking)**
```
⚠️ Consider extracting to value object
This money calculation could be a Money value object.
```

**🔵 NICE TO HAVE (suggestion)**
```
💡 Suggestion: Could simplify
This could be more readable as: `order.isValid()`
```

**🟢 GOOD (praise)**
```
✅ Excellent use of value object!
Love how this enforces immutability.
```

---

## 🎯 Common Issues & Fixes

### Issue: Anemic Domain Model
```typescript
// ❌ WRONG
class Order {
  public items: OrderItem[]
}

orderService.addItem(order, item) {
  order.items.push(item)
}
```

**Fix:**
```typescript
// ✅ RIGHT
class Order {
  private items: OrderItem[]

  addItem(item: OrderItem): void {
    this.validateItem(item)
    this.items.push(item)
  }
}
```

---

### Issue: Business Logic in Use Case
```typescript
// ❌ WRONG
class PlaceOrderUseCase {
  execute(command) {
    if (order.items.length === 0) {
      throw new Error()
    }
    if (order.total < 0) {
      throw new Error()
    }
    // ... validation logic
  }
}
```

**Fix:**
```typescript
// ✅ RIGHT
class PlaceOrderUseCase {
  execute(command) {
    order.place() // Validation inside domain!
    this.repo.save(order)
  }
}

class Order {
  place(): void {
    this.validateCanBePlaced()
    this.status = OrderStatus.Placed
  }
}
```

---

### Issue: Framework in Domain
```typescript
// ❌ WRONG
import { Model } from 'eloquent'

class Order extends Model {
  // Domain logic mixed with framework
}
```

**Fix:**
```typescript
// ✅ RIGHT
// Domain (pure TypeScript)
class Order {
  // Pure domain logic
}

// IO Layer (framework)
class OrderModel extends Model {
  toDomain(): Order {
    // Convert to domain
  }
}
```

---

## ⏱️ Time Budgets

- **Small PR (<100 lines):** 15-20 minutes
- **Medium PR (100-300 lines):** 30-45 minutes
- **Large PR (300-500 lines):** 60-90 minutes
- **Too Large (>500 lines):** Ask to split

**Can't finish in time?**
→ Ask author to split PR

---

## 🎯 Before You Approve

Final check:

- [ ] I understand what this code does
- [ ] I would be comfortable debugging this
- [ ] This follows OneSyntax standards
- [ ] Tests give me confidence
- [ ] Client would be happy with this quality

**If yes to all → APPROVE ✅**
**If no to any → REQUEST CHANGES 🔴**

---

## 💡 Pro Tips

1. **Review in multiple passes** (architecture → logic → quality)
2. **Start with tests** (they document behavior)
3. **Look for patterns** (is this the 3rd time we've done this?)
4. **Praise good work** (not just criticism)
5. **Link to playbook** (help people learn)
6. **Ask questions** ("Why did you...?" vs "This is wrong")

---

## 📚 Need Help?

**Process:** [Code Review Guide](../3-processes/code-review.md)
**Standards:** [Development System](../2-standards/development-system.md)
**Ask:** #architecture channel or @kalpa

---

## 🎯 Remember

**Code review isn't about finding mistakes.**

It's about:
- ✅ Maintaining quality for clients
- ✅ Teaching and learning together
- ✅ Protecting the codebase
- ✅ Building trust through excellence

**Every review is a chance to make our software better.**

---

*Print this checklist. Use it every time. No exceptions.*
