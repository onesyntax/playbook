# Enforcement System
**How We Maintain Quality at OneSyntax**

Version: 1.0  
Last Updated: November 2025

---

## Philosophy

**Discipline isn't hoping people follow rules - it's building systems that make good architecture the default path.**

Our enforcement mechanisms aren't about mistrust. They're about:
- Making good practices easy
- Making bad practices hard
- Providing fast feedback
- Protecting our clients' investments

---

## Three Layers of Enforcement

### Layer 1: Automated (Fastest Feedback)
- ArchUnit tests
- Linters (ESLint, SonarLint)
- CI/CD quality gates

### Layer 2: Human Review (Quality Assurance)
- Code review by seniors
- Architecture review
- Pair programming

### Layer 3: Retrospective (Learning)
- Sprint retrospectives
- Quarterly architecture reviews
- Playbook updates

---

## Layer 1: Automated Enforcement

### ArchUnit (Architecture Testing)

**What it does:** Enforces architectural rules automatically

**Example rules:**
```java
// Domain must not depend on infrastructure
noClasses()
  .that().resideInAPackage("..domain..")
  .should().dependOnClassesThat()
  .resideInAPackage("..infrastructure..")

// Use cases should end with UseCase
classes()
  .that().resideInAPackage("..application.usecases..")
  .should().haveSimpleNameEndingWith("UseCase")

// Entities must not have public setters
classes()
  .that().resideInAPackage("..domain.entities..")
  .should().notHaveModifier(PUBLIC)
  .as("Entities should be immutable")
```

**When it runs:**
- Every test run (local)
- Every PR (CI/CD)
- Every deployment

**What happens when violated:**
- ❌ Tests fail
- ❌ PR blocked
- ❌ Cannot merge

---

### Linters

**ESLint/SonarLint Configuration:**

```json
{
  "rules": {
    "max-lines-per-function": ["error", 50],
    "complexity": ["error", 10],
    "max-depth": ["error", 3],
    "no-console": "error",
    "no-var": "error",
    "prefer-const": "error",
    "no-magic-numbers": ["error", { 
      "ignoreArrayIndexes": true 
    }]
  }
}
```

**Custom rules:**
- No anemic domain models
- No business logic in controllers
- No direct database access in domain

---

### CI/CD Quality Gates

**Pipeline stages:**

```yaml
1. Lint
   - ESLint
   - Prettier
   - Type checking

2. Test
   - Unit tests (>80% coverage)
   - Integration tests
   - ArchUnit tests

3. Quality
   - SonarQube analysis
   - Security scanning
   - Dependency checks

4. Build
   - Compile
   - Bundle
   - Package

5. Deploy (only if all pass)
```

**Failure = No deployment**

---

## Layer 2: Human Review

### Code Review Process

**Every PR requires:**
1. ✅ Senior developer approval
2. ✅ All tests passing
3. ✅ No linter errors
4. ✅ Architecture compliance

**Review checklist:**

**Domain Layer:**
- [ ] Rich domain models (not anemic)
- [ ] Business rules in entities/aggregates
- [ ] Proper use of value objects
- [ ] Domain events where appropriate
- [ ] Ubiquitous language used
- [ ] No framework dependencies

**Application Layer:**
- [ ] Use cases orchestrate only
- [ ] No business logic in use cases
- [ ] Proper dependency injection
- [ ] Commands/queries separated
- [ ] Error handling appropriate

**Infrastructure Layer:**
- [ ] Implements domain interfaces
- [ ] No business logic
- [ ] Proper mapping between layers
- [ ] Database-specific code isolated

**Tests:**
- [ ] Unit tests for domain logic
- [ ] Integration tests for use cases
- [ ] No mocking of domain models
- [ ] Test names describe behavior
- [ ] Arrange-Act-Assert structure

**General:**
- [ ] Code is readable
- [ ] Names are descriptive
- [ ] Functions are focused (<50 lines)
- [ ] No code duplication
- [ ] Documentation where needed

---

### Review Response SLA

**Junior code:**
- First review: <4 hours
- Follow-up: <2 hours

