# Safe Refactorings Catalog
## 15 Micro-Tidyings You Can Do Anytime + What Needs Approval

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Based on Kent Beck's "Tidy First?" - small, safe, reversible improvements

---

## Table of Contents

1. [What Are Safe Refactorings](#what-are-safe-refactorings)
2. [The 15 Tidy First Patterns](#the-15-tidy-first-patterns)
3. [Unsafe Refactorings (Need Approval)](#unsafe-refactorings-need-approval)
4. [How to Apply Each Tidying](#how-to-apply-each-tidying)
5. [Testing Your Refactorings](#testing-your-refactorings)
6. [Common Combinations](#common-combinations)

---

## What Are Safe Refactorings

### Definition

**Safe refactoring:**
- Takes < 30 minutes
- Doesn't change behavior
- Easy to reverse if wrong
- Tests still pass
- Improves readability
- No approval needed

**Why these are safe:**
- Small scope (one file, one method)
- Obvious improvement
- Low risk
- Fast to do
- Fast to undo

### When to Use

**Before adding a feature:**
- Makes feature easier to add
- Clarifies where code goes
- Reduces cognitive load

**During code review:**
- Reviewer suggests tidying
- Quick improvement
- Separate commit from feature

**Anytime you touch code:**
- Boy Scout Rule: "Leave it cleaner than you found it"
- One small tidying per file you touch

---

## The 15 Tidy First Patterns

### 1. Guard Clauses

**What:** Replace nested if/else with early returns

**Before:**
```php
public function processOrder(Order $order): void
{
    if ($order->isPaid()) {
        if ($order->hasItems()) {
            if ($order->isShippable()) {
                // 20 lines of logic here
                $this->ship($order);
            } else {
                throw new NotShippableException();
            }
        } else {
            throw new EmptyOrderException();
        }
    } else {
        throw new UnpaidOrderException();
    }
}
```

**After:**
```php
public function processOrder(Order $order): void
{
    if (!$order->isPaid()) {
        throw new UnpaidOrderException();
    }
    
    if (!$order->hasItems()) {
        throw new EmptyOrderException();
    }
    
    if (!$order->isShippable()) {
        throw new NotShippableException();
    }
    
    // Happy path is now clear and at top level
    $this->ship($order);
}
```

**Why:** Reduces nesting, makes happy path clear, easier to read

**Time:** 5-10 minutes

---

### 2. Dead Code Removal

**What:** Delete commented-out code, unused methods, unreachable branches

**Before:**
```php
public function calculateTotal(Order $order): Money
{
    // Old calculation - don't use
    // $total = 0;
    // foreach ($order->items as $item) {
    //     $total += $item->price * $item->quantity;
    // }
    // return new Money($total);
    
    // New calculation
    return $order->items
        ->map(fn($item) => $item->subtotal())
        ->reduce(fn($sum, $amount) => $sum->add($amount), Money::zero());
}

// Old method - replaced by above
// public function oldCalculateTotal(Order $order): float
// {
//     // ...
// }
```

**After:**
```php
public function calculateTotal(Order $order): Money
{
    return $order->items
        ->map(fn($item) => $item->subtotal())
        ->reduce(fn($sum, $amount) => $sum->add($amount), Money::zero());
}
```

**Why:** Less noise, clearer intent, easier to navigate

**Time:** 2-5 minutes

---

### 3. Normalize Symmetries

**What:** Make similar code structures identical

**Before:**
```php
// Discount calculations inconsistent
public function applyMemberDiscount(Order $order): void
{
    $discount = $order->total()->multiply(0.1);
    $order->setTotal($order->getTotal()->subtract($discount));
}

public function applyBulkDiscount(Order $order): void
{
    $discountAmount = $order->total() * 0.15;
    $order->total = $order->total - $discountAmount;
}

public function applySeasonalDiscount(Order $order): void
{
    $newTotal = $order->getTotal()->subtract(
        $order->getTotal()->multiply(0.05)
    );
    $order->setTotal($newTotal);
}
```

**After:**
```php
// Consistent structure
public function applyMemberDiscount(Order $order): void
{
    $discount = $order->total()->multiply(0.1);
    $order->applyDiscount($discount);
}

public function applyBulkDiscount(Order $order): void
{
    $discount = $order->total()->multiply(0.15);
    $order->applyDiscount($discount);
}

public function applySeasonalDiscount(Order $order): void
{
    $discount = $order->total()->multiply(0.05);
    $order->applyDiscount($discount);
}
```

**Why:** Patterns emerge, easier to see duplications, sets up for extraction

**Time:** 10-15 minutes

---

### 4. New Interface, Old Implementation

**What:** Add better API alongside old one, migrate gradually

**Before:**
```php
class OrderService
{
    // Messy old API
    public function process($orderId, $userId, $paymentData, $shippingAddress)
    {
        // 200 lines of spaghetti
    }
}
```

**After:**
```php
class OrderService
{
    // New clean API
    public function processOrder(ProcessOrderCommand $command): OrderResult
    {
        // Call old implementation for now
        return $this->process(
            $command->orderId,
            $command->userId,
            $command->paymentData,
            $command->shippingAddress
        );
    }
    
    // Old API still works (backward compatible)
    public function process($orderId, $userId, $paymentData, $shippingAddress)
    {
        // 200 lines of spaghetti (unchanged)
    }
}
```

**Why:** Improve API without breaking existing code, migrate callers gradually

**Time:** 15-20 minutes

---

### 5. Reading Order

**What:** Reorder methods so reading top-to-bottom follows logic flow

**Before:**
```php
class OrderProcessor
{
    private function notifyCustomer() { }
    
    public function process(Order $order) 
    {
        $this->validate($order);
        $this->charge($order);
        $this->fulfill($order);
        $this->notifyCustomer($order);
    }
    
    private function charge() { }
    private function validate() { }
    private function fulfill() { }
}
```

**After:**
```php
class OrderProcessor
{
    // Read top-to-bottom matches execution order
    public function process(Order $order) 
    {
        $this->validate($order);
        $this->charge($order);
        $this->fulfill($order);
        $this->notifyCustomer($order);
    }
    
    private function validate() { }
    private function charge() { }
    private function fulfill() { }
    private function notifyCustomer() { }
}
```

**Why:** Easier to read, follows mental model, natural flow

**Time:** 5 minutes

---

### 6. Cohesion Order

**What:** Group related code together

**Before:**
```php
class OrderService
{
    public function calculateTotal() { }
    public function sendEmail() { }
    public function applyDiscount() { }
    public function validateAddress() { }
    public function calculateTax() { }
    public function trackShipment() { }
}
```

**After:**
```php
class OrderService
{
    // Financial calculations grouped
    public function calculateTotal() { }
    public function applyDiscount() { }
    public function calculateTax() { }
    
    // Communication grouped
    public function sendEmail() { }
    public function trackShipment() { }
    
    // Validation grouped
    public function validateAddress() { }
}
```

**Why:** Related code together, easier to find things, sets up for extraction

**Time:** 10 minutes

---

### 7. Explanatory Variables

**What:** Extract complex expressions to named variables

**Before:**
```php
if ($order->items()->sum(fn($i) => $i->price * $i->quantity) > 1000 
    && $customer->orders()->count() > 10 
    && $customer->createdAt->diffInMonths(now()) > 12) {
    // Apply discount
}
```

**After:**
```php
$orderTotal = $order->items()->sum(fn($i) => $i->price * $i->quantity);
$totalOrders = $customer->orders()->count();
$customerAgeInMonths = $customer->createdAt->diffInMonths(now());

$isHighValueOrder = $orderTotal > 1000;
$isFrequentCustomer = $totalOrders > 10;
$isLongTermCustomer = $customerAgeInMonths > 12;

if ($isHighValueOrder && $isFrequentCustomer && $isLongTermCustomer) {
    // Apply discount
}
```

**Why:** Self-documenting, easier to debug, reveals business concepts

**Time:** 5-10 minutes

---

### 8. Chunk Statements

**What:** Group related statements with blank lines

**Before:**
```php
public function processPayment(Order $order): void
{
    $amount = $order->total();
    $paymentMethod = $order->paymentMethod();
    $gateway = $this->getGateway($paymentMethod);
    $result = $gateway->charge($amount);
    if ($result->isSuccess()) {
        $order->markAsPaid();
        $this->fulfillmentService->queue($order);
        $this->notificationService->send($order->customer(), 'payment_received');
        Log::info('Payment processed', ['order_id' => $order->id]);
    }
}
```

**After:**
```php
public function processPayment(Order $order): void
{
    // Prepare payment
    $amount = $order->total();
    $paymentMethod = $order->paymentMethod();
    $gateway = $this->getGateway($paymentMethod);
    
    // Process charge
    $result = $gateway->charge($amount);
    
    // Handle success
    if ($result->isSuccess()) {
        $order->markAsPaid();
        
        $this->fulfillmentService->queue($order);
        
        $this->notificationService->send($order->customer(), 'payment_received');
        Log::info('Payment processed', ['order_id' => $order->id]);
    }
}
```

**Why:** Visual structure, easier to scan, logical grouping

**Time:** 2-5 minutes

---

### 9. Extract Helper

**What:** Extract repeated code to helper method

**Before:**
```php
public function calculateMemberDiscount(Order $order): Money
{
    return $order->total()->multiply(0.10);
}

public function calculateBulkDiscount(Order $order): Money
{
    return $order->total()->multiply(0.15);
}

public function calculateSeasonalDiscount(Order $order): Money
{
    return $order->total()->multiply(0.05);
}
```

**After:**
```php
public function calculateMemberDiscount(Order $order): Money
{
    return $this->percentageOf($order->total(), 10);
}

public function calculateBulkDiscount(Order $order): Money
{
    return $this->percentageOf($order->total(), 15);
}

public function calculateSeasonalDiscount(Order $order): Money
{
    return $this->percentageOf($order->total(), 5);
}

private function percentageOf(Money $amount, int $percentage): Money
{
    return $amount->multiply($percentage / 100);
}
```

**Why:** DRY, clearer intent, single source of truth

**Time:** 10 minutes

---

### 10. One Pile

**What:** Collect scattered code into one place

**Before:**
```php
// UserController.php
public function update() {
    $email = request('email');
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new InvalidEmailException();
    }
}

// RegistrationController.php
public function register() {
    $email = request('email');
    if (!preg_match('/^[^@]+@[^@]+$/', $email)) {
        throw new InvalidEmailException();
    }
}

// ProfileService.php
public function changeEmail($email) {
    if (strpos($email, '@') === false) {
        throw new InvalidEmailException();
    }
}
```

**After:**
```php
// EmailValidator.php (one pile)
class EmailValidator
{
    public static function validate(string $email): bool
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }
}

// Controllers use the one pile
public function update() {
    $email = request('email');
    if (!EmailValidator::validate($email)) {
        throw new InvalidEmailException();
    }
}
```

**Why:** Consolidate before you can see patterns, prepare for extraction

**Time:** 15-20 minutes

---

### 11. Explaining Comments

**What:** Add comments explaining WHY, not WHAT

**Before:**
```php
public function calculateDiscount(Order $order): Money
{
    if ($order->items()->count() > 10) {
        return $order->total()->multiply(0.15);
    }
    return Money::zero();
}
```

**After:**
```php
public function calculateDiscount(Order $order): Money
{
    // Business rule: Orders with 10+ items get 15% bulk discount
    // to encourage larger purchases (see pricing strategy doc)
    if ($order->items()->count() > 10) {
        return $order->total()->multiply(0.15);
    }
    
    return Money::zero();
}
```

**Why:** Preserves context, explains decisions, helps future maintainers

**Time:** 2-5 minutes

---

### 12. Delete Redundant Comments

**What:** Remove comments that just repeat the code

**Before:**
```php
// Get the user by ID
$user = $this->userRepository->findById($id);

// Check if user is null
if ($user === null) {
    // Throw exception
    throw new UserNotFoundException();
}

// Return the user
return $user;
```

**After:**
```php
$user = $this->userRepository->findById($id);

if ($user === null) {
    throw new UserNotFoundException();
}

return $user;
```

**Why:** Less noise, code is already clear, comments add no value

**Time:** 2-3 minutes

---

### 13. Separate Tidying (Behavior vs Structure)

**What:** Commit tidying separately from behavior changes

**Before (one big commit):**
```
feat: Add bulk discount + refactor order service

- Added bulk discount calculation
- Renamed variables
- Extracted methods
- Fixed formatting
- Updated tests
- Added new discount rule
```

**After (two commits):**
```
Commit 1: refactor: Extract discount calculation helpers
- Renamed $x to $orderTotal
- Extracted percentageOf() helper
- Grouped discount methods together
- No behavior change

Commit 2: feat: Add bulk discount
- Added calculateBulkDiscount() method
- Added test for 15% discount on 10+ items
- Updated OrderService to apply bulk discount
```

**Why:** Easier to review, easier to revert, clearer history

**Time:** Just discipline (same work, better commits)

---

### 14. Chaining Tidyings

**What:** One tidying often enables another

**Sequence:**
```
1. Delete dead code
   └─> Reveals duplication
   
2. Normalize symmetries
   └─> Makes pattern obvious
   
3. Extract helper
   └─> Creates abstraction
   
4. Extract to domain
   └─> Proper architecture
```

**Example:**
```php
// Step 1: Delete commented code (see pattern)
// Step 2: Normalize discount methods (same structure)
// Step 3: Extract percentageOf helper (reuse)
// Step 4: Extract Discount value object (domain concept)
```

**Why:** Refactorings build on each other, cumulative improvement

**Time:** 30-60 minutes (but done as sequence of small steps)

---

### 15. Rhythm

**What:** Establish cycle: tidy → feature → tidy → feature

**Cadence:**
```
Morning:
- Review code you'll change (10 min)
- Quick tidying (20 min)
- Commit tidying
- Add feature (2 hours)
- Quick tidying (20 min)
- Commit feature
- Commit tidying

Afternoon:
- Repeat rhythm
```

**Why:** Regular small improvements, never big refactoring project

**Time:** Bake it into workflow

---

## Unsafe Refactorings (Need Approval)

### Requires Senior Developer Approval

**Structural changes:**
- Moving code between domain layers
- Creating new aggregates
- Changing aggregate boundaries
- Splitting/merging bounded contexts
- Adding new architectural patterns

**Example:**
```php
// Need approval:
// - Moving OrderService logic to Order aggregate (changes architecture)
// - Extracting Email value object (new pattern)
// - Splitting OrderService into two services (structural)
```

**Why need approval:**
- Affects team patterns
- Sets precedent
- Risk of wrong abstraction
- Needs architectural review

**Estimated time:** 2-4 hours

---

### Requires Kalpa Approval

**Large-scale refactoring:**
- Multi-file refactoring (> 5 files)
- Database schema changes
- API breaking changes
- Anything > 4 hours estimated

**Example:**
```php
// Need Kalpa approval:
// - Refactoring entire order domain (3 days)
// - Changing database schema for orders table
// - Breaking payment API for v2
```

**Why need approval:**
- High risk
- Affects clients/contracts
- Significant time investment
- Strategic decision

**Estimated time:** > 4 hours

---

## How to Apply Each Tidying

### General Process

**1. Make sure tests exist**
- If no tests, add characterization tests first
- Tests protect your refactoring

**2. Make one small change**
- One tidying at a time
- Run tests after each change

**3. Commit separately**
- Separate commit for tidying
- Separate commit for feature

**4. Review the diff**
- Does it look cleaner?
- Is intent clearer?
- Would you want to work in this code?

### Step-by-Step: Guard Clauses

**Step 1: Identify nested conditions**
```php
if ($condition1) {
    if ($condition2) {
        if ($condition3) {
            // Happy path buried here
        }
    }
}
```

**Step 2: Invert first condition**
```php
if (!$condition1) {
    return; // or throw
}

if ($condition2) {
    if ($condition3) {
        // Happy path still nested
    }
}
```

**Step 3: Run tests (should pass)**

**Step 4: Invert second condition**
```php
if (!$condition1) {
    return;
}

if (!$condition2) {
    return;
}

if ($condition3) {
    // Happy path less nested
}
```

**Step 5: Run tests (should pass)**

**Step 6: Invert last condition**
```php
if (!$condition1) {
    return;
}

if (!$condition2) {
    return;
}

if (!$condition3) {
    return;
}

// Happy path at top level
```

**Step 7: Run tests (should pass)**

**Step 8: Commit**
```
refactor: Convert nested conditions to guard clauses in processOrder
```

---

## Testing Your Refactorings

### The Golden Rule

> **If tests pass before and after, refactoring is safe.**

### What If No Tests Exist?

**Option 1: Add tests first**
```php
// 1. Add characterization tests (capture current behavior)
test('order total includes item prices')
test('order total includes tax')
test('order total includes shipping')

// 2. Refactor safely
// 3. Tests still pass → refactoring safe
```

**Option 2: Don't refactor**
```php
// Too risky without tests
// Create tech debt ticket: "Add tests to OrderService"
// Refactor after tests added
```

### Test Checklist After Refactoring

- [ ] All existing tests pass
- [ ] No new test failures
- [ ] Code coverage didn't decrease
- [ ] Behavior is identical
- [ ] Performance not significantly worse

---

## Common Combinations

### Combination 1: Clean Up Method

**Sequence:**
1. Delete dead code (tidying #2)
2. Add guard clauses (tidying #1)
3. Chunk statements (tidying #8)
4. Explanatory variables (tidying #7)
5. Extract helper (tidying #9)

**Result:** Method goes from 100 lines of spaghetti to 30 lines of clear intent

---

### Combination 2: Prepare for Feature

**Sequence:**
1. One pile - collect scattered logic (tidying #10)
2. Normalize symmetries - make consistent (tidying #3)
3. Extract helper - remove duplication (tidying #9)
4. Add feature to clean structure

**Result:** Feature added to clean code, not bolted onto mess

---

### Combination 3: Fix Bug & Leave Better

**Sequence:**
1. Add explaining comment - document bug cause (tidying #11)
2. Extract helper - isolate buggy logic (tidying #9)
3. Fix bug in isolated helper
4. Add test for bug
5. Delete redundant comments (tidying #12)

**Result:** Bug fixed, code cleaner, protected by test

---

## Remember

**These 15 tidyings are always safe:**
- Small scope
- Quick to do
- Easy to undo
- Tests protect you
- No approval needed

**Do them liberally:**
- Before adding features
- During code review
- Whenever you touch code
- As part of your rhythm

**The goal:** Continuous improvement through tiny steps

---

*Related: [Refactoring Decisions](refactoring-decisions.md) | [Technical Debt Management](technical-debt-management.md) | [Collective Ownership](collective-ownership.md)*
