# Simple Design Guidelines
## Balancing "Simplest Thing That Works" with Architectural Standards

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Start simple, add complexity only when needed

---

## Table of Contents

1. [The Tension](#the-tension)
2. [Simple Design Principles](#simple-design-principles)
3. [When to Apply Full DDD](#when-to-apply-full-ddd)
4. [When Simpler Patterns Suffice](#when-simpler-patterns-suffice)
5. [Refactoring Triggers](#refactoring-triggers)
6. [Decision Framework](#decision-framework)
7. [YAGNI Exceptions](#yagni-exceptions)

---

## The Tension

### XP's Simple Design vs OneSyntax Standards

**XP says:**
> "Do the simplest thing that could possibly work. You aren't going to need it (YAGNI)."

**OneSyntax standards say:**
> "Follow DDD + Clean Architecture. Domain layer isolated, no framework dependencies, rich domain models."

**The conflict:**
- XP wants to start simple, add complexity later
- Our standards want proper architecture upfront
- XP says "refactor when needed"
- Our standards say "do it right the first time"

### The OneSyntax Resolution

**Core principle:**
> "Start with the simplest pattern that satisfies architectural boundaries, then add complexity only when business complexity demands it."

**What this means:**
- ✅ Architectural layers are non-negotiable (always follow Clean Architecture)
- ✅ Domain layer must be isolated (no framework dependencies ever)
- ⚠️ Domain patterns can start simple and evolve (anemic → rich when needed)
- ⚠️ Don't build infrastructure for future requirements

**In other words:**
- Structure is strict (layers, boundaries, dependencies)
- Implementation can be simple (until complexity justifies fancier patterns)

---

## Simple Design Principles

### Kent Beck's Four Rules of Simple Design

**1. Passes all tests**
- Code must work correctly
- Tests prove it works
- Non-negotiable

**2. Reveals intention**
- Code is clear and readable
- Names communicate purpose
- Easy to understand

**3. No duplication**
- Don't repeat yourself (DRY)
- Extract common patterns
- Reuse through composition

**4. Fewest elements**
- Minimal classes/methods/lines
- No speculative generality
- No unnecessary abstraction

**Priority order matters:** Tests first, clarity second, no duplication third, minimal fourth.

### Applied to OneSyntax

**Our version:**

**1. Passes tests AND maintains architectural boundaries**
- All tests pass
- No framework dependencies in domain
- Clean Architecture layers respected

**2. Reveals intention using Ubiquitous Language**
- Names match business concepts
- Domain language in code
- Clear to non-technical stakeholders

**3. No duplication AND no inappropriate coupling**
- DRY within bounded contexts
- Acceptable duplication across contexts
- Domain isolated from infrastructure

**4. Fewest elements within proper structure**
- Minimal complexity within layers
- But all layers present
- Structure exists, implementation simple

---

## When to Apply Full DDD

### Green Lights for Full DDD Patterns

**Use rich domain model with full DDD when:**

**Complex business rules:**
```php
// Business rule: Order total calculation depends on:
// - Base price
// - Customer tier discounts
// - Promotional codes
// - Tax rules by region
// - Bulk discounts
// - Payment method fees

// This complexity belongs in Order aggregate
class Order
{
    public function calculateTotal(): Money
    {
        $subtotal = $this->calculateSubtotal();
        $discount = $this->calculateDiscounts();
        $tax = $this->calculateTax($subtotal, $discount);
        $fees = $this->calculateFees();
        
        return $subtotal->subtract($discount)->add($tax)->add($fees);
    }
}
```

**Multiple invariants to protect:**
```php
// Invariants: 
// - Order must have at least one item
// - Order total must match sum of items
// - Order can only be modified before confirmation
// - Cancelled orders cannot be modified

// Rich entity protects these invariants
class Order
{
    public function addItem(OrderItem $item): void
    {
        if ($this->isConfirmed()) {
            throw new CannotModifyConfirmedOrder();
        }
        
        $this->items->add($item);
        $this->recalculateTotal();
    }
}
```

**Behavioral complexity:**
- State machines with many transitions
- Complex validation rules
- Multi-step workflows
- Domain events with side effects

**Multiple aggregates interacting:**
- Need for consistency boundaries
- Domain events for communication
- Aggregate roots protecting clusters
- Repository pattern for persistence

### Examples Requiring Full DDD

1. **E-commerce order processing** (complex pricing, inventory, payment)
2. **Booking systems** (availability, reservations, cancellations, conflicts)
3. **Financial transactions** (multi-step workflows, reconciliation, audit trails)
4. **Content management** (publishing workflows, versioning, permissions)
5. **SaaS subscription management** (plans, upgrades, billing cycles, trial periods)

---

## When Simpler Patterns Suffice

### Yellow Lights for Simple Patterns

**Start simple when:**

**CRUD with minimal logic:**
```php
// Simple case: User profile
// - Update name, email, bio
// - Basic validation only
// - No complex business rules

// Simpler pattern: Transaction Script + DTO
class UpdateUserProfile
{
    public function execute(UpdateUserProfileData $data): void
    {
        $user = $this->userRepository->findById($data->userId);
        
        $user->name = $data->name;
        $user->email = Email::fromString($data->email); // Value object still used
        $user->bio = $data->bio;
        
        $this->userRepository->save($user);
    }
}

// Entity can be simpler (but still in domain layer)
class User
{
    public string $name;
    public Email $email;
    public string $bio;
    
    // Minimal methods, more data than behavior
    // This is fine if business logic is genuinely simple
}
```

**Data-centric features:**
- Reporting and analytics
- Search functionality
- Data exports
- Read-only views

**Infrastructure concerns:**
- Logging
- Caching
- Email sending
- File storage

**Simple validations only:**
- Format checking
- Required fields
- Basic constraints
- No business rules

### Examples Where Simple Is Fine

1. **User authentication** (standard auth, no custom business rules)
2. **Basic CRUD** (tags, categories, settings)
3. **Simple notifications** (send email on event, no complex routing)
4. **Data display** (dashboards, reports)
5. **Configuration management** (feature flags, system settings)

---

## Refactoring Triggers

### When to Upgrade from Simple to Rich

**Watch for these signs:**

**1. Validation logic spreading**
```php
// Sign: Validation in multiple places
// Controller checks email format
// Service checks email uniqueness  
// Job checks email deliverability

// Solution: Move to Email value object in domain
class Email
{
    public static function fromString(string $email): self
    {
        self::validateFormat($email);
        return new self($email);
    }
}
```

**2. Business logic in application layer**
```php
// Sign: Application service has complex if/else
public function processOrder(Order $order): void
{
    if ($order->total > 1000 && $customer->isPremium()) {
        // Apply discount
    }
    
    if ($order->items->count() > 10) {
        // Bulk discount
    }
    
    // This logic belongs in Order entity
}

// Solution: Move to domain
class Order
{
    public function calculateDiscount(): Money
    {
        // Business logic here
    }
}
```

**3. Anemic entities with behavior elsewhere**
```php
// Sign: Entity is just data, logic everywhere else
class Order
{
    public $items;
    public $total;
    public $status;
}

class OrderService 
{
    public function calculateTotal(Order $order) { }
    public function canBeCancelled(Order $order) { }
    public function applyDiscount(Order $order) { }
}

// Solution: Make Order rich
class Order
{
    public function calculateTotal(): Money { }
    public function canBeCancelled(): bool { }
    public function applyDiscount(Discount $discount): void { }
}
```

**4. Increasing complexity**
- Adding second business rule
- Adding third validation
- State machine emerging
- Multiple status transitions

**5. Domain concepts emerging**
- New terminology appearing
- Business rules becoming explicit
- Workflows crystallizing
- Invariants being discussed

### Refactoring Path

**Phase 1: Extract Value Objects**
```php
// Before
$order->customerEmail = $request->email;

// After  
$order->customerEmail = Email::fromString($request->email);
```

**Phase 2: Move Behavior to Entity**
```php
// Before
if ($orderService->canBeCancelled($order)) {
    $orderService->cancel($order);
}

// After
if ($order->canBeCancelled()) {
    $order->cancel();
}
```

**Phase 3: Extract Aggregate**
```php
// Before: Order and OrderItems as separate tables/entities

// After: Order as aggregate root
class Order 
{
    private OrderItemCollection $items;
    
    public function addItem(Product $product, Quantity $quantity): void
    {
        // Maintains invariants
    }
}
```

**Phase 4: Add Domain Events**
```php
class Order
{
    public function confirm(): void
    {
        $this->status = OrderStatus::CONFIRMED;
        $this->recordEvent(new OrderConfirmed($this));
    }
}
```

---

## Decision Framework

### Start of New Feature

**Ask these questions:**

**Q1: Is the domain layer isolated?**
- No framework dependencies ✅
- In correct architectural layer ✅
- Repository for persistence ✅

**If no:** Fix architecture first, simplicity second.

**Q2: Are there complex business rules?**
- Multiple if/else statements?
- State machine?
- Calculated fields?
- Invariants to protect?

**If yes:** Use rich domain model from start.  
**If no:** Simple entity is fine.

**Q3: Will this grow in complexity?**
- Is this core domain?
- Will requirements expand?
- Multiple stakeholders?

**If yes:** Consider rich model upfront.  
**If no:** Simple implementation, refactor later.

**Q4: Do we understand the domain well?**
- Clear requirements?
- Stable concepts?
- Known patterns?

**If yes:** Can commit to pattern choice.  
**If no:** Start simple, learn, refactor.

### Decision Tree

```
New Feature
    │
    ▼
Is domain layer isolated?
    │
    ├─ No → Fix architecture first (non-negotiable)
    │
    └─ Yes
        │
        ▼
    Complex business rules?
        │
        ├─ Yes → Rich domain model
        │
        └─ No
            │
            ▼
        Will grow complex?
            │
            ├─ Likely → Rich domain model
            │
            └─ Unlikely
                │
                ▼
            Simple implementation
            (but within proper layers)
```

---

## YAGNI Exceptions

### When NOT to Follow YAGNI

**Build upfront (don't wait) for:**

**1. Architectural boundaries**
- Domain layer isolated
- Clean Architecture layers
- Repository pattern
- No framework in domain

**Why:** Refactoring across layers is expensive and error-prone.

**2. Security concerns**
- Authentication/authorization
- Data encryption
- Input validation
- SQL injection prevention

**Why:** Security bugs are expensive and dangerous.

**3. Data integrity**
- Database constraints
- Foreign keys
- Unique indexes
- Not null constraints

**Why:** Bad data is hard to fix later.

**4. Scalability bottlenecks**
- Database indexes on foreign keys
- Proper pagination
- Efficient queries

**Why:** Performance problems under load are hard to fix.

**5. Audit requirements**
- Who changed what when
- Soft deletes (if needed for compliance)
- Event logs

**Why:** Can't retroactively add audit trail.

### When to Follow YAGNI

**Don't build until needed:**

**1. Performance optimizations**
- Caching (unless proven bottleneck)
- Database denormalization
- Query optimization
- CDN setup

**Why:** Premature optimization. Measure first.

**2. Feature flexibility**
- "What if we need to support X in the future?"
- Configurable everything
- Plugin systems
- Extensibility hooks

**Why:** Requirements will change anyway. Build for today.

**3. Generalization**
- Building frameworks
- Supporting every edge case
- Configurable workflows
- Generic solutions

**Why:** Specific solutions simpler to maintain.

**4. Scale beyond current needs**
- Supporting millions of users (when you have 100)
- Microservices (when monolith works)
- Kafka (when background jobs suffice)
- Kubernetes (when single server works)

**Why:** Complexity without benefit.

---

## Examples

### Example 1: Simple → Rich Evolution

**Version 1 (Simple - Day 1):**
```php
// Simple user profile update
class User
{
    public string $name;
    public string $email;
}

class UpdateUserProfile
{
    public function execute(UserId $userId, string $name, string $email): void
    {
        $user = $this->userRepository->find($userId);
        $user->name = $name;
        $user->email = $email;
        $this->userRepository->save($user);
    }
}
```

**Version 2 (Adding Value Objects - Month 2):**
```php
// Email validation becoming important
class User
{
    public string $name;
    public Email $email; // Value object with validation
}

class UpdateUserProfile
{
    public function execute(UserId $userId, string $name, string $email): void
    {
        $user = $this->userRepository->find($userId);
        $user->name = $name;
        $user->email = Email::fromString($email); // Validation here
        $this->userRepository->save($user);
    }
}
```

**Version 3 (Rich Entity - Month 6):**
```php
// Complex rules emerging:
// - Email verification required
// - Name changes tracked
// - Profile completeness score

class User
{
    private PersonName $name;
    private Email $email;
    private EmailVerificationStatus $emailStatus;
    private ProfileCompleteness $completeness;
    
    public function updateEmail(Email $newEmail): void
    {
        if ($this->email->equals($newEmail)) {
            return; // No change
        }
        
        $this->email = $newEmail;
        $this->emailStatus = EmailVerificationStatus::pending();
        $this->recordEvent(new EmailChanged($this->id, $newEmail));
    }
    
    public function updateName(PersonName $newName): void
    {
        $this->name = $newName;
        $this->completeness = $this->calculateCompleteness();
    }
}
```

### Example 2: Staying Simple

**Feature: System Settings**

**V1 (Simple):**
```php
class Setting
{
    public string $key;
    public string $value;
}

class UpdateSetting
{
    public function execute(string $key, string $value): void
    {
        $setting = $this->settingRepository->findByKey($key);
        $setting->value = $value;
        $this->settingRepository->save($setting);
    }
}
```

**2 years later... still simple:**
```php
// No complex business rules emerged
// No need for rich domain model
// Simple CRUD suffices
// Still in domain layer, just simple implementation
```

**This is fine!** Not everything needs to be complex.

---

## Common Mistakes

### Mistake 1: Premature Complexity

**Problem:** Building complex domain model for simple CRUD.

**Example:**
```php
// Overkill for simple tag management
class Tag
{
    private TagName $name;
    private TagColor $color;
    private TagCategory $category;
    private TagUsageStatistics $statistics;
    // ... 500 lines of behavior for something that's just name + color
}
```

**Solution:** Start simpler.
```php
class Tag
{
    public string $name;
    public string $color;
}
```

### Mistake 2: Anemic Everywhere

**Problem:** No entities ever have behavior, everything in services.

**Example:**
```php
// Order is complex domain concept but entity is anemic
class Order
{
    public $items;
    public $total;
    public $status;
}

// All logic in services
class OrderCalculationService { }
class OrderValidationService { }
class OrderStatusService { }
```

**Solution:** Move behavior to entity when it's business logic.

### Mistake 3: Violating Boundaries for Simplicity

**Problem:** "It's simpler to just query the database directly from the controller."

**Example:**
```php
// WRONG - Skipping layers for "simplicity"
class OrderController
{
    public function show($id)
    {
        $order = DB::table('orders')->find($id); // Direct DB access
        return view('orders.show', compact('order'));
    }
}
```

**Solution:** Simplicity within layers, not by skipping layers.
```php
// RIGHT - Simple implementation, proper structure
class OrderController
{
    public function show($id)
    {
        $order = $this->orderRepository->find(OrderId::fromString($id));
        return view('orders.show', compact('order'));
    }
}
```

---

## Remember

**Simple design doesn't mean skipping architecture.**

It means:
- Start with simplest implementation **within proper structure**
- Add complexity only when business complexity demands it
- Refactor when patterns emerge
- Keep code clear and maintainable

**Architecture is not negotiable. Implementation complexity is.**

---

*Related: [Development System](development-system.md) | [DDD Checklist](ddd-checklist.md) | [Clean Architecture](clean-architecture-cheatsheet.md)*
