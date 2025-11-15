# Sprint Planning Template
**2-week sprint planning at OneSyntax**

Copy this template for every sprint planning session.

---

## Sprint Information

**Sprint Number:** _____
**Sprint Duration:** _____ to _____ (2 weeks)
**Team Capacity:** _____ points (based on velocity)
**Team Members:** _________________________

---

## 📊 Part 1: Sprint Review (15 minutes)

### Last Sprint Retrospective

**What went well:**
-
-
-

**What didn't go well:**
-
-
-

**Velocity last sprint:** _____ points
**Velocity 3-sprint average:** _____ points

**Action items from last retro:**
- [ ]
- [ ]
- [ ]

---

## 🎯 Part 2: Sprint Goals (20 minutes)

**PM presents priorities for this sprint:**

### Primary Goal
_What's the main objective? (1 sentence)_


### Secondary Goals
_Other important outcomes:_
1.
2.
3.

### Success Metrics
_How will we know we succeeded?_
-
-

---

## 📝 Part 3: Story Estimation (60 minutes)

### Story Estimation Guide
- **1-2 points:** Less than a day
- **3 points:** 1 day
- **5 points:** 2-3 days
- **8 points:** 3-4 days
- **13 points:** Split the story!

### Stories for This Sprint

---

#### Story 1: _________________________

**As a** [user type]
**I want** [goal]
**So that** [benefit]

**Acceptance Criteria:**
```gherkin
Given [context]
When [action]
Then [outcome]
```

**Technical Considerations:**
- DDD patterns needed: ☐ Entity ☐ Value Object ☐ Aggregate ☐ Service
- Clean Architecture layers: ☐ Domain ☐ Application ☐ Infrastructure ☐ Presentation
- Testing: ☐ Unit ☐ Integration ☐ Acceptance

**Estimation:** _____ points
**Assigned to:** _____________
**Dependencies:** _____________

---

#### Story 2: _________________________

**As a** [user type]
**I want** [goal]
**So that** [benefit]

**Acceptance Criteria:**
```gherkin
Given [context]
When [action]
Then [outcome]
```

**Technical Considerations:**
- DDD patterns needed: ☐ Entity ☐ Value Object ☐ Aggregate ☐ Service
- Clean Architecture layers: ☐ Domain ☐ Application ☐ Infrastructure ☐ Presentation
- Testing: ☐ Unit ☐ Integration ☐ Acceptance

**Estimation:** _____ points
**Assigned to:** _____________
**Dependencies:** _____________

---

#### Story 3: _________________________

**As a** [user type]
**I want** [goal]
**So that** [benefit]

**Acceptance Criteria:**
```gherkin
Given [context]
When [action]
Then [outcome]
```

**Technical Considerations:**
- DDD patterns needed: ☐ Entity ☐ Value Object ☐ Aggregate ☐ Service
- Clean Architecture layers: ☐ Domain ☐ Application ☐ Infrastructure ☐ Presentation
- Testing: ☐ Unit ☐ Integration ☐ Acceptance

**Estimation:** _____ points
**Assigned to:** _____________
**Dependencies:** _____________

---

_Add more stories as needed..._

---

## 📊 Part 4: Capacity Planning (20 minutes)

### Team Capacity

| Team Member | Days Available | Points Capacity  |
|-------------|----------------|------------------|
|             | ___ / 10       | ___              |
|             | ___ / 10       | ___              |
|             | ___ / 10       | ___              |
|             | ___ / 10       | ___              |
| **TOTAL**   | **___**        | **___**          |

**Capacity adjustments:**
- PTO/holidays: _____ days
- Meetings/ceremonies: _____ points
- Support/maintenance: _____ points (10-20% reserve)
- **Available sprint capacity:** _____ points

### Sprint Commitment

**Total story points committed:** _____ points
**Available capacity:** _____ points
**Capacity utilization:** _____ %

**Target:** 80-90% capacity utilization

