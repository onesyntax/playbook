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

**Anemic Entity (WRONG):**
```php
class Booking extends Model
{
    protected $fillable = ['user_id', 'start_date', 'end_date', 'status'];
    
    // Just getters/setters and database stuff
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```

**Rich Domain Model (RIGHT):**
```php
class Booking extends Model
{
    protected $fillable = ['user_id', 'start_date', 'end_date', 'status'];
    
    // BUSINESS BEHAVIOR - This is what makes it rich
    public function cancel(): self
    {
        if (!$this->canBeCancelled()) {
            throw new BookingCancellationException(
                'Booking cannot be cancelled - it has already started or is not active'
            );
        }
        
        $this->status = 'cancelled';
        $this->cancelled_at = now();
        
        return $this;
    }
    
    public function canBeCancelled(): bool
    {
        return $this->status === 'active' 
            && $this->start_date > now();
    }
    
    public function confirm(): self
    {
        $this->status = 'confirmed';
        $this->confirmed_at = now();
        
        return $this;
    }
    
    public function isPending(): bool
    {
        return $this->status === 'pending';
    }
    
    // Relationships at the bottom
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```

**What makes it rich:**
- Business rules are explicit (`canBeCancelled()`)
- Domain language is used (`cancel()`, `confirm()`)
- Behavior is in the entity, not scattered in services
- Anyone reading the code understands the business

#### 3. Use Value Objects

**When to create a Value Object:**
- The concept has business meaning
- It has validation rules
- It appears in multiple places
- It's more than just a string/int

**Example: Interest Level**
```php
class InterestLevel
{
    private const INTERESTED = 'interested';
    private const DELAYED_INTEREST = 'delayed_interest';
    private const NOT_INTERESTED = 'not_interested';
    private const NEUTRAL = 'neutral';
    
    private string $level;
    
    private function __construct(string $level)
    {
        $this->level = $level;
    }
    
    public static function interested(): self
    {
        return new self(self::INTERESTED);
    }
    
    public static function delayedInterest(): self
    {
        return new self(self::DELAYED_INTEREST);
    }
    
    public static function notInterested(): self
    {
        return new self(self::NOT_INTERESTED);
    }
    
    public static function neutral(): self
    {
        return new self(self::NEUTRAL);
    }
    
    // BUSINESS RULE
    public function allowsFollowUp(): bool
    {
        return in_array($this->level, [
            self::INTERESTED,
            self::DELAYED_INTEREST
        ]);
    }
    
    public function isHot(): bool
    {
        return $this->level === self::INTERESTED;
    }
    
    public function toString(): string
    {
        return $this->level;
    }
    
    public function equals(InterestLevel $other): bool
    {
        return $this->level === $other->level;
    }
}
```

