# Planning Game
## Collaborative Sprint Planning Based on Value & Capacity

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Plan together, deliver together

---

## Table of Contents

1. [The Planning Game Concept](#the-planning-game-concept)
2. [Sprint/Iteration Structure](#sprintiteration-structure)
3. [Story Estimation](#story-estimation)
4. [Sprint Planning Process](#sprint-planning-process)
5. [Velocity Tracking](#velocity-tracking)
6. [Applying Architectural Standards](#applying-architectural-standards)
7. [Templates](#templates)

---

## The Planning Game Concept

### What Is The Planning Game?

**From Extreme Programming:**
A collaborative planning approach where business priorities meet technical reality.

**Two sides of the game:**
- **Business** (PM/Client): Decides **what** to build and **priority**
- **Technical** (Developers): Decides **how** to build it and **estimates**

**The "game":** Negotiate the best value within realistic constraints.

### OneSyntax Adaptation

**Core principles:**
- Business sets priorities, not deadlines
- Developers give honest estimates, not guesses
- Quality standards are non-negotiable
- Plans adapt to reality through velocity
- Everyone commits to the sprint goal together

**Not negotiable:**
- DDD/Clean Architecture patterns
- Test coverage requirements
- Code review standards
- Technical debt limits

---

## Sprint/Iteration Structure

### Recommended: 2-Week Sprints

**Why 2 weeks:**
- Long enough to complete meaningful features
- Short enough to adapt to feedback quickly
- Matches typical client availability
- Fits human working rhythm

**Sprint timeline:**

**Monday Week 1:**
- Sprint planning (2 hours)
- Team commits to sprint goal
- Stories clarified and estimated

**Tuesday-Friday Week 1:**
- Development work
- Daily standups
- Three Amigos as needed

**Monday-Thursday Week 2:**
- Development work continues
- Mid-sprint sync (brief)
- Wrap up work

**Friday Week 2:**
- Sprint demo to client (30 min)
- Sprint retrospective (1 hour)
- Deploy to staging/production

### Sprint Ceremonies

**Sprint Planning:** 2 hours (every 2 weeks)
**Daily Standup:** 15 min (every day)
**Mid-Sprint Sync:** 30 min (once per sprint)
**Sprint Demo:** 30 min (end of sprint)
**Sprint Retrospective:** 1 hour (end of sprint)

**Total ceremony time:** ~9 hours per 2-week sprint (5.6% of work time)

---

## Story Estimation

### Estimation Method: Planning Poker

**Why Planning Poker:**
- Gets everyone's input
- Prevents anchoring bias
- Surfaces assumptions differences
- Fun and engaging

**Process:**
1. PM reads user story
2. Developers ask clarifying questions
3. Everyone votes simultaneously (Fibonacci: 1, 2, 3, 5, 8, 13, 21)
4. Discuss highest and lowest estimates
5. Re-vote until consensus

**Fibonacci scale meaning:**

| Points | Meaning | Duration |
|--------|---------|----------|
| 1 | Trivial - Very well understood | 1-2 hours |
| 2 | Simple - Clear path forward | 2-4 hours |
| 3 | Moderate - Some complexity | 4-8 hours |
| 5 | Complex - Multiple steps | 1-2 days |
| 8 | Very complex - Significant effort | 2-3 days |
| 13 | Too big - Should break down | 3-5 days |
| 21+ | Way too big - Must break down | >5 days |

**Rule:** Any story estimated at 13+ must be broken down into smaller stories.

### What to Include in Estimates

**Include time for:**
- Writing code following DDD/Clean Architecture
- Writing tests (ZOMBIES)
- Code review time
- Refactoring
- Documentation
- Integration complexity

**Don't pad for:**
- Meetings (tracked separately)
- Context switching (velocity accounts for this)
- Unknowns (that's what estimates are for)

### Estimation Examples

**Story: "Add email validation to registration"**

**Junior votes:** 5 (doesn't know value objects yet)  
**Senior votes:** 2 (knows value object pattern)

**Discussion:**
- Junior: "Need to write validation logic, tests, handle errors..."
- Senior: "We have Email value object pattern, just use it"
- Junior: "Oh! I didn't know. Where is it?"
- Senior: "I'll show you. With that, it's 2 hours max"

**Re-vote:** Everyone agrees on 2.

**Learning:** Junior learned about existing pattern, future estimates more accurate.

---

**Story: "Users can update their profile"**

**Developer A votes:** 5  
**Developer B votes:** 13

**Discussion:**
- B: "Profile has tons of fields - name, bio, avatar, settings..."
- A: "Oh, I thought just name and email"
- PM: "Clarification: This story is just name and email. Avatar is separate story."
- Both developers: "Okay, that's 5 then."

**Re-vote:** Everyone agrees on 5.

**Learning:** Unclear scope resolved through discussion.

---

## Sprint Planning Process

### Preparation (Before Sprint Planning)

**PM prepares:**
- Refined user stories (acceptance criteria clear)
- Prioritized backlog
- Client priorities understood
- Previous sprint feedback incorporated

**Developers prepare:**
- Review upcoming stories
- Note technical questions
- Think about approach
- Check for dependencies

### Sprint Planning Meeting (2 hours)

**Part 1: Sprint Goal (30 minutes)**

**PM presents:**
- What's the focus this sprint?
- What's the desired outcome?
- Why is this the priority?

**Example sprint goals:**
- "Enable users to manage their own profiles"
- "Complete payment integration for checkout flow"
- "Fix critical bugs from last release"
- "Refactor user module to domain-driven design"

**Team discusses:**
- Is this achievable in 2 weeks?
- Any blockers or dependencies?
- Does this align with architectural goals?

**Output:** Agreed sprint goal statement

---

**Part 2: Story Selection (60 minutes)**

**For each story:**

1. **PM presents story** (3 min)
   - What's the user need?
   - What's the business value?
   - What are acceptance criteria?

2. **Developers ask questions** (5 min)
   - Clarify ambiguities
   - Identify edge cases
   - Discuss technical approach
   - Flag if Three Amigos needed

3. **Team estimates story** (5 min)
   - Planning poker voting
   - Discuss discrepancies
   - Reach consensus

4. **Check capacity** (2 min)
   - Does this fit in our velocity?
   - Still on track for sprint goal?
   - Need to adjust scope?

5. **Commit or defer** (2 min)
   - Add to sprint backlog if capacity
   - Move to next sprint if no capacity

**Repeat until sprint is full.**

---

**Part 3: Risk Review (15 minutes)**

**Ask:**
- What could go wrong?
- Any dependencies on other teams/systems?
- Any blockers we know about?
- Any team members out this sprint?
- Any technical unknowns?

**Document risks:**
- Create risk mitigation plans
- Identify backup options
- Flag items to watch

---

**Part 4: Sprint Commitment (15 minutes)**

**Review:**
- Sprint goal: [Statement]
- Stories committed: [List with points]
- Total story points: [Number]
- Capacity: [Number based on velocity]
- Confidence level: High/Medium/Low

**Team votes:**
- Can we commit to this sprint?
- Thumbs up = Yes, confident
- Thumbs middle = Maybe, some concerns
- Thumbs down = No, too much/unclear

**If concerns:** Adjust scope, clarify stories, or add buffer.

**Output:** Committed sprint backlog

---

## Velocity Tracking

### What Is Velocity?

**Definition:** Average story points completed per sprint.

**Purpose:**
- Predict future capacity
- Track team productivity trends
- Inform sprint planning
- Measure improvement

### Calculating Velocity

**First 3 sprints:** Estimate conservatively

**After 3 sprints:**
```
Velocity = (Sprint1 + Sprint2 + Sprint3) / 3
```

**Example:**
- Sprint 1: 18 points completed
- Sprint 2: 22 points completed  
- Sprint 3: 20 points completed
- **Average velocity: 20 points per sprint**

**Use this for planning:** Pull 20 points worth of stories into sprint.

### Velocity Trends

**Velocity increasing:**
- Team getting better at estimates
- Team improving efficiency
- Reduced technical debt
- Good sign!

**Velocity decreasing:**
- Technical debt accumulating
- Interruptions increasing
- Complexity increasing
- Warning sign - investigate

**Velocity stable:**
- Predictable team
- Sustainable pace
- Ideal state

### Velocity Anti-Patterns

**❌ Don't:**
- Compare velocity between teams (different contexts)
- Use velocity as performance metric (game-able)
- Pressure team to increase velocity artificially
- Count partially done stories
- Change story point scale mid-project

**✅ Do:**
- Use velocity for planning only
- Accept realistic velocity
- Investigate drops in velocity
- Celebrate consistent delivery
- Focus on value, not points

---

## Applying Architectural Standards

### How Standards Affect Estimation

**Stories must account for quality:**
- Following DDD patterns
- Writing tests first (TDD)
- Clean Architecture layers
- Code review time
- Refactoring technical debt

**This means:**
- Estimates are higher than "quick and dirty" approach
- But long-term velocity stays stable
- Quality stays consistent
- Technical debt doesn't slow future sprints

### Story Writing for DDD/Clean Architecture

**Good story format:**

```
Title: User can change their email address

As a member
I want to update my email address
So that I can receive notifications at my current email

Acceptance Criteria:
- User enters new email address
- System validates email format (Email value object)
- System checks email is unique (domain rule)
- System sends verification email (domain event)
- User verifies new email via link
- Old email receives notification (domain event)
- User can log in with new email after verification

Technical Notes:
- Touches User aggregate
- Needs Email value object
- Requires EmailChanged domain event
- Integration with NotificationService

Definition of Done:
- Unit tests for domain logic (ZOMBIES)
- Integration tests for email service
- Code review passed
- Automated checks passed
- Deployed to staging
```

**Why this works:**
- Business value clear
- Technical approach hinted
- Domain concepts identified
- Testing expectations set

### Breaking Down Stories

**If story is 13+ points, break down by:**

**Vertical slices (preferred):**
- Each slice delivers end-to-end value
- Example: "Change email" split into:
  1. "User can initiate email change" (5 points)
  2. "System verifies new email" (5 points)
  3. "Email change notifications sent" (3 points)

**Not horizontal slices:**
- ❌ "Create database schema" (no user value)
- ❌ "Build API endpoint" (incomplete feature)
- ❌ "Add unit tests" (should be part of every story)

---

## Templates

### Sprint Planning Template

```
SPRINT PLANNING - Sprint [Number]
Date: [Date]
Duration: 2 weeks ([Start Date] - [End Date])

SPRINT GOAL:
[One sentence describing sprint focus]

TEAM CAPACITY:
- Developers: [Number]
- Days available: [Total days - PTO - holidays]
- Average velocity: [Points]
- Planned capacity: [Points]

COMMITTED STORIES:
1. [Story Title] - [Points] - [Assignee]
2. [Story Title] - [Points] - [Assignee]
...

Total Story Points: [Number]

RISKS & DEPENDENCIES:
- [Risk 1]
- [Risk 2]

THREE AMIGOS NEEDED:
- [Story requiring clarification]

TEAM COMMITMENT:
âœ… All team members agree to sprint goal
âœ… Confident we can complete committed work
âœ… Risks identified and mitigated
```

### User Story Template

```
TITLE: [User action in business terms]

USER STORY:
As a [role]
I want to [action]
So that [benefit]

ACCEPTANCE CRITERIA:
Given [context]
When [action]
Then [outcome]

[Repeat for all scenarios including edge cases]

TECHNICAL NOTES:
- Domain concepts: [Entities, Value Objects, Aggregates involved]
- Architecture layers: [Which layers touched]
- Integration points: [External systems]
- Patterns needed: [Repository, Factory, Domain Event, etc.]

DEFINITION OF DONE:
- [ ] Code follows DDD/Clean Architecture
- [ ] Unit tests written (ZOMBIES)
- [ ] Integration tests if applicable
- [ ] Code review passed
- [ ] Automated checks passed
- [ ] Documentation updated
- [ ] Deployed to staging

ESTIMATE: [Story points]
PRIORITY: [High/Medium/Low]
```

### Sprint Demo Template

```
SPRINT DEMO - Sprint [Number]
Date: [Date]
Attendees: [Team + Client]

SPRINT GOAL RECAP:
[What we planned to achieve]

COMPLETED WORK:
1. [Feature 1]
   - Demo: [Show working software]
   - Value delivered: [Business benefit]
   
2. [Feature 2]
   - Demo: [Show working software]
   - Value delivered: [Business benefit]

INCOMPLETE WORK (if any):
- [Story not finished]
- Reason: [Why]
- Plan: [How we'll handle it]

METRICS:
- Story points committed: [Number]
- Story points completed: [Number]
- Velocity: [Number]

CLIENT FEEDBACK:
[Capture during demo]

NEXT SPRINT PRIORITIES:
[Preview what's coming]
```

---

## Common Challenges

### Challenge 1: Estimates Always Wrong

**Problem:** Actual time consistently different from estimates.

**Solutions:**
- Break stories down smaller (easier to estimate)
- Track actual vs estimated (learn patterns)
- Include technical debt time
- Account for code review iterations
- Be honest about unknowns

### Challenge 2: Pressure to Commit More

**Problem:** Client/Management wants more features per sprint.

**Response:**
> "We can commit to more stories, but that means cutting quality corners, 
> which will slow us down long-term. Our velocity is based on sustainable, 
> quality work. We can increase velocity by paying down technical debt or 
> improving processes, but not by just promising more."

### Challenge 3: Mid-Sprint Scope Changes

**Problem:** New urgent requests mid-sprint.

**Response:**
> "We can add this urgent item, but something else must be removed to 
> maintain quality standards. Which story should we defer to next sprint?"

**Process:**
1. Assess urgency honestly (is it really urgent?)
2. Estimate new work
3. Remove equal points from sprint
4. Get team agreement
5. Communicate change

### Challenge 4: Stories Unclear

**Problem:** Halfway through sprint, realize story is ambiguous.

**Solution:**
- Stop work immediately
- Call Three Amigos session
- Clarify requirements
- Re-estimate if needed
- Update story
- Continue

**Prevention:** More Three Amigos sessions before sprint.

---

## Success Metrics

### Sprint Level

**Good sprint planning when:**
- Team completes 80-100% of committed points
- Sprint goal achieved
- Quality standards maintained
- No surprises during sprint
- Client happy with demo

### Long-Term

**Good planning process when:**
- Velocity predictable (within 10%)
- Client trusts estimates
- Team not overworked
- Technical debt stays manageable
- Features delivered consistently

---

## Remember

**Planning is collaborative.**

Not PM telling developers what to build. Not developers dictating timeline. It's partnership - business priorities meet technical reality, and we negotiate the best outcome together.

**Plans are meant to change.**

Velocity helps us plan, but reality always differs. Adapt based on what we learn. The goal is delivering value, not following the plan perfectly.

---

*Related: [Whole Team](whole-team.md) | [Development System](development-system.md) | [Sprint Ceremonies](ceremonies.md)*