- [ ] ✅ Under 90% capacity (healthy)
- [ ] ⚠️ 90-100% capacity (risky)
- [ ] ❌ Over 100% capacity (overcommitted - remove stories!)

---

## 🔧 Technical Debt Allocation (20% Budget)

**Refactoring Budget:** _____ points (20% of capacity)

### Planned Refactoring This Sprint

1. **[Tech Debt Item]**
   - Location: _____________
   - Estimated effort: _____ points
   - Benefit: _____________
   - Priority: ☐ High ☐ Medium ☐ Low

2. **[Tech Debt Item]**
   - Location: _____________
   - Estimated effort: _____ points
   - Benefit: _____________
   - Priority: ☐ High ☐ Medium ☐ Low

→ Tech debt ledger: [reference/technical-debt-management.md](../reference/technical-debt-management.md)

---

## ⚠️ Part 5: Risks & Dependencies (5 minutes)

### Known Risks

**Risk 1:**
- **Description:**
- **Impact:** ☐ High ☐ Medium ☐ Low
- **Likelihood:** ☐ High ☐ Medium ☐ Low
- **Mitigation:**

**Risk 2:**
- **Description:**
- **Impact:** ☐ High ☐ Medium ☐ Low
- **Likelihood:** ☐ High ☐ Medium ☐ Low
- **Mitigation:**

### External Dependencies

- [ ] **[Dependency]:** _____________
  - Owner: _____________
  - Due date: _____________
  - Blocks story: _____________

- [ ] **[Dependency]:** _____________
  - Owner: _____________
  - Due date: _____________
  - Blocks story: _____________

---

## ✅ Sprint Planning Checklist

**Before planning:**
- [ ] Review last sprint's velocity
- [ ] Product backlog refined and prioritized
- [ ] Stories have acceptance criteria
- [ ] Team capacity calculated (account for PTO)

**During planning:**
- [ ] Sprint goal clearly defined
- [ ] All stories estimated using planning poker
- [ ] Technical approach discussed for complex stories
- [ ] 20% capacity reserved for refactoring
- [ ] Risks and dependencies identified
- [ ] Total points within team capacity

**After planning:**
- [ ] Sprint board updated with committed stories
- [ ] Team members assigned to stories
- [ ] Sprint goals posted in Slack
- [ ] Stakeholders notified of sprint scope
- [ ] First Three Amigos sessions scheduled

---

## 🎯 Sprint Ceremonies Schedule

### Daily Standup
- **When:** Every day at _____
- **Duration:** 15 minutes
- **Format:** What I did, what I'm doing, blockers

### Three Amigos Sessions
- **Story 1:** _____________
- **Story 2:** _____________
- **Story 3:** _____________

### Mid-Sprint Check-in
- **When:** End of Week 1
- **Purpose:** Burndown review, adjust if needed

### Sprint Review
- **When:** Last day of sprint
- **Duration:** 1 hour
- **Attendees:** Team + stakeholders + client

### Sprint Retrospective
- **When:** After sprint review
- **Duration:** 1 hour
- **Attendees:** Team only

---

## 📈 Definition of Done

**Story is DONE when:**

- [ ] **Code complete**
  - Implements all acceptance criteria
  - Follows DDD/Clean Architecture standards
  - No ArchUnit violations
  - Code reviewed and approved

- [ ] **Tests complete**
  - Unit tests written (ZOMBIES approach)
  - Integration tests for use cases
  - Acceptance tests for Given-When-Then scenarios
  - All tests passing
  - Coverage > 80%

- [ ] **Documentation complete**
  - Code comments for complex logic
  - README updated if needed
  - API documentation updated
  - Acceptance criteria validated

- [ ] **Deployed**
  - Merged to main branch
  - Deployed to staging
  - Smoke tests passing
  - Ready for production release

→ ZOMBIES testing: [reference/system-deep-dive.md](../reference/system-deep-dive.md)

---

## 📊 Estimation Reference (Planning Poker)

### 1 Point Story Example
**"Add validation to email field"**
- Single method change
- Tests already exist
- Clear requirements
- < 4 hours