**Benefits:**
- Business rules are centralized
- Type safety (can't pass wrong values)
- Self-documenting code
- Easy to test

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
```php
class LeadResponse extends Model
{
    protected $fillable = ['message', 'status'];
    
    // No behavior, just data container
}

// Business logic scattered in services
class LeadResponseService
{
    public function qualifyLead($response)
    {
        if (str_contains($response->message, 'interested')) {
            $response->status = 'interested';
        }
        $response->save();
    }
}
```

**Solution:**
```php
class LeadResponse extends Model
{
    // Business behavior in the entity
    public function qualify(InterestLevel $level): void
    {
        $this->interestLevel = $level;
    }
    
    public function isQualified(): bool
    {
        return isset($this->interestLevel);
    }
}
```

#### ❌ Anti-Pattern 2: Technical Naming

**Problem:**
```php
class DataNormalizer
{
    public function processIncomingPayload($data)
    {
        // Client has no idea what this does
    }
}
```

**Solution:**
```php
class LeadResponseAnalyzer
{
    public function assessProspectInterest(string $linkedInMessage): InterestLevel
    {
        // Clear business intent
    }
}
```

#### ❌ Anti-Pattern 3: Primitive Obsession

**Problem:**
```php
public function scheduleFollowUp(string $date, string $reason)
{
    // No validation, no business rules
}
```

**Solution:**
```php
public function scheduleFollowUp(FollowUpRequest $request)
{
    // Value object contains validation and business rules
}
```

### DDD Transformation Examples

#### Example 1: LinkedIn Lead Response

**Before (Anemic):**
```php
class OpenAiLinkedInLeadContactResponseNormalizer
{
    public function generateNormalizingPrompt(string $incomingResponse): string
    {
        // 50 lines of prompt
    }
    
    protected function mapNormalizedResponse(
        array $normalizedResponse,
        string $incomingResponse
    ): NormalizedLeadContactResponse {
        return NormalizedLeadContactResponse::validateAndCreate([
            'normalizedResponse' => $incomingResponse,
            'summary' => $normalizedResponse['summary'],
            'leadOpportunityStatus' => $normalizedResponse['leadOpportunityStatus'],
        ]);
    }
}
```

**After (Rich Domain):**
```php
// Domain Entity
class LeadResponse
{
    private string $originalMessage;
    private ResponseLanguage $language;
    private InterestLevel $interestLevel;
    private ?FollowUpRequest $followUpRequest;
    private ?CompetitorMention $competitorMention;
    
    public function qualify(InterestLevel $level): void
    {
        $this->interestLevel = $level;
    }
    
    public function requestFollowUp(FollowUpRequest $request): void
    {
        if (!$this->interestLevel->allowsFollowUp()) {
            throw new CannotScheduleFollowUpException(
                "Cannot schedule follow-up for {$this->interestLevel->toString()} leads"
            );
        }
        
        $this->followUpRequest = $request;
    }
    
    public function mentionedCompetitor(string $name): void
    {
        $this->competitorMention = new CompetitorMention($name);
    }
    
    public function isQualified(): bool
    {
        return isset($this->interestLevel);
    }
    
    public function summarize(): string
    {
        $summary = $this->originalMessage;
        
        if ($this->followUpRequest) {
            $summary .= " | {$this->followUpRequest->toString()}";
        }
        
        if ($this->competitorMention) {
            $summary .= " | Competitor: {$this->competitorMention->name}";
        }
        
        return $summary;
    }
}

// Use Case
class QualifyLeadFromLinkedInResponse
{
    private $aiAnalyzer;
    private $leadRepository;
    
    public function execute(string $message, string $leadId): LeadResponse
    {
        $response = new LeadResponse($message, ResponseLanguage::detectFrom($message));
        
        $analysis = $this->aiAnalyzer->analyze($message);
        
        $response->qualify($analysis->interestLevel);
        
        if ($analysis->hasFollowUpRequest) {
            $response->requestFollowUp(
                FollowUpRequest::fromRelativeTime($analysis->followUpTimeframe)
            );
        }
        
        if ($analysis->mentionsCompetitor) {
            $response->mentionedCompetitor($analysis->competitorName);
        }
        
        $this->leadRepository->saveResponse($leadId, $response);
        
        return $response;
    }
}
```

**What Changed:**
- Technical names → Business language
- Passive data → Active domain objects
- Scattered logic → Centralized business rules
- Hard to understand → Client can read it

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
❌ Entities CANNOT depend on Eloquent (except pragmatically)
```

### Three Approaches: When to Use What

OneSyntax supports three levels of Clean Architecture implementation. Choose based on project complexity:

#### Approach 1: Pragmatic (Simple Projects)

**When to use:**
- Simple CRUD operations
- Small team or solo dev
- Quick MVP or prototype
- Low complexity business logic

**Structure:**
```php
// UseCase calls Eloquent directly
class CancelBooking
{
    public function execute(string $bookingId)
    {
        $booking = Booking::find($bookingId);
        
        if (!$booking->canBeCancelled()) {
            throw new BookingCancellationException();
        }
        
        $booking->cancel();
        $booking->save();
        
        return $booking;
    }
}
```

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

**Structure:**
```php
// UseCase depends on Repository Interface
class CancelBooking
{
    private $bookingRepository;
    
    public function __construct(BookingRepositoryInterface $repository)
    {
        $this->bookingRepository = $repository;
    }
    
    public function execute(string $bookingId)
    {
        $booking = $this->bookingRepository->findById($bookingId);
        
        if (!$booking->canBeCancelled()) {
            throw new BookingCancellationException();
        }
        
        $booking->cancel();
        return $this->bookingRepository->save($booking);
    }
}

// Repository in IO layer
class EloquentBookingRepository implements BookingRepositoryInterface
{
    public function findById(string $id): ?Booking
    {
        return Booking::find($id);
    }
    
    public function save(Booking $booking): Booking
    {
        $booking->save();
        return $booking;
    }
}
```

**Trade-offs:**
- ✅ Decoupled from Eloquent
- ✅ Easy to test
- ✅ Can swap data sources
- ❌ More boilerplate

#### Approach 3: Purist (Complex Projects)

**When to use:**
- High complexity
- Multiple interfaces (HTTP, CLI, GraphQL)
- Different output formats needed
- Enterprise-level projects

**Structure:**
```php
// UseCase with Presenter pattern
class CancelBooking
{
    private $repository;
    
    public function execute(
        string $bookingId, 
        CancelBookingPresenterInterface $presenter
    ) {
        $booking = $this->repository->findById($bookingId);
        
        if (!$booking) {
            return $presenter->presentNotFound($bookingId);
        }
        
        if (!$booking->canBeCancelled()) {
            return $presenter->presentCannotCancel('Booking has started');
        }
        
        $booking->cancel();
        $booking = $this->repository->save($booking);
        
        return $presenter->presentSuccess($booking);
    }
}

// JSON Presenter for API
class CancelBookingJsonPresenter implements CancelBookingPresenterInterface
{
    public function presentSuccess(Booking $booking): array
    {
        return [
            'success' => true,
            'data' => ['id' => $booking->id, 'status' => 'cancelled']
        ];
    }
    
    public function presentNotFound(string $id): array
    {
        return [
            'success' => false,
            'error' => ['code' => 'not_found', 'message' => 'Booking not found']
        ];
    }
}

// CLI Presenter for Commands
class CancelBookingCliPresenter implements CancelBookingPresenterInterface
{
    public function presentSuccess(Booking $booking): string
    {
        return "✓ Booking {$booking->id} cancelled successfully.";
    }
    
    public function presentNotFound(string $id): string
    {
        return "✗ Error: Booking {$id} not found.";
    }
}
```

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
```php
// app/Booking/IO/Http/BookingController.php
class BookingController
{
    public function cancel(string $id)
    {
        $booking = Booking::find($id);
        
        // Business logic in controller!
        if ($booking->status !== 'active') {
            return response()->json(['error' => 'Cannot cancel'], 400);
        }
        
        if ($booking->start_date < now()) {
            return response()->json(['error' => 'Already started'], 400);
        }
        
        $booking->status = 'cancelled';
        $booking->save();
        
        return response()->json(['success' => true]);
    }
}
```

**Solution:**
```php
// Business logic in UseCase
class CancelBooking
{
    public function execute(string $bookingId): Booking
    {
        $booking = $this->repository->findById($bookingId);
        
        if (!$booking->canBeCancelled()) {
            throw new BookingCancellationException();
        }
        
        $booking->cancel();
        return $this->repository->save($booking);
    }
}

// Controller is thin
class BookingController
{
    public function cancel(string $id)
    {
        try {
            $booking = $this->cancelBooking->execute($id);
            return response()->json(['success' => true, 'data' => $booking]);
        } catch (BookingCancellationException $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }
}
```

#### ❌ Anti-Pattern 2: Framework Dependencies in Domain

**Problem:**
```php
// app/Booking/Entities/Booking.php
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;

class Booking extends Model
{
    public function cancel(Request $request)
    {
        $this->status = 'cancelled';
        $this->save();
        
        // Framework dependency!
        Mail::to($this->user)->send(new BookingCancelled($this));
    }
}
```

**Solution:**
```php
// Entity has no framework dependencies
class Booking extends Model
{
    public function cancel(): self
    {
        $this->status = 'cancelled';
        $this->cancelled_at = now();
        return $this;
    }
}

// UseCase coordinates side effects
class CancelBooking
{
    private $repository;
    private $notificationService;
    
    public function execute(string $bookingId): Booking
    {
        $booking = $this->repository->findById($bookingId);
        $booking->cancel();
        $booking = $this->repository->save($booking);
        
        // Side effects in use case
        $this->notificationService->sendCancellationEmail($booking);
        
        return $booking;
    }
}
```

#### ❌ Anti-Pattern 3: Mixing IO Concerns with Business Logic

**Problem:**
```php
class CreateBooking
{
    public function execute(Request $request)
    {
        // Mixing HTTP concerns with business logic
        $validated = $request->validate([
            'user_id' => 'required',
            'start_date' => 'required|date',
        ]);
        
        $booking = new Booking($validated);
        $booking->save();
        
        return response()->json($booking, 201);
    }
}
```

**Solution:**
```php
// Use Case is framework-agnostic
class CreateBooking
{
    public function execute(CreateBookingRequest $request): Booking
    {
        $booking = new Booking();
        $booking->user_id = $request->userId;
        $booking->start_date = $request->startDate;
        $booking->end_date = $request->endDate;
        
        return $this->repository->save($booking);
    }
}

// Controller handles HTTP concerns
class BookingController
{
    public function store(Request $httpRequest)
    {
        $validated = $httpRequest->validate([
            'user_id' => 'required',
            'start_date' => 'required|date',
        ]);
        
        $request = CreateBookingRequest::from($validated);
        $booking = $this->createBooking->execute($request);
        
        return response()->json($booking, 201);
    }
}
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
The `LeadResponse` entity is a passive data container. Business logic is scattered in services.

**Why this matters:**
Our clients trust us to understand their business. When business rules are hidden in services with technical names, we're working in isolation from their mental model.

**Requested changes:**
1. Move `qualifyLead()` logic into the `LeadResponse` entity as `qualify(InterestLevel $level)`
2. Add `isQualified(): bool` method
3. Add `requestFollowUp(FollowUpRequest $request)` method

**Example:**
See app/Booking/Entities/Booking.php for rich domain model example.
```

#### Template 2: Framework Leakage

```markdown
❗️This violates Clean Architecture - framework dependency in domain layer.

**Current code:**
`app/Payment/Entities/Invoice.php` imports `Illuminate\Http\Request`

**Why this matters:**
We promise clients their software will last. Framework dependencies in domain create technical debt. When Laravel 15 comes out, we shouldn't need to touch domain logic.

**Requested changes:**
1. Remove `Illuminate\Http\Request` import
2. Pass primitive values or DTOs to entity methods
3. Move HTTP concerns to Controller layer

**Reference:**
See "Clean Architecture Anti-Patterns" in OneSyntax-Development-System.md
```

#### Template 3: Business Logic in Controller

```markdown
❗️Business logic belongs in UseCases, not Controllers.

**Current code:**
`BookingController::cancel()` contains cancellation rules and validation

**Why this matters:**
Controllers are IO layer - they should be thin. Business logic in controllers makes it impossible to reuse from CLI, queues, or other interfaces. This violates our accountability to build maintainable software.

**Requested changes:**
1. Create `CancelBooking` use case
2. Move cancellation logic to use case
3. Controller should only handle HTTP concerns (validation, response formatting)

**Approach:**
Use Standard approach (repository pattern) since this has business complexity.
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

**Example:**
```php
// app/Booking/Specs/Unit/BookingTest.php
namespace App\Booking\Specs\Unit;

use App\Booking\Entities\Booking;
use PHPUnit\Framework\TestCase;

class BookingTest extends TestCase
{
    /** @test */
    public function it_can_be_cancelled_when_active_and_not_started()
    {
        $booking = new Booking();
        $booking->status = 'active';
        $booking->start_date = now()->addDays(7);
        
        $this->assertTrue($booking->canBeCancelled());
        
        $booking->cancel();
        
        $this->assertEquals('cancelled', $booking->status);
        $this->assertNotNull($booking->cancelled_at);
    }
    
    /** @test */
    public function it_cannot_be_cancelled_when_already_started()
    {
        $booking = new Booking();
        $booking->status = 'active';
        $booking->start_date = now()->subDays(1);
        
        $this->assertFalse($booking->canBeCancelled());
    }
    
    /** @test */
    public function it_throws_exception_when_cancelling_invalid_booking()
    {
        $this->expectException(BookingCancellationException::class);
        
        $booking = new Booking();
        $booking->status = 'completed';
        
        $booking->cancel();
    }
}
```

#### 2. Use Case Tests (Application Logic)

**What:** Test business workflows
**Location:** `app/DomainName/Specs/UseCases/`
**Coverage Target:** All use cases, happy path + major edge cases

**Example:**
```php
// app/Booking/Specs/UseCases/CancelBookingTest.php
namespace App\Booking\Specs\UseCases;

use App\Booking\UseCases\CancelBooking;
use App\Booking\Testing\BookingRepositoryMock;
use App\Booking\Entities\Booking;
use PHPUnit\Framework\TestCase;

class CancelBookingTest extends TestCase
{
    private CancelBooking $useCase;
    private BookingRepositoryMock $repository;
    
    protected function setUp(): void
    {
        $this->repository = new BookingRepositoryMock();
        $this->useCase = new CancelBooking($this->repository);
    }
    
    /** @test */
    public function it_cancels_an_active_booking()
    {
        $booking = new Booking();
        $booking->id = 1;
        $booking->status = 'active';
        $booking->start_date = now()->addDays(7);
        
        $this->repository->addBooking($booking);
        
        $result = $this->useCase->execute('1');
        
        $this->assertEquals('cancelled', $result->status);
        $this->assertNotNull($this->repository->getLastSavedBooking());
    }
    
    /** @test */
    public function it_throws_exception_for_non_existent_booking()
    {
        $this->expectException(BookingNotFoundException::class);
        
        $this->useCase->execute('999');
    }
    
    /** @test */
    public function it_throws_exception_for_already_started_booking()
    {
        $booking = new Booking();
        $booking->id = 1;
        $booking->status = 'active';
        $booking->start_date = now()->subDays(1);
        
        $this->repository->addBooking($booking);
        
        $this->expectException(BookingCancellationException::class);
        
        $this->useCase->execute('1');
    }
}
```

#### 3. Integration Tests (Full Flow)

**What:** Test complete features including database
**Location:** `tests/Feature/`
**Coverage Target:** Critical user journeys

**Example:**
```php
// tests/Feature/BookingCancellationTest.php
namespace Tests\Feature;

use Tests\TestCase;
use App\User\Entities\User;
use App\Booking\Entities\Booking;
use Illuminate\Foundation\Testing\RefreshDatabase;

class BookingCancellationTest extends TestCase
{
    use RefreshDatabase;
    
    /** @test */
    public function user_can_cancel_their_active_booking_via_api()
    {
        $user = User::factory()->create();
        $booking = Booking::factory()->create([
            'user_id' => $user->id,
            'status' => 'active',
            'start_date' => now()->addDays(7)
        ]);
        
        $response = $this->actingAs($user)
            ->deleteJson("/api/bookings/{$booking->id}");
        
        $response->assertOk();
        $response->assertJson(['success' => true]);
        
        $this->assertDatabaseHas('bookings', [
            'id' => $booking->id,
            'status' => 'cancelled'
        ]);
    }
}
```

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

### Testing Utilities

Each domain should provide testing utilities:

```php
// app/Booking/Testing/BookingFactory.php
namespace App\Booking\Testing;

use App\Booking\Entities\Booking;

class BookingFactory
{
    public static function createActiveBooking(array $overrides = []): Booking
    {
        $booking = new Booking();
        $booking->status = 'active';
        $booking->start_date = now()->addDays(7);
        $booking->end_date = now()->addDays(14);
        
        foreach ($overrides as $key => $value) {
            $booking->$key = $value;
        }
        
        return $booking;
    }
    
    public static function createStartedBooking(array $overrides = []): Booking
    {
        return self::createActiveBooking(array_merge([
            'start_date' => now()->subDays(1)
        ], $overrides));
    }
}
```

### Coverage Requirements

- **Domain logic (Entities/UseCases):** 90%+ coverage
- **Controllers:** 70%+ coverage (focus on error handling)
- **Overall project:** 80%+ coverage

Run coverage reports:
```bash
./vendor/bin/phpunit --coverage-html build/coverage
```

---

## Enforcement Mechanisms

### Why Enforcement Matters to Our Mission

**Enforcement isn't about mistrust - it's proof we're disciplined.**

We say we practice XP/Agile properly, not as buzzwords. Automated enforcement proves it. When clients ask "how do you ensure quality?" we show them the guardrails, not promises.

### Layer 1: Pre-Commit Enforcement

**Goal:** Catch violations before they're committed

#### PHP CS Fixer Configuration

```php
// .php-cs-fixer.php
<?php

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

$finder = Finder::create()
    ->in([
        __DIR__ . '/app',
    ])
    ->name('*.php')
    ->ignoreDotFiles(true)
    ->ignoreVCS(true);

return (new Config())
    ->setRules([
        '@PSR12' => true,
        'array_syntax' => ['syntax' => 'short'],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'no_unused_imports' => true,
        'not_operator_with_successor_space' => true,
        'trailing_comma_in_multiline' => true,
        'phpdoc_scalar' => true,
        'unary_operator_spaces' => true,
        'binary_operator_spaces' => true,
        'blank_line_before_statement' => [
            'statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try'],
        ],
        'phpdoc_single_line_var_spacing' => true,
        'phpdoc_var_without_name' => true,
    ])
    ->setFinder($finder);
```

**Run manually:**
```bash
./vendor/bin/php-cs-fixer fix
```

#### PHPStan Configuration

```yaml
# phpstan.neon
includes:
    - vendor/nunomaduro/larastan/extension.neon

parameters:
    paths:
        - app
    level: 6
    
    # Ignore Eloquent in Entities (pragmatic choice)
    ignoreErrors:
        - '#Call to an undefined method Illuminate\\Database\\Eloquent\\.*#'
    
    # Custom rules
    excludePaths:
        - app/*/IO/*
```

**Run manually:**
```bash
./vendor/bin/phpstan analyze
```

#### Git Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Running OneSyntax pre-commit checks..."

# PHP CS Fixer
echo "→ Checking code style..."
./vendor/bin/php-cs-fixer fix --dry-run --diff
if [ $? -ne 0 ]; then
    echo "❌ Code style issues found. Run: ./vendor/bin/php-cs-fixer fix"
    exit 1
fi

# PHPStan
echo "→ Running static analysis..."
./vendor/bin/phpstan analyze --error-format=table
if [ $? -ne 0 ]; then
    echo "❌ PHPStan found issues"
    exit 1
fi

# Architecture Tests
echo "→ Running architecture tests..."
./vendor/bin/phpunit tests/Architecture --testdox
if [ $? -ne 0 ]; then
    echo "❌ Architecture violations found"
    exit 1
fi

echo "✅ All pre-commit checks passed!"
exit 0
```

**Install hook:**
```bash
chmod +x .git/hooks/pre-commit
```

### Layer 2: Pull Request Enforcement

#### GitHub PR Template

```markdown
<!-- .github/pull_request_template.md -->

## Description
Brief description of changes

## OneSyntax Standards

Our mission: True partnership through accountable, professional development

### Partnership (DDD)
- [ ] Code uses ubiquitous language (checked against Domain Dictionary)
- [ ] Entities have business behavior (list methods): 
- [ ] Business rules are explicit and in domain layer
- [ ] Value objects used where appropriate (list them):

### Accountability (CA)
- [ ] No framework dependencies in Entities layer
- [ ] No framework dependencies in UseCases layer
- [ ] Business logic is in UseCases, not Controllers
- [ ] IO layer properly separated (Database, Http, Console)
- [ ] Architecture approach chosen (select one):
  - [ ] Pragmatic (simple CRUD, justified because: ___)
  - [ ] Standard (repository pattern)
  - [ ] Purist (presenter pattern, justified because: ___)

### Professionalism (Quality)
- [ ] Unit tests for domain logic (coverage: __%)
- [ ] Use case tests written
- [ ] Tests use domain Testing utilities
- [ ] No security issues
- [ ] Performance considered

## Reviewer Checklist

**DO NOT APPROVE unless:**
- [ ] All checkboxes above are checked
- [ ] Automated checks pass (CS Fixer, PHPStan, Tests)
- [ ] Code follows OneSyntax patterns
- [ ] Educational feedback provided (if applicable)

## Related Issues
Closes #___
```

#### Branch Protection Rules

Configure in GitHub Settings → Branches:

**Protection for `main` and `develop`:**
- ✅ Require pull request reviews (1 approval minimum)
- ✅ Require status checks to pass:
  - `php-cs-fixer`
  - `phpstan`
  - `tests`
  - `architecture-tests`
- ✅ Require conversation resolution
- ✅ Require linear history
- ✅ Include administrators (even Kalpa follows rules)

#### CODEOWNERS

```
# .github/CODEOWNERS

# Default: Any senior can review
* @senior-dev-1 @senior-dev-2 @senior-dev-3 @senior-dev-4

# Architecture changes require Kalpa (first 3 months)
/app/*/Entities/ @kalpa
/app/*/UseCases/ @kalpa
/docs/architecture/ @kalpa

# After training complete, seniors can handle:
# /app/*/Entities/ @senior-dev-1 @senior-dev-2
# /app/*/UseCases/ @senior-dev-1 @senior-dev-2
```

### Layer 3: Architecture Tests

```php
// tests/Architecture/DomainLayerTest.php
<?php

namespace Tests\Architecture;

use PHPUnit\Framework\TestCase;

class DomainLayerTest extends TestCase
{
    /** @test */
    public function entities_should_not_depend_on_framework()
    {
        $entityFiles = glob(__DIR__ . '/../../app/*/Entities/*.php');
        
        foreach ($entityFiles as $file) {
            $content = file_get_contents($file);
            
            $this->assertStringNotContainsString(
                'use Illuminate\\Http',
                $content,
                "Entity {$file} should not depend on HTTP framework"
            );
            
            $this->assertStringNotContainsString(
                'use Illuminate\\Support\\Facades',
                $content,
                "Entity {$file} should not use facades"
            );
        }
    }
    
    /** @test */
    public function use_cases_should_not_depend_on_framework()
    {
        $useCaseFiles = glob(__DIR__ . '/../../app/*/UseCases/*.php');
        
        foreach ($useCaseFiles as $file) {
            $content = file_get_contents($file);
            
            $forbiddenImports = [
                'use Illuminate\\Http',
                'use Illuminate\\Support\\Facades',
                'use Laravel\\',
            ];
            
            foreach ($forbiddenImports as $import) {
                $this->assertStringNotContainsString(
                    $import,
                    $content,
                    "UseCase {$file} should not depend on framework: {$import}"
                );
            }
        }
    }
    
    /** @test */
    public function controllers_should_only_call_use_cases()
    {
        $controllerFiles = glob(__DIR__ . '/../../app/*/IO/Http/*Controller.php');
        
        foreach ($controllerFiles as $file) {
            $content = file_get_contents($file);
            
            // Controllers should not have business logic
            $this->assertStringNotContainsString(
                '->save(',
                $content,
                "Controller {$file} should not call save() directly - use UseCases"
            );
            
            $this->assertStringNotContainsString(
                '::create(',
                $content,
                "Controller {$file} should not call create() directly - use UseCases"
            );
        }
    }
    
    /** @test */
    public function entities_should_have_behavior_methods()
    {
        $entityFiles = glob(__DIR__ . '/../../app/*/Entities/*.php');
        
        foreach ($entityFiles as $file) {
            $className = $this->getClassNameFromFile($file);
            
            if (!class_exists($className)) {
                continue;
            }
            
            $reflection = new \ReflectionClass($className);
            $methods = $reflection->getMethods(\ReflectionMethod::IS_PUBLIC);
            
            // Filter out getters/setters/relationships
            $behaviorMethods = array_filter($methods, function($method) {
                $name = $method->getName();
                
                $isGetter = str_starts_with($name, 'get');
                $isSetter = str_starts_with($name, 'set');
                $isRelationship = in_array($name, ['belongsTo', 'hasMany', 'hasOne', 'belongsToMany']);
                $isMagic = str_starts_with($name, '__');
                
                return !$isGetter && !$isSetter && !$isRelationship && !$isMagic;
            });
            
            $this->assertGreaterThan(
                0,
                count($behaviorMethods),
                "Entity {$className} has no behavior methods (anemic model). Add domain behavior."
            );
        }
    }
    
    private function getClassNameFromFile(string $file): string
    {
        $content = file_get_contents($file);
        
        preg_match('/namespace\s+(.+);/', $content, $namespaceMatch);
        preg_match('/class\s+(\w+)/', $content, $classMatch);
        
        if (empty($namespaceMatch[1]) || empty($classMatch[1])) {
            return '';
        }
        
        return $namespaceMatch[1] . '\\' . $classMatch[1];
    }
}
```

### Layer 4: Continuous Integration

```yaml
# .github/workflows/code-quality.yml
name: OneSyntax Quality Checks

on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  quality:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: 8.2
          extensions: mbstring, pdo, pdo_mysql
          coverage: xdebug
          
      - name: Install dependencies
        run: composer install --prefer-dist --no-progress
        
      - name: Check code style
        run: vendor/bin/php-cs-fixer fix --dry-run --diff --verbose
        
      - name: Run static analysis
        run: vendor/bin/phpstan analyze --error-format=github
        
      - name: Run architecture tests
        run: vendor/bin/phpunit tests/Architecture --testdox
        
      - name: Run unit tests
        run: vendor/bin/phpunit --testsuite=Unit --coverage-text
        
      - name: Run feature tests
        run: vendor/bin/phpunit --testsuite=Feature
        
      - name: Generate coverage report
        run: vendor/bin/phpunit --coverage-html build/coverage
        
      - name: Upload coverage
        uses: actions/upload-artifact@v3
        with:
          name: coverage-report
          path: build/coverage
```

### Layer 5: Weekly Health Check

```php
// app/Console/Commands/ArchitectureHealthCheck.php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class ArchitectureHealthCheck extends Command
{
    protected $signature = 'onesyntax:health-check';
    protected $description = 'Check OneSyntax architecture health';
    
    public function handle()
    {
        $this->info('🏥 Running OneSyntax Architecture Health Check...');
        $this->newLine();
        
        $issues = [];
        
        // Check 1: Anemic Entities
        $this->info('Checking for anemic entities...');
        $anemicEntities = $this->checkAnemicEntities();
        if (count($anemicEntities) > 0) {
            $issues['anemic_entities'] = $anemicEntities;
            $this->warn("Found " . count($anemicEntities) . " anemic entities");
        } else {
            $this->info('✓ No anemic entities found');
        }
        
        // Check 2: Framework Leakage
        $this->info('Checking for framework dependencies in domain...');
        $frameworkLeaks = $this->checkFrameworkLeakage();
        if (count($frameworkLeaks) > 0) {
            $issues['framework_leakage'] = $frameworkLeaks;
            $this->warn("Found " . count($frameworkLeaks) . " framework dependencies in domain");
        } else {
            $this->info('✓ No framework leakage detected');
        }
        
        // Check 3: Missing Tests
        $this->info('Checking test coverage...');
        $missingTests = $this->checkMissingTests();
        if (count($missingTests) > 0) {
            $issues['missing_tests'] = $missingTests;
            $this->warn("Found " . count($missingTests) . " files without tests");
        } else {
            $this->info('✓ All files have tests');
        }
        
        // Generate report
        $this->newLine();
        if (empty($issues)) {
            $this->info('🎉 All checks passed! Architecture is healthy.');
            return 0;
        }
        
        $this->error('⚠️  Issues found. See details below:');
        $this->displayIssues($issues);
        
        // Send notification (optional)
        // $this->notifyTeam($issues);
        
        return 1;
    }
    
    private function checkAnemicEntities(): array
    {
        $anemic = [];
        $entityFiles = glob(base_path('app/*/Entities/*.php'));
        
        foreach ($entityFiles as $file) {
            $content = file_get_contents($file);
            
            // Simple heuristic: count public methods
            preg_match_all('/public function (?!get|set|__)\w+/', $content, $matches);
            
            if (count($matches[0]) === 0) {
                $anemic[] = str_replace(base_path(), '', $file);
            }
        }
        
        return $anemic;
    }
    
    private function checkFrameworkLeakage(): array
    {
        $leaks = [];
        $domainFiles = array_merge(
            glob(base_path('app/*/Entities/*.php')),
            glob(base_path('app/*/UseCases/*.php'))
        );
        
        foreach ($domainFiles as $file) {
            $content = file_get_contents($file);
            
            if (str_contains($content, 'use Illuminate\\Http') ||
                str_contains($content, 'use Illuminate\\Support\\Facades')) {
                $leaks[] = str_replace(base_path(), '', $file);
            }
        }
        
        return $leaks;
    }
    
    private function checkMissingTests(): array
    {
        $missing = [];
        
        $entityFiles = glob(base_path('app/*/Entities/*.php'));
        $useCaseFiles = glob(base_path('app/*/UseCases/*.php'));
        
        foreach (array_merge($entityFiles, $useCaseFiles) as $file) {
            $testPath = $this->getTestPath($file);
            
            if (!file_exists($testPath)) {
                $missing[] = str_replace(base_path(), '', $file);
            }
        }
        
        return $missing;
    }
    
    private function getTestPath(string $file): string
    {
        // Convert app/Domain/Entities/Entity.php -> app/Domain/Specs/Unit/EntityTest.php
        $path = str_replace('/Entities/', '/Specs/Unit/', $file);
        $path = str_replace('/UseCases/', '/Specs/UseCases/', $path);
        $path = str_replace('.php', 'Test.php', $path);
        
        return $path;
    }
    
    private function displayIssues(array $issues): void
    {
        foreach ($issues as $type => $items) {
            $this->newLine();
            $this->warn(strtoupper(str_replace('_', ' ', $type)) . ':');
            
            foreach ($items as $item) {
                $this->line('  - ' . $item);
            }
        }
    }
}
```

**Schedule weekly:**
```php
// app/Console/Kernel.php
protected function schedule(Schedule $schedule)
{
    $schedule->command('onesyntax:health-check')
        ->weekly()
        ->mondays()
        ->at('09:00');
}
```

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
- Exercise: Transform one anemic entity together (live coding)

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
- "Domain-Driven Design" by Eric Evans (relevant chapters)
- "Clean Architecture" by Robert C. Martin (relevant chapters)

**Reference Projects:**
- [Project A] - Example of Standard approach
- [Project B] - Example of Purist approach
- [Project C] - Example of DDD done well

**Slack Channel:**
- #architecture - For questions and discussions

**1-on-1s with Kalpa:**
- Weekly during training
- Bi-weekly after autonomy
- Discuss: challenges, decisions, growth

---

## Implementation Roadmap

### Overview

This roadmap takes you from current state (everything depends on Kalpa) to target state (seniors can run the system).

**Total Timeline: 6 months to full autonomy**

### Month 1: Build the Foundation

#### Week 1: Documentation
- [ ] Kalpa: Finalize this document
- [ ] Kalpa: Create domain language dictionaries for top 3 projects
- [ ] Kalpa: Identify 5 before/after examples from codebase
- [ ] All: Read and review document

**Time Investment:**
- Kalpa: 10 hours
- Seniors: 4 hours each

#### Week 2: Enforcement Setup
- [ ] Kalpa: Configure PHP CS Fixer
- [ ] Kalpa: Configure PHPStan
- [ ] Kalpa: Create architecture tests
- [ ] Kalpa: Set up GitHub workflows
- [ ] Kalpa: Create PR template

**Time Investment:**
- Kalpa: 12 hours

#### Week 3: Prepare Training
- [ ] Kalpa: Prepare workshop materials
- [ ] Kalpa: Create practice exercises
- [ ] Kalpa: Choose reference implementation project
- [ ] Kalpa: Schedule training sessions

**Time Investment:**
- Kalpa: 6 hours

#### Week 4: Golden Circle + DDD Workshop
- [ ] Run Monday workshop (2 hours)
- [ ] Run Wednesday session (2 hours)
- [ ] Assign homework (Friday)
- [ ] Seniors: Complete reading and exercises

**Time Investment:**
- Kalpa: 6 hours
- Seniors: 8 hours each

### Month 2: Initial Training

#### Week 5: CA Workshop + Practice
- [ ] Run CA workshop (Monday, 2 hours)
- [ ] Run decision practice (Wednesday, 2 hours)
- [ ] Review homework (Friday, 2 hours)

**Time Investment:**
- Kalpa: 6 hours
- Seniors: 8 hours each

#### Week 6-8: Pairing Sessions
- [ ] Each senior pairs with Kalpa 2 hours/week
- [ ] Seniors refactor chosen features
- [ ] Peer review practice sessions

**Time Investment:**
- Kalpa: 8 hours/week
- Seniors: 6 hours/week each

### Month 3: Hands-On Practice

#### Week 9-12: Refactoring Projects
- [ ] Seniors complete assigned refactoring tasks
- [ ] Weekly architecture discussions (1 hour)
- [ ] Kalpa provides meta-reviews
- [ ] Continuous improvement of enforcement tools

**Time Investment:**
- Kalpa: 6 hours/week
- Seniors: 8 hours/week each

**Milestone:** By end of Month 3, seniors should be able to identify and fix DDD/CA violations independently.

### Month 4: Teaching Others

#### Week 13-14: Prepare Teaching Materials
- [ ] Seniors create before/after examples
- [ ] Seniors create anti-pattern guides
- [ ] Kalpa reviews materials

**Time Investment:**
- Kalpa: 4 hours
- Seniors: 6 hours each

#### Week 15-16: Run Junior Workshops
- [ ] Each senior teaches one workshop
- [ ] Kalpa observes and provides feedback
- [ ] Collect feedback from juniors

**Time Investment:**
- Kalpa: 4 hours
- Seniors: 4 hours each

### Month 5: Supervised Autonomy

#### Week 17-20: Seniors Lead Reviews
- [ ] Seniors handle all code reviews
- [ ] Kalpa spot-checks 20% of reviews
- [ ] Weekly retro on decisions made
- [ ] Document edge cases and learnings

**Time Investment:**
- Kalpa: 4 hours/week (spot checks)
- Seniors: Normal review time

**Milestone:** By end of Month 5, seniors should handle 80% of decisions without Kalpa.

### Month 6: Full Autonomy

#### Week 21-24: Independence
- [ ] Seniors fully autonomous for standard decisions
- [ ] Kalpa only consulted for major changes
- [ ] Monthly architecture review meeting
- [ ] System health checks automated

**Time Investment:**
- Kalpa: 2-3 hours/week (strategic only)
- Seniors: Normal workload

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

**After Month 6:**
- [ ] Seniors handle 80%+ of code reviews
- [ ] Architecture tests consistently pass
- [ ] Junior devs understand OneSyntax standards
- [ ] Client feedback remains positive
- [ ] Kalpa's code review time < 20%

### Risk Mitigation

**Risk 1: Seniors don't have time for training**
- Mitigation: Reduce billable hours target during training months
- Allocate 20% of senior time to training (10 hours/week)
- Adjust project timelines accordingly

**Risk 2: Resistance to change**
- Mitigation: Start with Golden Circle workshop
- Frame as leadership development, not criticism
- Involve seniors in creating solutions

**Risk 3: Training takes longer than expected**
- Mitigation: Build buffer into timeline
- Can extend Phase 2 if needed
- Better to train well than train fast

**Risk 4: Junior devs fall behind**
- Mitigation: Seniors teach juniors in Month 4
- Provide simplified documentation for juniors
- Pair juniors with seniors on real work

### Investment Summary

**Kalpa's Time Investment:**
- Month 1: ~34 hours (documentation + setup)
- Month 2: ~30 hours (training + pairing)
- Month 3: ~24 hours (pairing + reviews)
- Month 4: ~16 hours (oversight)
- Month 5: ~16 hours (spot checks)
- Month 6+: ~10 hours/month (strategic only)

**Total: ~120 hours over 6 months = 3 weeks of focused work spread over 6 months**

**Return on Investment:**
- Current: 50% of Kalpa's time on reviews = 20 hours/week
- Target: 10% of Kalpa's time on reviews = 4 hours/week
- **Savings: 16 hours/week after 6 months = 64 hours/month**

**Break-even: After 2 months, investment pays for itself**

---

## Appendix

### Quick Reference Checklists

#### Before Creating an Entity

- [ ] What's the ubiquitous language term?
- [ ] What business rules does this entity have?
- [ ] What behavior methods should it have?
- [ ] Do I need value objects?
- [ ] Where does validation happen?

#### Before Creating a UseCase

- [ ] What's the business workflow?
- [ ] Which approach: Pragmatic/Standard/Purist?
- [ ] What are the inputs/outputs?
- [ ] What can go wrong (exceptions)?
- [ ] How will I test this?

#### Before Submitting a PR

- [ ] Ran PHP CS Fixer
- [ ] Ran PHPStan
- [ ] All tests pass
- [ ] Architecture tests pass
- [ ] PR checklist completed
- [ ] Domain Dictionary updated (if needed)

### Common Patterns

#### Creating a Value Object

```php
class [Name]
{
    private [type] $value;
    
    private function __construct([type] $value)
    {
        $this->validate($value);
        $this->value = $value;
    }
    
    public static function from[Source]([type] $value): self
    {
        return new self($value);
    }
    
    private function validate([type] $value): void
    {
        // Business validation rules
    }
    
    public function equals([Name] $other): bool
    {
        return $this->value === $other->value;
    }
    
    public function toString(): string
    {
        return (string) $this->value;
    }
}
```

#### Creating a Repository Interface

```php
// app/[Domain]/UseCases/Repositories/[Entity]RepositoryInterface.php
namespace App\[Domain]\UseCases\Repositories;

use App\[Domain]\Entities\[Entity];

interface [Entity]RepositoryInterface
{
    public function findById(string $id): ?[Entity];
    public function save([Entity] $entity): [Entity];
    public function delete(string $id): bool;
    
    // Add domain-specific query methods
    public function findActive(): array;
}
```

#### Creating a UseCase

```php
// app/[Domain]/UseCases/[ActionName].php
namespace App\[Domain]\UseCases;

use App\[Domain]\Entities\[Entity];
use App\[Domain]\UseCases\Repositories\[Entity]RepositoryInterface;

class [ActionName]
{
    private $repository;
    
    public function __construct([Entity]RepositoryInterface $repository)
    {
        $this->repository = $repository;
    }
    
    public function execute([Input] $input): [Output]
    {
        // 1. Get entities from repository
        // 2. Execute business logic (call entity methods)
        // 3. Save entities
        // 4. Return result
    }
}
```

### Troubleshooting

**Q: When should I create a Value Object vs just use a string?**
A: Create a Value Object when:
- The concept has business meaning
- It has validation rules
- It appears in multiple places
- Future rules might be added

**Q: My entity is getting too big. What should I do?**
A: Consider:
- Extracting value objects
- Creating separate aggregates
- Moving some behavior to domain services
- Reviewing if it's actually multiple entities

**Q: Should I use Eloquent relationships in entities?**
A: Yes, pragmatically. But:
- Don't use relationships in business logic
- Load relationships explicitly when needed
- Consider repositories for complex queries

**Q: How do I test UseCases that send emails?**
A: Use dependency injection:
- Inject notification service interface
- Mock in tests
- Real implementation in production

**Q: Can I mix approaches in one project?**
A: Yes, but be consistent per domain:
- Simple domains: Pragmatic
- Complex domains: Standard or Purist
- Document the choice in domain README

### Glossary

**Anemic Model:** Entity with no business logic, just getters/setters

**Ubiquitous Language:** Business terminology used consistently in code and conversation

**Value Object:** Immutable object defined by its value, not identity

**Aggregate:** Cluster of entities treated as a single unit

**Repository:** Abstraction for data access

**Use Case / Interactor:** Application business logic coordinator

**Presenter:** Formats output for specific interface

**Domain Event:** Something that happened in the domain

**Entity:** Object with identity and lifecycle

**Service:** Stateless operation that doesn't belong to any entity

---

## Revision History

- **v1.0 (November 2025)** - Initial release
  - Golden Circle alignment
  - DDD principles and examples
  - Clean Architecture guidelines
  - Code review standards
  - Testing standards
  - Enforcement mechanisms
  - Senior training plan
  - Implementation roadmap

---

## Contact & Support

**Questions?** Ask in #architecture Slack channel

**Need clarification?** Schedule time with Kalpa

**Found an issue?** Create PR to update this document

**Success story?** Share in team meeting!

---

**Remember: This system exists to support OneSyntax's mission of true partnership through accountable, professional development. Every practice, every standard, every review is an opportunity to keep that promise to our clients.**

**Let's build software that matters. Together.**
