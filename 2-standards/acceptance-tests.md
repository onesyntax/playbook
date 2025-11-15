# Customer Tests / Acceptance Criteria
## Bridging Business Requirements and Technical Implementation

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Tests express business value, not just technical correctness

---

## Table of Contents

1. [What Are Customer Tests](#what-are-customer-tests)
2. [Acceptance Criteria Format](#acceptance-criteria-format)
3. [Who Writes Acceptance Tests](#who-writes-acceptance-tests)
4. [Acceptance Test Automation](#acceptance-test-automation)
5. [Linking to Unit Tests](#linking-to-unit-tests)
6. [Testing Workflows](#testing-workflows)

---

## What Are Customer Tests?

### Definition

**Customer tests** (aka acceptance tests) verify that a feature meets business requirements from the user's perspective.

**Different from unit tests:**
- **Unit tests:** Verify code works correctly (developer perspective)
- **Customer tests:** Verify feature solves user problem (business perspective)

**Example - Email Change Feature:**

**Unit test (developer perspective):**
```php
test('Email value object rejects invalid format')
{
    $this->expectException(InvalidEmailException::class);
    Email::fromString('invalid-email');
}
```

**Customer test (business perspective):**
```php
test('User can change their email address')
{
    // Given: User is logged in with old email
    $user = $this->loginAs('old@example.com');
    
    // When: User changes to new email and verifies it
    $this->visit('/settings/email')
         ->fillField('new_email', 'new@example.com')
         ->clickButton('Change Email')
         ->verifyEmail('new@example.com');
    
    // Then: User can log in with new email
    $this->logout();
    $this->login('new@example.com', 'password');
    $this->assertAuthenticated();
}
```

### Why Customer Tests Matter

**For OneSyntax mission:**
- Demonstrate true partnership (we built what client needs)
- Provide confidence (feature works end-to-end)
- Enable early validation (test on staging before production)
- Document behavior (what feature actually does)

**Benefits:**
- Catch integration issues unit tests miss
- Verify business rules in real context
- Provide regression protection
- Enable confident refactoring
- Serve as living documentation

---

## Acceptance Criteria Format

### Given-When-Then Format

**Structure:**
```
Given [initial context]
When [action occurs]
Then [expected outcome]
```

**Why this format:**
- Clear and unambiguous
- Easy for everyone to understand
- Maps naturally to tests
- Forces concrete scenarios

### Writing Good Acceptance Criteria

**Example - User Registration:**

**❌ Bad (vague):**
```
- User should be able to register
- System validates input
- Email sent
```

**✅ Good (concrete):**
```
Scenario: Successful registration
Given: I'm a new user on the registration page
When: I enter valid name, email, and password
Then: My account is created
And: I receive a verification email
And: I'm redirected to dashboard with welcome message

Scenario: Duplicate email
Given: An account exists with email "john@example.com"
When: I try to register with email "john@example.com"
Then: I see error "Email already registered"
And: No new account is created
And: No email is sent

Scenario: Invalid email format
Given: I'm on the registration page
When: I enter email "not-an-email"
Then: I see error "Invalid email format"
And: Submit button is disabled

Scenario: Weak password
Given: I'm on the registration page
When: I enter password "123"
Then: I see error "Password must be at least 8 characters"
And: I see password strength indicator
```

### Acceptance Criteria Checklist

**Good acceptance criteria:**
- [ ] Written in Given-When-Then format
- [ ] Describes behavior, not implementation
- [ ] Covers happy path
- [ ] Covers error cases
- [ ] Covers edge cases
- [ ] Uses business language (Ubiquitous Language)
- [ ] Concrete and testable
- [ ] Understandable by non-technical stakeholders

**Avoid:**
- Technical jargon ("validates email regex")
- Implementation details ("calls EmailValidator service")
- Vague language ("works correctly", "handles errors")

---

## Who Writes Acceptance Tests

### Collaborative Process

**During Three Amigos session:**
1. **PM** presents business requirement
2. **Developer** asks clarifying questions
3. **Together** write acceptance criteria
4. **Designer** adds UX considerations (if relevant)

**Result:** Acceptance criteria agreed by all three before implementation starts.

### Acceptance Criteria Owner: PM

**PM responsibilities:**
- Write initial draft of acceptance criteria
- Use business language
- Describe user goals
- Cover all scenarios
- Keep criteria updated as understanding evolves

**PM should NOT:**
- Write actual test code
- Specify technical implementation
- Make architectural decisions
- Skip developer input

### Acceptance Test Owner: Developer

**Developer responsibilities:**
- Implement automated acceptance tests
- Map acceptance criteria to test code
- Identify missing test scenarios
- Ensure tests pass before marking story done
- Maintain test suite

**Developer should NOT:**
- Change acceptance criteria without PM agreement
- Skip tests because "too hard"
- Write tests that don't match criteria
- Ignore edge cases

---

## Acceptance Test Automation

### Test Levels

**OneSyntax testing pyramid:**

```
         /\
        /  \  E2E Tests (Few)
       /----\
      /      \ Integration Tests (Some)
     /--------\
    /          \ Unit Tests (Many)
   /------------\
  /              \
```

**Acceptance tests typically at integration or E2E level.**

### Integration Test Level (Preferred)

**What:** Test feature with real infrastructure but isolated from UI.

**Example - Order Placement:**
```php
class PlaceOrderAcceptanceTest extends TestCase
{
    /** @test */
    public function customer_can_place_order_with_valid_payment()
    {
        // Given: Customer with items in cart
        $customer = Customer::factory()->create();
        $cart = $this->addItemsToCart($customer, [
            ['product_id' => 1, 'quantity' => 2],
            ['product_id' => 2, 'quantity' => 1]
        ]);
        
        // When: Customer places order with valid payment
        $paymentMethod = $this->createValidPaymentMethod($customer);
        
        $result = $this->placeOrderService->execute(
            new PlaceOrderCommand(
                customerId: $customer->id,
                cartId: $cart->id,
                paymentMethodId: $paymentMethod->id
            )
        );
        
        // Then: Order is created and confirmed
        $this->assertTrue($result->isSuccess());
        
        $order = Order::find($result->orderId);
        $this->assertEquals(OrderStatus::CONFIRMED, $order->status);
        
        // And: Payment is processed
        $this->assertDatabaseHas('payments', [
            'order_id' => $order->id,
            'status' => 'completed'
        ]);
        
        // And: Inventory is reserved
        $this->assertInventoryReserved($order);
        
        // And: Confirmation email sent
        $this->assertEmailSent($customer->email, 'Order Confirmation');
    }
    
    /** @test */
    public function order_fails_with_insufficient_inventory()
    {
        // Given: Product with limited stock
        $product = Product::factory()->create(['stock' => 1]);
        $customer = Customer::factory()->create();
        $cart = $this->addItemsToCart($customer, [
            ['product_id' => $product->id, 'quantity' => 5] // More than available
        ]);
        
        // When: Customer tries to place order
        $result = $this->placeOrderService->execute(
            new PlaceOrderCommand(
                customerId: $customer->id,
                cartId: $cart->id,
                paymentMethodId: $this->createValidPaymentMethod($customer)->id
            )
        );
        
        // Then: Order fails with clear error
        $this->assertFalse($result->isSuccess());
        $this->assertEquals('Insufficient inventory', $result->error);
        
        // And: No order created
        $this->assertDatabaseMissing('orders', [
            'customer_id' => $customer->id,
            'status' => 'confirmed'
        ]);
        
        // And: No payment charged
        $this->assertDatabaseMissing('payments', [
            'customer_id' => $customer->id,
            'status' => 'completed'
        ]);
    }
}
```

**Advantages:**
- Fast execution (no browser overhead)
- Reliable (no UI flakiness)
- Easier to maintain
- Tests business logic + integration

### End-to-End Test Level (Sparingly)

**What:** Test through actual UI with browser automation.

**When to use:**
- Critical user workflows
- UI-heavy features
- Testing multiple systems together
- Smoke tests after deployment

**Example - User Login (E2E):**
```php
class UserLoginE2ETest extends DuskTestCase
{
    /** @test */
    public function user_can_login_with_valid_credentials()
    {
        // Given: User exists with known credentials
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123')
        ]);
        
        // When: User navigates to login and enters credentials
        $this->browse(function (Browser $browser) {
            $browser->visit('/login')
                    ->type('email', 'test@example.com')
                    ->type('password', 'password123')
                    ->press('Log In')
                    ->waitForLocation('/dashboard');
                    
            // Then: User is authenticated and sees dashboard
            $browser->assertSee('Welcome back!')
                    ->assertAuthenticated();
        });
    }
}
```

**Disadvantages:**
- Slow (10-100x slower than integration tests)
- Flaky (timing issues, browser quirks)
- Expensive to maintain
- Hard to debug

**Rule of thumb:**
- 1-5 E2E tests per feature (critical paths only)
- 10-20 integration tests per feature
- 50-100 unit tests per feature

---

## Linking to Unit Tests

### How Acceptance Tests and Unit Tests Work Together

**Acceptance test:** Verifies entire feature works end-to-end  
**Unit tests:** Verify individual domain rules

**Example - Email Change Feature:**

**Acceptance test (integration level):**
```php
test('user can change email address')
{
    // Tests entire workflow
    // But doesn't test every edge case of email validation
}
```

**Unit tests (domain level):**
```php
test('email value object validates format')
test('email value object rejects empty string')
test('email value object rejects too long email')
test('email value object normalizes to lowercase')
test('email value object handles internationalized emails')

test('user aggregate rejects duplicate email')
test('user aggregate generates EmailChanged event')
test('user aggregate maintains email history')
```

### ZOMBIES for Unit Tests, Given-When-Then for Acceptance

**ZOMBIES approach (unit tests):**
- Zero case
- One case
- Many cases
- Boundaries
- Interfaces
- Exceptions
- Simple scenarios first

**Given-When-Then (acceptance tests):**
- Business scenarios
- Happy path + error cases
- User perspective
- End-to-end validation

**Both are necessary:**
- Unit tests catch domain logic bugs
- Acceptance tests catch integration bugs
- Together provide comprehensive coverage

---

## Testing Workflows

### Test-First Development

**For each user story:**

**1. Write acceptance criteria (Three Amigos)**
```
Given: User has old email "old@example.com"
When: User changes to "new@example.com" and verifies
Then: User can log in with new email
```

**2. Write failing acceptance test (Developer)**
```php
test('user can change email address')
{
    // Test fails because feature doesn't exist yet
}
```

**3. Write failing unit tests (Developer)**
```php
test('email value object validates format')
test('user can change email')
test('EmailChanged event is generated')
// All fail because code doesn't exist
```

**4. Implement feature following TDD**
- Write unit test
- Write code to pass test
- Refactor
- Repeat

**5. Verify acceptance test passes**
- Feature complete when acceptance test passes
- All unit tests also passing
- Feature ready for review

### Acceptance Test Maintenance

**Keep tests updated:**
- When requirements change, update acceptance criteria first
- Then update acceptance tests
- Then update implementation
- Never let tests and code drift

**Refactor tests:**
- Extract common setup into helpers
- Use test factories for data
- Keep tests readable
- Remove obsolete tests

**Test coverage:**
- Aim for 100% of acceptance criteria covered
- Not 100% code coverage (unit tests handle that)
- Every scenario in acceptance criteria has a test

---

## Template for Story with Acceptance Tests

```markdown
# User Story: [Title]

## Business Context
Why we're building this and what problem it solves.

## Acceptance Criteria

### Scenario 1: Happy Path
**Given:** [Initial state]
**When:** [Action taken]
**Then:** [Expected result]
**And:** [Additional outcomes]

### Scenario 2: Error Case
**Given:** [Initial state]
**When:** [Action that causes error]
**Then:** [Error handling]
**And:** [System remains stable]

### Scenario 3: Edge Case
[Repeat format]

## Definition of Done
- [ ] Acceptance criteria agreed in Three Amigos
- [ ] Acceptance tests written and passing
- [ ] Unit tests written and passing (ZOMBIES)
- [ ] Code review passed
- [ ] Deployed to staging
- [ ] Manual QA validated
- [ ] PM verified behavior matches acceptance criteria

## Technical Notes
- Domain concepts involved
- Architecture patterns needed
- Integration points

## Test Coverage
- Acceptance tests: [List test file names]
- Unit tests: [List test file names]
```

---

## Common Challenges

### Challenge 1: Acceptance Criteria Too Vague

**Problem:** "User should be able to update profile"

**Solution:** Force concrete scenarios
- What fields can be updated?
- What validation rules?
- What happens on error?
- What confirmation is shown?

**Use Three Amigos to drill down until criteria is concrete.**

### Challenge 2: Tests Too Slow

**Problem:** Acceptance test suite takes 30 minutes to run.

**Solution:**
- Move most tests to integration level (not E2E)
- Parallelize test execution
- Optimize database seeding
- Use in-memory databases for tests
- Only run E2E tests for critical paths

### Challenge 3: Tests Too Brittle

**Problem:** Tests break whenever UI changes.

**Solution:**
- Test behavior, not implementation
- Use stable identifiers (data-test-id attributes)
- Abstract UI interactions into helpers
- Focus on business logic, not HTML structure

### Challenge 4: PM Doesn't Know How to Write Tests

**Solution:**
- PM writes acceptance criteria (not tests)
- Developer implements test code
- PM validates test matches criteria
- Pair during Three Amigos to align

---

## Success Metrics

**Good acceptance testing when:**
- Every story has clear acceptance criteria
- Acceptance tests written before implementation
- 100% of acceptance criteria have tests
- Tests catch bugs before production
- Tests serve as documentation
- PM can understand test scenarios
- Developers confident refactoring

---

## Remember

**Acceptance tests bridge business and technical.**

They express user needs in code. They verify we built what was requested. They give everyone confidence the feature works. They're the contract between business requirements and technical implementation.

**If acceptance criteria isn't testable, it isn't clear enough.**

---

*Related: [Three Amigos](whole-team.md#three-amigos-sessions) | [Testing Standards](development-system.md#testing-standards) | [ZOMBIES](zombies-testing-checklist.md)*