### 3 Point Story Example
**"Create new user profile page"**
- New controller + view
- Standard CRUD operations
- TDD approach
- ~1 day

### 5 Point Story Example
**"Implement order cancellation feature"**
- Multiple aggregates involved
- Business rules to implement
- Integration with payment system
- 2-3 days

### 8 Point Story Example
**"Refactor authentication system"**
- Multiple layers affected
- Migration needed
- Extensive testing required
- 3-4 days

### 13 Point Story = Too Big!
**Split it into smaller stories**

---

## 🎯 Architectural Considerations Checklist

**For each story, verify:**

### DDD Patterns
- [ ] Which bounded context does this belong to?
- [ ] What's the core domain entity?
- [ ] Are value objects needed?
- [ ] Is this an aggregate root?
- [ ] Do we need a domain service?

### Clean Architecture
- [ ] Where does the logic belong?
  - Domain Layer: Business rules
  - Application Layer: Use cases
  - Infrastructure Layer: External services
  - Presentation Layer: UI/API
- [ ] Are dependencies pointing inward?
- [ ] Are interfaces defined in the right layer?

### Testing Strategy
- [ ] Unit tests for domain logic
- [ ] Integration tests for use cases
- [ ] Acceptance tests for user scenarios
- [ ] ZOMBIES approach applied

→ Architecture guide: [reference/architecture-guide.md](../reference/architecture-guide.md)

---

## 💡 Planning Tips

**Estimation best practices:**
1. **Use relative sizing** - Compare to previous stories
2. **Include testing time** - Tests are part of the story
3. **Include review time** - Code review is required
4. **Account for uncertainty** - Round up if unsure
5. **Break down 13s** - Always split large stories

**Common estimation mistakes:**
- ❌ Forgetting testing time
- ❌ Not accounting for code review
- ❌ Underestimating integration complexity
- ❌ Ignoring architectural requirements
- ❌ Optimistic thinking ("perfect scenario")

**Healthy sprint signs:**
- ✅ 80-90% capacity utilization
- ✅ Mix of feature work and refactoring
- ✅ Clear acceptance criteria for all stories
- ✅ No stories > 8 points
- ✅ Team confident in commitment

---

## 🔄 Sprint Tracking

### Daily Burndown

| Day | Planned | Actual | Notes |
|-----|---------|--------|-------|
| 1   | ___     | ___    |       |
| 2   | ___     | ___    |       |
| 3   | ___     | ___    |       |
| 4   | ___     | ___    |       |
| 5   | ___     | ___    |       |
| 6   | ___     | ___    |       |
| 7   | ___     | ___    |       |
| 8   | ___     | ___    |       |
| 9   | ___     | ___    |       |
| 10  | ___     | ___    |       |

**Burndown alerts:**
- ⚠️ Behind schedule by > 20% at mid-sprint
- ⚠️ Velocity trending below historical average
- ⚠️ Multiple stories blocked

---

## 📞 Contacts & Resources

**Questions during sprint:**
- **Technical questions:** #architecture channel
- **Story clarification:** PM or Product Owner
- **Blocking issues:** Scrum Master or Tech Lead
- **Estimation disputes:** Use planning poker, discuss trade-offs

**Full guides:**
- [Planning Game](../3-processes/planning-game.md)
- [Whole Team](../4-people/whole-team.md)
- [Development System](../2-standards/development-system.md)
- [Acceptance Tests](../2-standards/acceptance-tests.md)

---

## Remember

> "Plans are worthless, but planning is everything."
> — Dwight D. Eisenhower

**Sprint planning is about:**
- Building shared understanding
- Making realistic commitments
- Identifying risks early
- Aligning on technical approach

**Not about:**
- Filling every hour of the sprint
- Committing to everything the PM wants
- Skipping architectural discussions
- Ignoring technical debt

---

*Version 1.0 | Last Updated: November 2025*

---

**Filename to save as:** `sprint-[number]-planning-[date].md`
**Example:** `sprint-23-planning-2025-11-16.md`
