# Code Review Process & Checklist
**Quality Assurance Through Peer Review**

Version: 1.0  
Last Updated: November 2025

---

## Philosophy

**Code review is our second line of defense (after automated checks).**

Reviews are about:
- ✅ Ensuring architecture compliance
- ✅ Sharing knowledge
- ✅ Catching bugs early
- ✅ Improving code quality
- ✅ Mentoring developers

**NOT about:**
- ❌ Showing off knowledge
- ❌ Being pedantic about style
- ❌ Blocking without helping
- ❌ Personal preferences

---

## The Complete Review Checklist

### 1. Domain Layer
- [ ] Business logic in domain (not services)
- [ ] Rich models (not anemic)
- [ ] Value objects for measurements
- [ ] Proper aggregate boundaries
- [ ] Domain events for important moments

### 2. Application Layer
- [ ] Use cases orchestrate only
- [ ] No business logic in use cases
- [ ] Proper dependency injection
- [ ] Returns DTOs (not domain entities)

### 3. Infrastructure
- [ ] Implements domain interfaces
- [ ] No business logic
- [ ] Proper mapping
- [ ] Transaction handling

### 4. Presentation
- [ ] Thin controllers
- [ ] Input validation
- [ ] Proper error handling
- [ ] No business logic

### 5. Testing
- [ ] Unit tests for domain (>90%)
- [ ] Integration tests for use cases
- [ ] Tests describe behavior
- [ ] No mocking domain models

### 6. Code Quality
- [ ] Clear naming
- [ ] Functions <50 lines
- [ ] Single responsibility
- [ ] No code duplication

[Full checklist in complete document]

---

**Let's build software that matters. Together.**