**Mid-level code:**
- First review: <8 hours
- Follow-up: <4 hours

**Senior code:**
- First review: <24 hours
- Follow-up: <12 hours

---

### Architecture Review

**When required:**
- New bounded contexts
- Major architectural changes
- New external integrations
- Performance-critical features

**Process:**
1. Submit architecture proposal
2. Review in Thursday architecture meeting
3. Kalpa + seniors discuss
4. Decision documented
5. Implementation proceeds

---

## Layer 3: Retrospective Learning

### Sprint Retrospectives

**Every sprint (bi-weekly):**

**Review:**
- What quality issues arose?
- What patterns worked well?
- What patterns didn't work?
- What can we improve?

**Actions:**
- Update playbook if needed
- Add new ArchUnit rules
- Create new exercises
- Adjust process

---

### Quarterly Architecture Review

**Every quarter:**

**Assess:**
- Architecture compliance metrics
- Code quality trends
- Team feedback
- Client feedback

**Update:**
- Standards if needed
- Enforcement rules
- Training materials
- Process improvements

---

## Handling Violations

### Automated Violations

**ArchUnit/Linter failures:**

1. Developer sees failure locally
2. Fixes before pushing
3. If pushed, CI/CD catches it
4. PR blocked until fixed
5. No exceptions

---

### Code Review Violations

**Minor issues:**
- Comment on PR
- Developer fixes
- Re-review
- Approve when fixed

**Major issues:**
- Discuss in call
- Pair to fix
- Learning opportunity
- Update exercises if pattern emerges

**Repeated violations:**
- 1-1 with manager
- Additional training
- Closer review for period
- Performance concern if continues

---

### Escalation

**If developer disagrees with standard:**

1. Discuss with reviewer
2. If unresolved, escalate to Kalpa
3. Kalpa makes final decision
4. Document rationale
5. Update playbook if needed

**If reviewer is inconsistent:**

1. Bring up in retrospective
2. Calibrate standards
3. Update playbook
4. Improve reviewer training

---

## Measuring Enforcement Effectiveness

### Weekly Metrics

**Compliance:**
- ArchUnit pass rate: >95%
- PR approval rate: >80% first review
- Average review time: <8 hours

**Quality:**
- Bug escape rate: <5 per sprint
- Production incidents: <2 per month
- Test coverage: >80%

**Team:**
- Developer satisfaction: >4/5
- Review feedback quality: >4/5
- Learning from reviews: >4/5

---

## Continuous Improvement

### Monthly Review

**Questions:**
- Are rules too strict/lenient?
- Are developers learning?
- Are clients satisfied?
- Can we improve feedback speed?

**Actions:**
- Adjust rules if needed
- Add/remove checks
- Improve review quality
- Update documentation

---

## Special Cases

### Legacy Code

**Refactoring strategy:**
- Don't enforce on existing code
- Enforce on new code
- Refactor opportunistically
- No big-bang rewrites

**When touching legacy:**
- Leave it better than you found it
- Add tests for what you change
- Improve architecture incrementally
- Document technical debt

---

### Urgent Bugs

**Process:**
- Fix bug first (to stop bleeding)
- Create test to prevent regression
- Refactor if needed
- Deploy
- Retrospect on root cause

**Standards still apply:**
- Tests required
- Code review required
- But expedited timeline

---

### Experimental Features

**Prototype phase:**
- Relaxed standards OK
- Focus on learning
- Rapid iteration

**Production phase:**
- Full standards apply
- Refactor before shipping
- No shortcuts

---

## Questions?

**About enforcement:**
- #architecture channel
- Architecture review meetings
- Kalpa directly

**Disagree with a rule?**
- Discuss in architecture review
- Provide reasoning
- Propose alternative
- We'll decide together

---

## Remember

**Enforcement serves our clients.**

Every rule exists to:
- Protect their investment
- Ensure system longevity
- Deliver quality software
- Honor their trust

**Not to slow you down, but to speed you up long-term.**

**Let's build software that matters. Together.**
