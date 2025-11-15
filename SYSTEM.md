# The OneSyntax Development System
## Building Quality Software Through True Partnership

**Version 1.0**  
**Last Updated: November 2025**

---

## Table of Contents

1. [The OneSyntax Way: Our Golden Circle](#the-onesyntax-way-our-golden-circle)
2. [Domain-Driven Design at OneSyntax](#domain-driven-design-at-onesyntax)
3. [Clean Architecture at OneSyntax](#clean-architecture-at-onesyntax)
4. [Code Review Standards](#code-review-standards)
5. [Testing Standards](#testing-standards)
6. [Enforcement Mechanisms](#enforcement-mechanisms)
7. [Senior Developer Training Plan](#senior-developer-training-plan)
8. [Implementation Roadmap](#implementation-roadmap)

---

## The OneSyntax Way: Our Golden Circle

### Why We Exist

I founded OneSyntax because **software development is broken by a lack of trust and true partnership**.

We've seen too many projects fail because:
- Developers and entrepreneurs don't truly partner together
- Teams work in isolation rather than collaborating
- Companies skip proven practices to "move fast"
- Products wait too long to validate with real users

**Our mission is to bridge this gap.**

### How We Deliver

We're different because we:
- **Challenge ideas** that won't work (not just say "yes" to everything)
- **Involve clients** in planning and key decisions
- **Validate early** with real users so feedback drives what we build
- **Practice XP/Agile properly** - not as buzzwords, but as our actual workflow
- **Stay accountable** and professional throughout the partnership

### What We Offer

- Custom software development
- Rapid prototyping and MVP creation
- Business validation and scaling
- Global-ready products
- Digital transformation services

### Our Technical Commitment

This document describes how we translate our mission into code. Every practice, pattern, and standard exists to support our core belief: **true partnership through accountable, professional development.**

---

## Domain-Driven Design at OneSyntax

### Why DDD Matters to Our Mission

**DDD is partnership in code.**

When we use the client's language in our code, we're partnering with their mental model. When we hide business logic behind technical jargon, we've broken the partnership - we're back to developers working in isolation.

**Core Principle:** Our code should be readable and understandable by the client. If a product owner can't recognize their business in our entity names and methods, we've failed at partnership.

### DDD Principles

#### 1. Use Ubiquitous Language

**Don't say (Technical):**
- `leadOpportunityStatus`
- `normalizedResponse`
- `processPayment`
- `handleBooking`

**Do say (Business Language):**
- `interestLevel`
- `leadResponse` or `prospectReply`
- `settleInvoice` or `completeTransaction`
- `confirmBooking` or `cancelBooking`

**Rule:** If the client doesn't use that word, neither should our code.

#### 2. Rich Domain Models (Not Anemic)

**What makes an entity "rich":**
- Business rules are explicit (e.g., `canBeCancelled()`)
- Domain language is used (`cancel()`, `confirm()`)
- Behavior is in the entity, not scattered in services
- Anyone reading the code understands the business
- Methods express business intent, not just data manipulation

**What makes an entity "anemic":**
- Only getters, setters, and database relationships
- No business behavior
- Business logic scattered in services
- Technical names that don't reflect business concepts

#### 3. Use Value Objects

**When to create a Value Object:**
- The concept has business meaning
- It has validation rules
- It appears in multiple places
- It's more than just a string/int

**Benefits:**
- Business rules are centralized
- Type safety (can't pass wrong values)
- Self-documenting code
- Easy to test

**Examples of good Value Objects:**
- InterestLevel (interested, delayed, not_interested, neutral)
- FollowUpRequest (date + reason + validation)
- MoneyAmount (amount + currency + calculations)
- EmailAddress (validation + domain logic)

#### 4. Domain Language Dictionary

For each major project/domain, maintain a dictionary of ubiquitous language:

**Example - Campaign Planner Domain:**

| We Say (Business) | NOT (Technical) |
|---|---|
| Qualify lead | Normalize response |
| Interest level | Lead opportunity status |
| Follow-up request | Delayed contact |
| Hot prospect | Interested status |
| Competitor mention | Alternative service reference |
| Prospect reply | Incoming response |

**Example - Booking Domain:**

| We Say (Business) | NOT (Technical) |
|---|---|
| Confirm booking | Process booking |
| Cancel booking | Delete booking |
| Guest | User record |
| Check-in date | Start date |
| Availability | Slot status |

**Rule:** Update this dictionary during project kickoff and keep it in the domain's README.md

### DDD Anti-Patterns (What NOT to Do)

#### ❌ Anti-Pattern 1: Anemic Domain Models

**Problem:**
- Entity is just a data container with no behavior
- Business logic scattered in services
- Technical service names hide business intent
- Client can't understand what the code does

**Solution:**
- Move business behavior into entities
- Entities should have domain methods
- Services only coordinate, entities execute

#### ❌ Anti-Pattern 2: Technical Naming

**Problem:**
- Class names like `DataNormalizer`, `RequestProcessor`
- Method names like `handlePayload`, `processData`
- Client has no idea what this does in business terms

**Solution:**
- Use business language from domain dictionary
- Names should reflect business intent
- Ask: "Would the client recognize this term?"

#### ❌ Anti-Pattern 3: Primitive Obsession

**Problem:**
- Using strings everywhere instead of value objects
- No validation or business rules
- Magic values scattered throughout code
- Hard to change or extend

**Solution:**
- Create value objects for business concepts
- Encapsulate validation and rules
- Make invalid states unrepresentable

### DDD Transformation Pattern

**Before (Anemic):**
- Technical class names
- No business behavior in entities
- Logic scattered in services
- Primitive types everywhere
- Hard to understand business rules

**After (Rich Domain):**
- Business language used throughout
- Entities contain business behavior
- Value objects for domain concepts
- Business rules explicit and testable
- Code readable by non-technical stakeholders

**Key Questions for Transformation:**
1. What's the ubiquitous language here?
2. What business rules exist?
3. What behavior belongs in this entity?
4. Do I need value objects?
5. Where does validation happen?

---

## Clean Architecture at OneSyntax

### Why Clean Architecture Matters to Our Mission

**Clean Architecture is accountability to the future.**

Other agencies deliver Laravel spaghetti and disappear. We architect for the client's future - when they need to scale, when they need to change frameworks, when they need to hand off to another team.

**Core Principle:** Business logic must be independent of frameworks, UI, databases, and external services. This ensures we're not creating vendor lock-in or technical debt.

### The OneSyntax Layer Structure

Every domain follows this structure:

```
DomainName/
├── Entities/             # Domain models and business rules
├── UseCases/             # Application business logic
│   └── Repositories/     # Repository interfaces
├── Adapters/             # Framework-agnostic interface adapters
│   └── Presenters/       # Output formatters for different interfaces
├── IO/                   # Frameworks, drivers, external services
│   ├── Database/         # Eloquent repositories, migrations
│   ├── Http/             # Controllers, requests, resources
│   ├── Console/          # Commands
│   └── ExternalServices/ # API clients
├── Specs/                # Tests
└── Testing/              # Test utilities
```

### The Dependency Rule

**Dependencies ALWAYS point inward:**

```
IO → Adapters → UseCases → Entities

✅ Controllers can depend on UseCases
✅ UseCases can depend on Entities
✅ Repositories (IO) can depend on Repository Interfaces (UseCases)

❌ Entities CANNOT depend on UseCases
❌ UseCases CANNOT depend on Controllers
❌ Entities CANNOT depend on framework-specific code (except pragmatically)
```

**Why this matters:**
- Business logic stays stable when frameworks change
- Easy to test without framework
- Can swap IO implementations without touching business logic
- Clear separation of concerns

### Three Approaches: When to Use What

OneSyntax supports three levels of Clean Architecture implementation. Choose based on project complexity:

#### Approach 1: Pragmatic (Simple Projects)

**When to use:**
- Simple CRUD operations
- Small team or solo dev
- Quick MVP or prototype
- Low complexity business logic

**Characteristics:**
- UseCases call Eloquent directly
- Minimal abstraction layers
- Faster to write
- Less boilerplate

**Trade-offs:**
- ✅ Faster to write
- ✅ Less boilerplate
- ❌ Harder to test in isolation
- ❌ Coupled to Eloquent

#### Approach 2: Standard (Most Projects)

**When to use:**
- Medium complexity
- Multiple data sources possible
- Need better testability
- Team with multiple developers

**Characteristics:**
- Repository pattern for data access
- UseCases depend on repository interfaces
- Clear separation of domain and IO
- Good testability

**Trade-offs:**
- ✅ Decoupled from Eloquent
- ✅ Easy to test
- ✅ Can swap data sources
- ❌ More boilerplate than pragmatic

#### Approach 3: Purist (Complex Projects)

**When to use:**
- High complexity
- Multiple interfaces (HTTP, CLI, GraphQL)
- Different output formats needed
- Enterprise-level projects

**Characteristics:**
- Presenter pattern for output formatting
- UseCases completely framework-agnostic
- Consistent error handling across interfaces
- Maximum flexibility

**Trade-offs:**
- ✅ Maximum decoupling
- ✅ Multiple interfaces supported
- ✅ Consistent error handling
- ❌ Most boilerplate
- ❌ Can be over-engineering for simple cases

### Decision Tree: Which Approach?

```
Is this a simple CRUD feature?
├─ Yes → Pragmatic
└─ No → Continue

Will you need multiple data sources or interfaces?
├─ Yes → Purist
└─ No → Continue

Is the business logic complex?
├─ Yes → Standard or Purist
└─ No → Pragmatic

Are there 5+ developers on the project?
├─ Yes → Standard minimum
└─ No → Pragmatic is fine

Default: When in doubt, use Standard approach
```

### Clean Architecture Anti-Patterns

#### ❌ Anti-Pattern 1: Business Logic in Controllers

**Problem:**
- Controllers contain business rules and validation
- Logic can't be reused from other interfaces (CLI, queues)
- Hard to test
- Violates single responsibility

**Solution:**
- Controllers should be thin
- Business logic belongs in UseCases
- Controllers handle HTTP concerns only (validation, response formatting)

#### ❌ Anti-Pattern 2: Framework Dependencies in Domain

**Problem:**
- Entities import framework-specific classes
- Business logic tied to Laravel/Illuminate
- Can't test without framework
- Creates technical debt

**Solution:**
- Keep domain layer framework-agnostic
- No Illuminate imports in Entities or UseCases (except pragmatic Eloquent in Entities)
- Move framework concerns to IO layer

#### ❌ Anti-Pattern 3: Mixing IO Concerns with Business Logic

**Problem:**
- UseCases handling HTTP requests directly
- Business logic aware of presentation format
- Can't reuse logic across interfaces

**Solution:**
- UseCases work with DTOs or domain objects
- Presentation handled in Controllers/Presenters
- Business logic independent of delivery mechanism

### Architecture Decision Documentation

**For each domain, document in README.md:**

1. **Approach chosen:** Pragmatic/Standard/Purist
2. **Why:** Business reasoning for the choice
3. **Key characteristics:** What makes this domain special
4. **Trade-offs accepted:** What we're optimizing for

**Example:**
```markdown
# Booking Domain

**Approach:** Standard (Repository pattern)

**Why:** Need to support multiple data sources (MySQL + external calendar API). 
Business logic is complex enough to warrant testing in isolation.

**Key Characteristics:**
- Multi-tenant booking system
- Integration with external calendar services
- Complex availability calculation rules

**Trade-offs:** 
- More boilerplate than pragmatic, but worth it for testability
- Not using presenters (yet) - may add if we need GraphQL interface
```

---

## Code Review Standards

### The OneSyntax Code Review Philosophy

**Code reviews are NOT about finding mistakes - they're about maintaining our promise to clients.**

Every review is an opportunity to ensure:
- Partnership (DDD) is maintained in code
- Accountability (CA) is preserved for the future
- Professionalism (quality) is demonstrated

### Pre-Submission Checklist (For Developers)

Before submitting a PR, verify:

#### Partnership (DDD)
- [ ] Entities use ubiquitous language (checked against Domain Dictionary)
- [ ] Entities have behavior methods (list them in PR description)
- [ ] Business rules are explicit and in domain layer
- [ ] Value objects used where appropriate
- [ ] Code is readable by non-technical stakeholders

#### Accountability (CA)
- [ ] No framework dependencies in Entities layer
- [ ] No framework dependencies in UseCases layer
- [ ] Business logic is in UseCases, not Controllers
- [ ] IO layer properly separated
- [ ] Chose appropriate approach (Pragmatic/Standard/Purist) with justification

#### Professionalism (Quality)
- [ ] Tests cover domain logic
- [ ] Tests use domain Testing utilities
- [ ] Code follows PSR-12
- [ ] No obvious security issues
- [ ] Performance considerations addressed

### Review Checklist (For Reviewers)

#### Level 1: Automated Checks (Must Pass)
- [ ] PHP CS Fixer passes
- [ ] PHPStan passes
- [ ] Tests pass
- [ ] Architecture tests pass

#### Level 2: Domain Review
- [ ] **Anemic entities?** → Request behavior methods
- [ ] **Technical naming?** → Request ubiquitous language
- [ ] **Primitive obsession?** → Suggest value objects
- [ ] **Business logic scattered?** → Request consolidation
- [ ] **Domain rules unclear?** → Request explicit methods

#### Level 3: Architecture Review
- [ ] **Framework in domain?** → Must move to IO layer
- [ ] **Business logic in controller?** → Must move to UseCase
- [ ] **Wrong layer choice?** → Discuss and justify
- [ ] **Unnecessary complexity?** → Simplify
- [ ] **Missing abstraction?** → Add repository/presenter if needed

#### Level 4: Quality Review
- [ ] **Test coverage adequate?** → Request missing tests
- [ ] **Test quality good?** → Check assertions, edge cases
- [ ] **Security issues?** → Flag and discuss
- [ ] **Performance concerns?** → Benchmark and optimize

### Review Response Templates

Use these templates to provide educational feedback:

#### Template 1: Anemic Entity

```markdown
❗️This entity breaks OneSyntax's partnership promise.

**Current code:**
The [EntityName] entity is a passive data container. Business logic is scattered in services.

**Why this matters:**
Our clients trust us to understand their business. When business rules are hidden in services with technical names, we're working in isolation from their mental model.

**Requested changes:**
1. Move business logic into the entity as behavior methods
2. Use ubiquitous language from domain dictionary
3. Make business rules explicit

**Example:**
See [ReferenceProject]/[Domain]/Entities/[Example].php for rich domain model example.
```

#### Template 2: Framework Leakage

```markdown
❗️This violates Clean Architecture - framework dependency in domain layer.

**Current code:**
[File path] imports framework-specific classes

**Why this matters:**
We promise clients their software will last. Framework dependencies in domain create technical debt. When Laravel updates, we shouldn't need to touch domain logic.

**Requested changes:**
1. Remove framework imports from domain layer
2. Pass primitive values or DTOs to entity methods
3. Move framework concerns to IO layer

**Reference:**
See "Clean Architecture Anti-Patterns" section in OneSyntax Development System
```

#### Template 3: Business Logic in Controller

```markdown
❗️Business logic belongs in UseCases, not Controllers.

**Current code:**
[ControllerName] contains business rules and validation

**Why this matters:**
Controllers are IO layer - they should be thin. Business logic in controllers makes it impossible to reuse from CLI, queues, or other interfaces. This violates our accountability to build maintainable software.

**Requested changes:**
1. Create [UseCaseName] use case
2. Move business logic to use case
3. Controller should only handle HTTP concerns (validation, response formatting)

**Approach:**
Use [Pragmatic/Standard/Purist] approach because [reason]
```

### Approval Guidelines

**1 Senior Approval Required for:**
- Standard features following established patterns
- Simple CRUD operations
- Bug fixes
- Documentation updates

**2 Senior Approvals Required for:**
- New domain modules
- Architecture pattern changes
- Introducing new dependencies
- Database migrations affecting production

**Kalpa Approval Required for:**
- Changes to core architecture
- New architectural patterns
- Major refactoring of existing domains
- Security-critical changes

### Review SLA

- Simple PRs (<200 lines): 24 hours
- Medium PRs (200-500 lines): 48 hours
- Large PRs (>500 lines): 72 hours or split into smaller PRs

**If review is blocked:** Developer can request urgent review in #engineering Slack channel.

### Educational Feedback Principles

**Good feedback:**
- Explains WHY, not just WHAT
- References OneSyntax mission/values
- Provides examples or documentation links
- Suggests specific improvements
- Educates for future decisions

**Bad feedback:**
- Just says "wrong" or "change this"
- No context or reasoning
- Vague or unclear expectations
- Focuses on personal preference
- Makes developer feel criticized

---

## Testing Standards

### Why Testing Matters to Our Mission

**Tests are proof of professional accountability.**

Other agencies skip tests and disappear. We test because we're accountable beyond the first deploy. Tests prove the software works and protect clients from regressions.

### Test Categories

#### 1. Unit Tests (Entities & Value Objects)

**What:** Test business logic in isolation  
**Location:** `app/DomainName/Specs/Unit/`  
**Coverage Target:** 100% of domain logic

**Focus on:**
- Business rules in entities
- Value object validation
- Edge cases and error conditions
- Domain logic calculations

**Characteristics:**
- Fast (< 100ms per test)
- No database or external dependencies
- Test single concept per test
- Use mocks for dependencies

#### 2. Use Case Tests (Application Logic)

**What:** Test business workflows  
**Location:** `app/DomainName/Specs/UseCases/`  
**Coverage Target:** All use cases, happy path + major edge cases

**Focus on:**
- Complete workflows
- Integration between entities
- Repository interactions (mocked)
- Error handling and exceptions

**Characteristics:**
- Test use case behavior, not implementation
- Use repository mocks
- Verify correct entity methods called
- Test both success and failure paths

#### 3. Integration Tests (Full Flow)

**What:** Test complete features including database  
**Location:** `tests/Feature/`  
**Coverage Target:** Critical user journeys

**Focus on:**
- End-to-end workflows
- Database persistence
- API contracts
- User-facing functionality

**Characteristics:**
- Include database (RefreshDatabase)
- Test via HTTP/CLI interfaces
- Verify actual side effects
- Slower but comprehensive

### Test Quality Standards

#### Good Test Characteristics

✅ **Descriptive names:** `it_can_be_cancelled_when_active_and_not_started()`  
✅ **Arrange-Act-Assert pattern:** Clear sections  
✅ **One concept per test:** Don't test multiple things  
✅ **No test interdependence:** Tests run in any order  
✅ **Fast:** Unit tests < 100ms, integration tests < 500ms

#### Bad Test Characteristics

❌ **Vague names:** `test_booking()`  
❌ **Testing implementation:** Testing private methods  
❌ **Brittle:** Breaks when implementation changes (but behavior doesn't)  
❌ **Slow:** Making unnecessary external calls  
❌ **Incomplete:** Not testing edge cases

### Testing Approach by Layer

**Entities:**
- Unit test all business methods
- Test validation rules
- Test state changes
- Test edge cases

**UseCases:**
- Test with repository mocks
- Test happy path
- Test error conditions
- Test business workflow logic

**Controllers:**
- Integration test main flows
- Test authentication/authorization
- Test request validation
- Test response formatting

### Coverage Requirements

- **Domain logic (Entities/UseCases):** 90%+ coverage
- **Controllers:** 70%+ coverage (focus on error handling)
- **Overall project:** 80%+ coverage

### Testing Utilities

Each domain should provide testing utilities:

**Repository Mocks:**
- Implement repository interfaces
- Provide helper methods for tests
- Track what was saved/queried
- Easy to set up test data

**Test Factories:**
- Create valid domain objects quickly
- Support different states (active, cancelled, etc.)
- Reduce test setup boilerplate

**Assertion Helpers:**
- Domain-specific assertions
- Clear error messages
- Reduce test verbosity

---

## Enforcement Mechanisms

### Why Enforcement Matters to Our Mission

**Enforcement isn't about mistrust - it's proof we're disciplined.**

We say we practice XP/Agile properly, not as buzzwords. Automated enforcement proves it. When clients ask "how do you ensure quality?" we show them the guardrails, not promises.

### Enforcement Philosophy

**Good enforcement:**
- Catches mistakes before they become problems
- Makes good architecture the easy path
- Provides immediate feedback
- Teaches through prevention

**Bad enforcement:**
- Feels like micromanagement
- Slows down development unnecessarily
- Focuses on style over substance
- Blocks without educating

### Layer 1: Pre-Commit Enforcement

**Goal:** Catch violations before they're committed

**Tools:**
- PHP CS Fixer (code style)
- PHPStan (static analysis)
- Git pre-commit hooks (force checks)

**What it catches:**
- Code style violations
- Type errors
- Obvious bugs
- Framework imports in domain layer

**Developer experience:**
- Fast feedback (< 30 seconds)
- Runs on developer machine
- Can't commit broken code
- Learn correct patterns immediately

### Layer 2: Pull Request Enforcement

**Goal:** Block merges that violate architecture

**Tools:**
- GitHub PR templates with checklists
- Branch protection rules
- Required approvals from seniors
- CODEOWNERS for architecture files

**What it catches:**
- Missing documentation
- Incomplete checklists
- Architecture violations
- Insufficient testing

**Review process:**
- All automated checks must pass first
- Seniors verify architectural decisions
- Educational feedback provided
- No merge until approved

### Layer 3: Automated Architecture Tests

**Goal:** Verify architectural boundaries programmatically

**What they test:**
- No framework in Entities layer
- No framework in UseCases layer
- Controllers only call UseCases
- Entities have behavior (not anemic)

**Characteristics:**
- Run in CI/CD pipeline
- Fast (< 10 seconds)
- Clear failure messages
- Easy to add new rules

### Layer 4: Continuous Integration

**Goal:** Maintain quality over time

**Pipeline stages:**
1. Code style check (PHP CS Fixer)
2. Static analysis (PHPStan)
3. Architecture tests
4. Unit tests
5. Integration tests
6. Coverage report

**Failure handling:**
- PR cannot merge if any stage fails
- Clear feedback on what failed
- Link to relevant documentation
- Encourage fixing before re-review

### Layer 5: Weekly Health Checks

**Goal:** Monitor code quality trends

**Automated checks:**
- Scan for anemic entities
- Find framework leakage in domain
- Identify missing tests
- Check for complex use cases

**Reporting:**
- Weekly automated report
- Sent to #engineering channel
- Trends over time
- Action items for team

**What it catches:**
- Architecture drift
- Accumulating technical debt
- Patterns of violations
- Training opportunities

### Enforcement Maturity Model

**Level 1: Manual (Current State)**
- Kalpa catches everything in review
- No automated checks
- Inconsistent standards
- High review burden

**Level 2: Basic Automation (Month 1-2)**
- Code style automated
- Basic static analysis
- Simple architecture tests
- Still requires manual review

**Level 3: Comprehensive (Month 3-4)**
- All layers implemented
- Architecture tests robust
- CI/CD enforcing all checks
- Seniors can review effectively

**Level 4: Self-Improving (Month 5+)**
- Team identifies new patterns
- Automated checks updated
- Documentation improved
- System maintains itself

---

## Senior Developer Training Plan

### Training Philosophy

**We're not just teaching patterns - we're developing guardians of OneSyntax's mission.**

When seniors understand WHY (not just WHAT), they become ambassadors who can:
- Make architecture decisions aligned with our values
- Teach juniors with conviction
- Keep OneSyntax's promise when Kalpa isn't in the room

### Phase 1: Foundation (Week 1-2)

**Goal:** Seniors understand the WHY behind DDD/CA

#### Week 1: Golden Circle + DDD

**Monday (2 hours): Golden Circle Workshop**
- Share OneSyntax's mission and values
- Connect mission to technical practices
- Discussion: "What does partnership in code mean?"

**Wednesday (2 hours): DDD Deep Dive**
- Read: OneSyntax-Development-System.md (DDD section)
- Review: Real anemic vs rich examples from our codebase
- Exercise: Transform one anemic entity together

**Friday (1 hour): Homework Assignment**
- Each senior picks one feature from current project
- Identify: Is the entity anemic or rich?
- Plan: How would you refactor it?

#### Week 2: Clean Architecture

**Monday (2 hours): CA Workshop**
- Three approaches: When to use what
- Dependency rule deep dive
- Review: CA anti-patterns in our codebase

**Wednesday (2 hours): Decision Practice**
- Present 5 real scenarios
- Seniors decide: Pragmatic/Standard/Purist?
- Discuss reasoning and trade-offs

**Friday (2 hours): Refactoring Session**
- Each senior presents their homework
- Group feedback and discussion
- Kalpa provides guidance

### Phase 2: Practice (Week 3-6)

**Goal:** Seniors build muscle memory through hands-on practice

#### Weekly Structure

**Monday: Pairing with Kalpa (2 hours per senior, rotating)**
- Senior refactors chosen feature
- Kalpa guides, asks questions, doesn't give answers
- Focus on thought process, not just code

**Wednesday: Peer Review Practice**
- Seniors review each other's PRs
- Practice giving educational feedback
- Kalpa reviews the reviews (meta-review)

**Friday: Architecture Discussion (1 hour, all seniors)**
- Share learnings from the week
- Discuss challenging scenarios
- Build collective knowledge

#### Individual Assignments

Each senior must complete:
1. Transform 2 anemic entities to rich models
2. Refactor 1 controller with business logic to UseCase pattern
3. Write architecture tests for their domain
4. Create 1 value object for common concept

### Phase 3: Teaching (Week 7-10)

**Goal:** Seniors can teach DDD/CA to others

#### Week 7-8: Prepare Training Materials

Each senior creates:
- One "Before/After" example from their domain
- One anti-pattern guide (common mistake + solution)
- One teaching exercise for juniors

Kalpa reviews and provides feedback

#### Week 9-10: Junior Developer Workshops

- Each senior runs 1-hour workshop for mid/junior devs
- Teaches DDD or CA concepts
- Uses their prepared materials
- Kalpa observes and provides feedback

### Phase 4: Autonomy (Week 11+)

**Goal:** Seniors make architecture decisions independently

#### Week 11-12: Shadowing

- Seniors handle all code reviews (Kalpa only spot-checks)
- Seniors make architecture decisions (Kalpa available for consultation)
- Weekly retro: What went well, what was challenging

#### Month 4+: Full Autonomy

- Seniors fully autonomous for standard decisions
- Kalpa only involved in major changes
- Monthly architecture review meeting

### Success Metrics

**Seniors are ready when they can:**

1. **Explain WHY (not just WHAT)**
   - "We do DDD because it's partnership in code"
   - "We do CA because we're accountable to the future"

2. **Identify violations independently**
   - Spot anemic entities in code review
   - Catch framework leakage
   - Recognize business logic in wrong layer

3. **Make good trade-offs**
   - Choose correct approach (Pragmatic/Standard/Purist)
   - Justify decisions with business reasoning
   - Know when to consult vs decide

4. **Teach others effectively**
   - Give educational feedback (not just "wrong")
   - Use OneSyntax mission in explanations
   - Help juniors understand WHY

5. **Maintain standards without Kalpa**
   - Enforce quality in reviews
   - Keep team aligned with OneSyntax values
   - Escalate genuinely complex decisions

### Training Resources

**Required Reading:**
- This document (OneSyntax-Development-System.md)
- OneSyntax Coding Standards (separate document)
- "Domain-Driven Design" by Eric Evans (relevant chapters)
- "Clean Architecture" by Robert C. Martin (relevant chapters)

**Reference Projects:**
- [Project A] - Example of Standard approach
- [Project B] - Example of Purist approach
- [Project C] - Example of DDD done well

**Communication Channels:**
- #architecture - For questions and discussions
- Weekly architecture discussions
- Monthly all-hands on quality

**1-on-1s with Kalpa:**
- Weekly during training (Weeks 1-12)
- Bi-weekly during transition (Weeks 13-24)
- Monthly after autonomy (Month 6+)
- Discuss: challenges, decisions, growth

---

## Implementation Roadmap

### Overview

This roadmap takes you from current state (everything depends on Kalpa) to target state (seniors can run the system).

**Total Timeline: 6 months to full autonomy**

### Current State Analysis

**Today:**
- Kalpa spends 50% time on code reviews (20 hours/week)
- No written standards or documentation
- No automated enforcement
- Seniors can't make architecture decisions
- Quality depends entirely on Kalpa

**Problems:**
- Doesn't scale beyond 10 developers
- Kalpa is bottleneck for all projects
- Inconsistent quality when Kalpa is busy
- New developers take too long to onboard
- Can't delegate or take vacation

### Target State

**After 6 months:**
- Kalpa spends 10% time on reviews (4 hours/week)
- Complete documentation and standards
- Automated enforcement catching 80% of issues
- Seniors making most architecture decisions
- Quality maintained without Kalpa

**Benefits:**
- Can scale to 20+ developers
- Faster delivery (no bottleneck)
- Consistent quality across all projects
- New developers productive faster
- Kalpa can focus on strategy/growth

### Month 1: Build the Foundation

#### Week 1: Documentation
**Deliverables:**
- [ ] Finalize OneSyntax Development System document
- [ ] Create domain language dictionaries for top 3 projects
- [ ] Identify 5-10 before/after examples from codebase
- [ ] Share and review with all seniors

**Time Investment:**
- Kalpa: 10 hours
- Seniors: 4 hours each (reading/feedback)

**Success Criteria:**
- All seniors have read document
- Initial feedback incorporated
- Dictionary started for 3 domains

#### Week 2: Enforcement Setup
**Deliverables:**
- [ ] Configure PHP CS Fixer
- [ ] Configure PHPStan with custom rules
- [ ] Create basic architecture tests
- [ ] Set up GitHub workflows
- [ ] Create PR template with checklists

**Time Investment:**
- Kalpa: 12 hours
- Seniors: 2 hours (testing tools)

**Success Criteria:**
- All tools running in CI/CD
- Pre-commit hooks working
- PR template in use

#### Week 3: Prepare Training
**Deliverables:**
- [ ] Prepare Golden Circle workshop materials
- [ ] Create DDD/CA practice exercises
- [ ] Choose reference implementation project
- [ ] Schedule all Month 2-3 training sessions

**Time Investment:**
- Kalpa: 6 hours

**Success Criteria:**
- Calendar invites sent
- Materials prepared
- Exercises ready

#### Week 4: Golden Circle + DDD Workshop
**Deliverables:**
- [ ] Run Monday workshop (Golden Circle + DDD intro)
- [ ] Run Wednesday session (DDD deep dive)
- [ ] Assign homework exercises
- [ ] Seniors complete reading

**Time Investment:**
- Kalpa: 6 hours (workshops)
- Seniors: 8 hours each (workshops + homework)

**Success Criteria:**
- Seniors can explain OneSyntax mission
- Seniors understand DDD concepts
- Homework assigned and started

### Month 2: Initial Training

#### Week 5: CA Workshop + Practice
**Deliverables:**
- [ ] Run CA workshop (Monday, 2 hours)
- [ ] Run decision practice session (Wednesday, 2 hours)
- [ ] Review homework (Friday, 2 hours)
- [ ] Discuss architectural approaches

**Time Investment:**
- Kalpa: 6 hours
- Seniors: 8 hours each

**Success Criteria:**
- Seniors understand three approaches
- Can choose correct approach for scenarios
- Homework completed and reviewed

#### Week 6-8: Pairing Sessions
**Deliverables:**
- [ ] Each senior pairs with Kalpa 2 hours/week
- [ ] Seniors refactor chosen features
- [ ] Peer review practice sessions (Wednesday)
- [ ] Weekly architecture discussions (Friday)

**Time Investment:**
- Kalpa: 8 hours/week (2h × 4 seniors)
- Seniors: 6 hours/week each

**Success Criteria:**
- Each senior completes 2 refactoring exercises
- Peer reviews improving in quality
- Shared learnings documented

### Month 3: Hands-On Practice

#### Week 9-12: Refactoring Projects
**Deliverables:**
- [ ] Seniors complete assigned refactoring tasks
- [ ] Weekly architecture discussions (1 hour Friday)
- [ ] Kalpa provides meta-reviews of PR reviews
- [ ] Continuous improvement of enforcement tools

**Time Investment:**
- Kalpa: 6 hours/week
- Seniors: 8 hours/week each

**Success Criteria:**
- 2 refactored features per senior
- Seniors giving good code review feedback
- Architectural violations decreasing

**Milestone Check:** 
By end of Month 3, seniors should be able to:
- Identify anemic entities independently
- Explain WHY behind DDD/CA decisions
- Give educational feedback in reviews
- Choose correct architectural approach

### Month 4: Teaching Others

#### Week 13-14: Prepare Teaching Materials
**Deliverables:**
- [ ] Seniors create before/after examples from their domains
- [ ] Seniors create anti-pattern guides
- [ ] Seniors prepare junior workshop materials
- [ ] Kalpa reviews and provides feedback

**Time Investment:**
- Kalpa: 4 hours (reviews)
- Seniors: 6 hours each

**Success Criteria:**
- Teaching materials created
- Materials reviewed and approved
- Workshops scheduled

#### Week 15-16: Run Junior Workshops
**Deliverables:**
- [ ] Each senior teaches 1-hour workshop to juniors
- [ ] Kalpa observes and provides feedback
- [ ] Collect feedback from junior developers
- [ ] Iterate on teaching materials

**Time Investment:**
- Kalpa: 4 hours (observing)
- Seniors: 4 hours each (prep + delivery)
- Juniors: 4 hours total (attending)

**Success Criteria:**
- All seniors complete teaching session
- Positive feedback from juniors
- Juniors understand basic DDD/CA concepts

### Month 5: Supervised Autonomy

#### Week 17-20: Seniors Lead Reviews
**Deliverables:**
- [ ] Seniors handle 100% of code reviews
- [ ] Kalpa spot-checks 20% of reviews
- [ ] Weekly retro on decisions made
- [ ] Document edge cases and learnings

**Time Investment:**
- Kalpa: 4 hours/week (spot checks + retros)
- Seniors: Normal review time (now doing all reviews)

**Success Criteria:**
- Reviews maintain quality without Kalpa
- Fewer escalations needed
- Documented edge cases growing
- Team confidence increasing

**Milestone Check:**
By end of Month 5, seniors should handle 80% of decisions without Kalpa.

### Month 6: Full Autonomy

#### Week 21-24: Independence
**Deliverables:**
- [ ] Seniors fully autonomous for standard decisions
- [ ] Kalpa only consulted for major architectural changes
- [ ] Monthly architecture review meeting established
- [ ] System health checks running automatically
- [ ] Documentation updated based on learnings

**Time Investment:**
- Kalpa: 2-3 hours/week (strategic decisions only)
- Seniors: Normal workload

**Success Criteria:**
- Seniors making decisions independently
- Quality metrics maintained or improved
- Kalpa's review time < 10%
- Team functioning without bottlenecks

**Target State Achieved:**
- ✅ Seniors make DDD/CA decisions independently
- ✅ Seniors teach and mentor juniors
- ✅ Automated enforcement catches violations
- ✅ Kalpa's review time drops from 50% to 10%
- ✅ OneSyntax promise maintained without Kalpa

### Success Indicators

**After Month 3:**
- [ ] All seniors can identify anemic entities
- [ ] All seniors can explain WHY behind DDD/CA
- [ ] Code quality metrics stable or improving
- [ ] Fewer architecture violations in PRs
- [ ] Seniors giving educational feedback

**After Month 6:**
- [ ] Seniors handle 80%+ of code reviews
- [ ] Architecture tests consistently pass
- [ ] Junior devs understand OneSyntax standards
- [ ] Client feedback remains positive
- [ ] Kalpa's code review time < 20%
- [ ] Can onboard new developers without Kalpa

### Risk Mitigation

**Risk 1: Seniors don't have time for training**
- **Impact:** High - Training fails if not prioritized
- **Mitigation:** Reduce billable hours target during training months
- **Action:** Allocate 20% of senior time to training (10 hours/week)
- **Adjust:** Project timelines to account for training time

**Risk 2: Resistance to change**
- **Impact:** Medium - Adoption slow if seniors resistant
- **Mitigation:** Start with Golden Circle workshop, explain WHY
- **Action:** Frame as leadership development, not criticism
- **Involve:** Seniors in creating solutions

**Risk 3: Training takes longer than expected**
- **Impact:** Medium - Timeline extends
- **Mitigation:** Build buffer into timeline
- **Action:** Can extend Phase 2 if needed
- **Principle:** Better to train well than train fast

**Risk 4: Junior devs fall behind**
- **Impact:** Low - Productivity dip temporary
- **Mitigation:** Seniors teach juniors in Month 4
- **Action:** Provide simplified documentation for juniors
- **Support:** Pair juniors with seniors on real work

**Risk 5: Quality drops during transition**
- **Impact:** High - Client impact if quality suffers
- **Mitigation:** Kalpa maintains oversight through Month 5
- **Action:** Spot-check reviews, provide feedback
- **Escalation:** Step in if quality issues detected

**Risk 6: Enforcement tools too strict**
- **Impact:** Low - Developer frustration
- **Mitigation:** Start lenient, increase strictness gradually
- **Action:** Gather feedback, adjust rules
- **Balance:** Helpful vs hindering

### Investment Summary

**Kalpa's Time Investment:**
- Month 1: ~34 hours (documentation + setup)
- Month 2: ~30 hours (training + pairing)
- Month 3: ~24 hours (pairing + reviews)
- Month 4: ~16 hours (oversight)
- Month 5: ~16 hours (spot checks)
- Month 6+: ~10 hours/month (strategic only)

**Total: ~120 hours over 6 months**

**Return on Investment:**
- Current state: 50% of time = 20 hours/week on reviews
- Target state: 10% of time = 4 hours/week on reviews
- **Savings: 16 hours/week after 6 months**
- **ROI: 64 hours/month saved after 2-month break-even**

**Break-even Analysis:**
- Investment: 120 hours
- Savings: 16 hours/week
- Break-even: 7.5 weeks (< 2 months)
- After Month 2, every week is net positive

**Long-term Value:**
- Scalable to 20+ developers
- Quality maintained without Kalpa
- Faster onboarding of new developers
- Kalpa can focus on growth/strategy
- Sustainable competitive advantage

---

## Quick Reference Guide

### Before Creating an Entity

Ask yourself:
- [ ] What's the ubiquitous language term?
- [ ] What business rules does this entity have?
- [ ] What behavior methods should it have?
- [ ] Do I need value objects?
- [ ] Where does validation happen?

### Before Creating a UseCase

Ask yourself:
- [ ] What's the business workflow I'm implementing?
- [ ] Which approach fits: Pragmatic/Standard/Purist?
- [ ] What are the inputs and outputs?
- [ ] What can go wrong (exceptions)?
- [ ] How will I test this?
- [ ] Does this belong in an existing UseCase?

### Before Submitting a PR

Verify:
- [ ] Ran PHP CS Fixer
- [ ] Ran PHPStan
- [ ] All tests pass
- [ ] Architecture tests pass
- [ ] PR checklist completed
- [ ] Domain Dictionary updated (if new terms added)
- [ ] Tests written for new code
- [ ] Documentation updated if needed

### When Reviewing Code

Check for:
- [ ] **DDD:** Ubiquitous language used?
- [ ] **DDD:** Entities have behavior?
- [ ] **DDD:** Business rules explicit?
- [ ] **CA:** No framework in domain?
- [ ] **CA:** Business logic in right layer?
- [ ] **CA:** Correct approach chosen?
- [ ] **Quality:** Tests adequate?
- [ ] **Quality:** No security issues?

### Decision Framework: Which CA Approach?

**Use Pragmatic when:**
- Simple CRUD
- Low complexity
- Small team
- Quick prototype

**Use Standard when:**
- Medium complexity
- Multiple data sources
- Need testability
- Team project

**Use Purist when:**
- High complexity
- Multiple interfaces
- Enterprise scale
- Different output formats

**When in doubt:** Use Standard

### Common Patterns Reference

For detailed code examples, see: **OneSyntax Coding Standards** (separate document)

**Patterns covered there:**
- Creating Value Objects
- Creating Repository Interfaces
- Creating UseCases
- Creating Entities with Behavior
- Testing Patterns
- Controller Patterns

---

## Troubleshooting

### Common Questions

**Q: When should I create a Value Object vs just use a string?**

A: Create a Value Object when:
- The concept has business meaning
- It has validation rules
- It appears in multiple places
- Future rules might be added

Examples: EmailAddress, MoneyAmount, InterestLevel, BookingStatus

**Q: My entity is getting too big. What should I do?**

A: Consider:
- Extracting value objects for complex properties
- Creating separate aggregates if managing multiple concepts
- Moving some behavior to domain services
- Reviewing if it's actually multiple entities

**Q: Should I use Eloquent relationships in entities?**

A: Yes, pragmatically. But:
- Don't use relationships in business logic directly
- Load relationships explicitly when needed
- Consider repositories for complex queries
- Keep business behavior separate from data access

**Q: How do I test UseCases that send emails/notifications?**

A: Use dependency injection:
- Inject notification service interface
- Mock the interface in tests
- Real implementation in production
- Test that service was called correctly

**Q: Can I mix approaches in one project?**

A: Yes, but be consistent per domain:
- Simple domains can use Pragmatic
- Complex domains use Standard or Purist
- Document the choice in domain README
- Don't mix within a single domain

**Q: What if the client's language is unclear or inconsistent?**

A: This is a partnership opportunity:
- Schedule session to clarify terms
- Help client define their language
- Document agreed terms in Domain Dictionary
- Update as understanding improves
- This IS the partnership in action

### Escalation Path

**Level 1: Check Documentation**
- This document
- Coding Standards document
- Domain README files
- Reference projects

**Level 2: Ask in #architecture**
- Post question with context
- Tag relevant seniors
- Share code example if applicable
- Document answer for future

**Level 3: Architecture Discussion**
- Bring to weekly architecture meeting
- Discuss with team
- Make decision together
- Document decision

**Level 4: Consult Kalpa**
- Major architectural decisions
- New patterns or approaches
- Client-impacting decisions
- When team can't reach consensus

---

## Glossary

**Anemic Model:** Entity with no business logic, just getters/setters and database relationships

**Ubiquitous Language:** Business terminology used consistently in code and conversation between developers and domain experts

**Value Object:** Immutable object defined by its value rather than identity (e.g., MoneyAmount, EmailAddress)

**Aggregate:** Cluster of entities and value objects treated as a single unit for data changes

**Repository:** Abstraction for data access that provides collection-like interface to domain objects

**Use Case / Interactor:** Application business logic coordinator that orchestrates domain objects to fulfill a specific business workflow

**Presenter:** Formats output for specific interface (JSON, CLI, HTML) keeping use cases interface-agnostic

**Domain Event:** Something that happened in the domain that domain experts care about

**Entity:** Object with unique identity and lifecycle (e.g., Booking, User, Order)

**Service:** Stateless operation that doesn't naturally belong to any entity

**Rich Domain Model:** Domain model where business logic and behavior live in domain objects (entities, value objects)

**Clean Architecture:** Architectural pattern separating business logic from frameworks, UI, and infrastructure

**Dependency Rule:** Principle that dependencies point inward toward domain (IO → UseCases → Entities)

---

## Appendix: Document Updates

### When to Update This Document

**Update immediately when:**
- Core principles change
- New architectural patterns adopted
- Training process modified
- Success metrics change

**Update quarterly when:**
- New anti-patterns identified
- Better examples found
- Process improvements discovered
- Feedback from team suggests changes

**Version Control:**
- Keep in Git with proper commit messages
- Tag major versions
- Announce changes in #architecture
- Train team on significant changes

### Continuous Improvement

**Feedback Sources:**
- Code review discussions
- Architecture meetings
- Training sessions
- Retros and post-mortems
- New developer onboarding experience

**Improvement Process:**
1. Identify gap or confusion
2. Discuss with seniors
3. Draft improvement
4. Review with team
5. Update document
6. Communicate changes
7. Update training materials

---

## Revision History

- **v1.0 (November 2025)** - Initial release
  - Golden Circle alignment
  - DDD principles (without code examples)
  - Clean Architecture guidelines
  - Code review standards
  - Testing standards
  - Enforcement mechanisms
  - Senior training plan
  - Implementation roadmap

---

## Contact & Support

**Questions?** Ask in #architecture Slack channel

**Need clarification?** Schedule time with Kalpa or trained seniors

**Found an issue?** Create PR to update this document

**Success story?** Share in team meeting!

**Urgent architecture decision?** Escalate per guidelines above

---

**Remember: This system exists to support OneSyntax's mission of true partnership through accountable, professional development. Every practice, every standard, every review is an opportunity to keep that promise to our clients.**

**Let's build software that matters. Together.**
