# Whole Team Integration
## Developers, PMs, Designers, and Clients Working Together

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Great software requires the whole team, not just developers

---

## Table of Contents

1. [The Whole Team Concept](#the-whole-team-concept)
2. [Team Roles & Responsibilities](#team-roles--responsibilities)
3. [Three Amigos Sessions](#three-amigos-sessions)
4. [Client Involvement Checkpoints](#client-involvement-checkpoints)
5. [Communication Protocols](#communication-protocols)
6. [Cross-Functional Ceremonies](#cross-functional-ceremonies)
7. [Shared Understanding](#shared-understanding)

---

## The Whole Team Concept

### Why Cross-Functional Collaboration Matters

**OneSyntax mission:** True partnership through accountable professional development.

**Partnership requires:**
- Developers understanding business context
- PMs understanding technical constraints
- Designers working within architectural patterns
- Clients involved in key decisions
- Everyone speaking same language

### Who Is "The Team"?

**Core team members:**
- **Developers** - Build the solution
- **Product Managers** - Define what to build
- **Designers** - Define how it should work/look
- **QA** - Verify it works correctly
- **Clients** - Provide business context and validation

**Everyone is responsible for success.**

### Traditional vs OneSyntax Model

**Traditional (Broken):**
```
PM writes requirements → 
Designer makes mockups → 
Developer builds it → 
Client sees final product → 
"This isn't what I wanted"
```

**OneSyntax (Partnership):**
```
PM + Designer + Developer discuss together →
Clarify with client early →
Build iteratively →
Validate with client frequently →
"This is exactly what we need"
```

---

## Team Roles & Responsibilities

### Developers

**Primary responsibilities:**
- Write quality code following DDD/Clean Architecture
- Estimate technical complexity accurately
- Flag technical constraints early
- Explain technical decisions clearly to non-technical team
- Participate in planning and design discussions

**Cross-functional participation:**
- Join sprint planning (not just receive tickets)
- Participate in Three Amigos sessions
- Review designs before implementation
- Communicate blockers immediately
- Attend client demos
- Explain technical tradeoffs

**Communication style:**
- Explain in business terms, not just technical jargon
- Say "This will take longer because..." not just "Can't do it"
- Proactively flag risks
- Ask questions about business context

### Product Managers

**Primary responsibilities:**
- Translate business needs into user stories
- Prioritize features based on value
- Maintain product backlog
- Make scope decisions
- Be single point of contact for client

**Cross-functional participation:**
- Write acceptance criteria with developer input
- Understand technical constraints
- Attend architecture reviews for major features
- Facilitate Three Amigos sessions
- Balance business needs vs technical feasibility

**Communication style:**
- Speak client's language to clients
- Speak developer's language to developers
- Translate between worlds
- Make tradeoffs visible

### Designers

**Primary responsibilities:**
- Create user experiences
- Design interfaces
- Maintain design systems
- Ensure consistency

**Cross-functional participation:**
- Understand technical constraints (what's hard/easy to build)
- Design within architectural patterns
- Participate in sprint planning
- Attend demos and retrospectives
- Validate implementations

**Communication style:**
- Balance ideal design vs practical implementation
- Ask developers "How hard is this?"
- Explain design decisions
- Provide multiple options when possible

### Clients

**Primary responsibilities:**
- Provide business context
- Make priority decisions
- Validate assumptions
- Give timely feedback
- Trust the team's expertise

**Cross-functional participation:**
- Attend sprint planning/demos
- Answer questions within 24 hours
- Test early prototypes
- Provide domain expertise
- Validate business logic

**Communication style:**
- Be available and responsive
- Give honest feedback
- Ask questions when unclear
- Trust but verify

---

## Three Amigos Sessions

### What Are Three Amigos?

**Format:** PM + Developer + Designer (or QA) discuss a user story together BEFORE implementation.

**Purpose:**
- Ensure shared understanding
- Clarify ambiguities
- Identify edge cases
- Agree on acceptance criteria
- Flag technical challenges early

**Duration:** 30-60 minutes per feature

### When to Hold Three Amigos

**Required for:**
- Any story touching domain logic
- New features (not minor tweaks)
- Complex user workflows
- Stories with unclear requirements
- High-risk implementations

**Not needed for:**
- Simple UI updates
- Bug fixes with clear reproduction
- Well-understood patterns
- Obvious implementations

### Three Amigos Process

**Preparation (Before meeting):**
1. PM writes draft user story
2. Designer creates rough mockups (if applicable)
3. Developer reviews story and mockups
4. All three identify questions

**During session:**

**1. PM explains the story (5 minutes)**
- Business context: Why are we building this?
- User need: What problem does it solve?
- Success criteria: How do we know it works?

**2. Designer shows approach (5 minutes)**
- User flow walkthrough
- Key interactions
- Design decisions

**3. Developer asks questions (10 minutes)**
- Clarify business rules
- Identify edge cases
- Flag technical constraints
- Discuss data model implications

**4. Refine acceptance criteria together (10 minutes)**
- Given/When/Then format
- All three agree
- Cover edge cases
- Define "done"

**5. Technical discussion (15 minutes)**
- Domain model implications
- Architecture patterns needed
- Integration points
- Risk areas

**6. Estimate complexity together (5 minutes)**
- Developer gives estimate
- PM confirms fits in sprint
- Flag if too complex (break down)

**Output:**
- Refined user story
- Clear acceptance criteria
- Shared understanding
- Identified risks
- Implementation approach

### Example Three Amigos Session

**Story:** "As a user, I want to update my email address"

**PM:** "Client wants users to change email. Currently if they need new email, they create new account. This is confusing."

**Designer:** "I'm thinking settings page, 'Edit Email' button, modal with confirmation. [Shows mockup]"

**Developer:** "Couple questions..."
- "What if email already exists?"
- "Do we need to verify new email?"
- "What happens to existing sessions?"
- "Can they use same email as before?"

**PM:** "Oh good questions. Let me check with client..."

**[5 minute break while PM messages client]**

**PM:** "Client says: must verify new email, old email gets notification, can't use existing email, sessions stay active."

**Developer:** "Okay so we need:
- Email uniqueness check (domain rule)
- Email verification event
- Notification service integration
- Email is a Value Object with validation

This touches User aggregate, need to ensure invariants..."

**Designer:** "For UX, should we show 'verification pending' state?"

**All three:** "Yes! Good catch."

**Acceptance Criteria (agreed):**
```
Given: User is logged in
When: User changes email to new address
Then:
- System checks email is unique
- System sends verification to new email
- System shows "Verification pending" message
- System sends notification to old email
- User can still log in with old email
- After verification, new email becomes active
- Old email no longer works

Edge cases:
- Email already exists → Show error
- User tries to use same email → Show error
- Verification link expires → Show error, allow resend
```

**Developer:** "I estimate 2 days. Need to:
1. Add Email value object with validation
2. Create EmailChange domain event
3. Update User aggregate
4. Integration with email service
5. Tests for all scenarios"

**PM:** "Fits in current sprint. Let's do it."

**Outcome:** Everyone understands what we're building, why, and how.

---

## Client Involvement Checkpoints

### When to Involve Clients

**Critical checkpoints:**
1. **Sprint planning** - Review priorities
2. **Feature kickoff** - Validate understanding
3. **Mid-sprint demo** - Show progress, get early feedback
4. **Sprint review** - Demo completed work
5. **Major architecture decisions** - Explain implications

**Not every ticket needs client involvement**, but anything touching business logic should be validated.

### Client Communication Templates

**Feature kickoff email:**
```
Subject: Starting work on [Feature] - Quick validation needed

Hi [Client],

We're starting implementation of [Feature] this week. Before we dive in, 
wanted to confirm our understanding:

What we're building:
- [Brief description]
- [Key behaviors]
- [Expected outcomes]

Our understanding of business rules:
- [Rule 1]
- [Rule 2]
- [Rule 3]

Questions for you:
- [Question 1]
- [Question 2]

Can you confirm this matches your expectations? Any corrections or additions?

We'll have something to show you by [Date] for early feedback.

Thanks,
[Developer Name]
```

**Mid-sprint demo request:**
```
Subject: [Feature] preview ready - 15 min feedback session?

Hi [Client],

We've got [Feature] working (not polished yet, but functional). 

Want to show you to make sure we're on the right track before we finish it.

Can you spare 15 minutes this week? I'll walk through what we've built 
and get your feedback.

[Link to calendar booking]

Thanks,
[Developer Name]
```

### Client Demo Format

**Every 2 weeks (end of sprint):**

**Structure (30 minutes):**
1. **Recap** (2 min) - What we planned to build
2. **Demo** (15 min) - Show completed features
3. **Feedback** (10 min) - Client reactions, questions
4. **Next sprint** (3 min) - What's coming next

**Demo tips:**
- Show working software, not slideshow
- Click through real user flows
- Explain what changed
- Invite feedback naturally
- Don't defend decisions, listen

**Good demo:**
> "Here's the email change feature we built. Let me show you the flow... 
> [clicks through]... Notice it sends verification email here. Does this 
> match how you expected it to work?"

**Bad demo:**
> "We implemented the EmailChangeUseCase which leverages the Email value 
> object and integrates with the NotificationService via domain events..."

Client: "Um... what?"

---

## Communication Protocols

### Daily Standup Format

**Not just developers - include PM (and designer if needed).**

**Each person shares:**
1. Yesterday: What I did
2. Today: What I'm doing
3. Blockers: What's stopping me

**Cross-functional focus:**
- Developers mention dependencies on PM/designer
- PM mentions client feedback needed
- Designer mentions implementation questions
- Everyone helps unblock each other

**Example:**
> **Developer:** "Yesterday finished user email validation. Today starting 
> email verification flow. Blocked on: need copy for verification email - 
> @PM can you provide?"
>
> **PM:** "Will get you copy by noon. Also, client wants to see email 
> change feature early - can we show Friday?"
>
> **Developer:** "Yes, will be functional by then. Not pretty, but working."

### Slack Channels Organization

**Project-specific:**
- `#project-name` - General project chat
- `#project-name-dev` - Technical discussions
- `#project-name-client` - Client communications
- `#project-name-urgent` - Time-sensitive issues

**General:**
- `#architecture` - Technical architecture questions
- `#three-amigos` - Schedule Three Amigos sessions
- `#demos` - Demo recordings and feedback

**Etiquette:**
- Tag people when you need response
- Use threads for discussions
- Keep client channel professional
- Respond within 24 hours (4 hours for urgent)

### Notion Organization

**Product docs:**
- User stories with acceptance criteria
- Feature specifications
- Client feedback log
- Decision log

**Technical docs:**
- Architecture diagrams
- Domain model documentation
- API documentation
- Technical decision records

**Shared:**
- Sprint planning notes (PM + Developers write together)
- Three Amigos session notes
- Demo feedback
- Retrospective notes

---

## Cross-Functional Ceremonies

### Sprint Planning (2 hours, every 2 weeks)

**Who attends:** Developers, PM, Designer (if needed)

**Format:**
1. **Review last sprint** (15 min)
   - What shipped
   - What didn't ship (why?)
   - Metrics/feedback

2. **Review priorities** (15 min)
   - Client priorities
   - Technical priorities
   - Dependencies

3. **Plan stories** (60 min)
   - PM presents stories
   - Three Amigos discussion (brief)
   - Developers estimate
   - Commit to sprint goal

4. **Identify needs** (15 min)
   - Need client input on anything?
   - Need design for anything?
   - Need technical spikes?

5. **Risk review** (15 min)
   - What could go wrong?
   - Dependencies?
   - Availability issues?

**Output:**
- Sprint backlog
- Sprint goal
- Three Amigos sessions scheduled
- Demo date confirmed

### Sprint Review/Demo (30 min, every 2 weeks)

**Who attends:** Developers, PM, Designer, Client

**Format:**
1. Sprint goal recap (2 min)
2. Demo completed work (15 min)
3. Client feedback (10 min)
4. Discuss next priorities (3 min)

**Tips:**
- Let client drive conversation
- Show, don't tell
- Accept all feedback neutrally
- Don't make excuses for incomplete work

### Sprint Retrospective (1 hour, every 2 weeks)

**Who attends:** Developers, PM, Designer (Client optional but rare)

**Format:**
1. What went well?
2. What didn't go well?
3. What should we change?
4. Action items for next sprint

**Cross-functional focus:**
- Communication issues?
- Collaboration gaps?
- Unclear requirements?
- Client involvement working?

---

## Shared Understanding

### Ubiquitous Language

**Everyone uses same terms:**
- Not: "user account" (dev) vs "customer profile" (PM) vs "member record" (client)
- Yes: "Member" everywhere - code, docs, conversations

**Creating shared language:**
1. Identify business concepts during Three Amigos
2. Document in shared glossary
3. Use in user stories
4. Use in code
5. Use in conversations
6. Correct when someone uses different term

**Example glossary:**
```
- Member: A registered user with account
- Lead: Potential member who hasn't signed up
- Booking: A scheduled appointment
- Appointment: Same as booking (don't use both!)
- Cancellation: User cancels booking
- No-show: User doesn't attend booking
```

### Visual Models

**Create diagrams together:**
- User journey maps (Designer + PM)
- Domain model diagrams (Developer + PM)
- System integration diagrams (Developer + PM)
- Workflow diagrams (PM + Designer + Developer)

**Keep them updated:**
- In Notion, accessible to all
- Update when understanding changes
- Reference in conversations
- Use in Three Amigos sessions

---

## Success Metrics

### Team Level

**You have good cross-functional collaboration when:**
- Everyone feels heard
- Surprises are rare
- Requirements are clear
- Technical constraints understood early
- Client is involved appropriately
- Demos go smoothly
- Retrospectives are productive

---

## Remember

**Software is a team sport.**

Great code without business context is useless. Clear requirements without understanding technical constraints lead to unrealistic plans. Beautiful designs that can't be built frustrate everyone.

**We win together or lose together.**

---

*Related: [Our Values](our-values.md) | [Development System](development-system.md) | [Three Amigos](three-amigos.md)*
