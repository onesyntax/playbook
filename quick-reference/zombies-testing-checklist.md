# ZOMBIES Testing Checklist
**One-page test-writing reference using the ZOMBIES approach**

---

## What is ZOMBIES?

**ZOMBIES is a systematic approach to writing tests incrementally.**

It helps you:
- Write tests from simple to complex
- Build confidence gradually
- Avoid overwhelming test scenarios
- Ensure comprehensive coverage

---

## The ZOMBIES Acronym

### Z - Zero
**Start with the simplest case**

- Empty collections
- Null values
- Zero quantities
- Default states

```typescript
it('should return empty array when no items exist', () => {
  const result = order.getItems();
  expect(result).toEqual([]);
});

it('should return zero when calculating total of empty order', () => {
  const total = order.calculateTotal();
  expect(total).toEqual(Money.zero());
});
```

**Why start here?** Forces you to handle edge cases first.

---

### O - One
**Test with a single element**

- One item in a collection
- Single valid input
- One simple operation

```typescript
it('should calculate total with one item', () => {
  order.addItem(product, 1);
  const total = order.calculateTotal();
  expect(total).toEqual(new Money(10, Currency.USD));
});

it('should contain one item after adding', () => {
  order.addItem(product, 1);
  expect(order.getItems().length).toBe(1);
});
```

**Why?** Simplest meaningful case. Builds on zero.

---

### M - Many (or More complex)
**Test with multiple elements**

- Multiple items
- Collections with various sizes
- Multiple operations in sequence

```typescript
it('should calculate total with multiple items', () => {
  order.addItem(productA, 2);
  order.addItem(productB, 3);
  const total = order.calculateTotal();
  expect(total).toEqual(new Money(50, Currency.USD));
});

it('should handle adding many different products', () => {
  order.addItem(productA, 1);
  order.addItem(productB, 1);
  order.addItem(productC, 1);
  expect(order.getItems().length).toBe(3);
});
```

**Why?** Real-world scenarios involve multiple elements.

---

### B - Boundaries
**Test edge cases and limits**

- Maximum/minimum values
- Just before/after a threshold
- Upper/lower bounds
- Transition points

```typescript
it('should reject negative quantity', () => {
  expect(() => order.addItem(product, -1))
    .toThrow('Quantity must be positive');
});

it('should handle maximum allowed quantity', () => {
  order.addItem(product, 999);
  expect(order.getItems()[0].quantity).toBe(999);
});

it('should reject quantity above maximum', () => {
  expect(() => order.addItem(product, 1000))
    .toThrow('Quantity exceeds maximum allowed');
});
```

**Why?** Bugs often lurk at boundaries.

---

### I - Interface definition
**Test the contract/interface**

- Public API behavior
- Method signatures
- Return types
- Interface compliance

```typescript
it('should implement OrderRepository interface', () => {
  const repo: OrderRepository = new PostgresOrderRepository(db);
  expect(repo.save).toBeDefined();
  expect(repo.findById).toBeDefined();
});

it('should return Promise<Order> from findById', async () => {
  const order = await repository.findById(orderId);
  expect(order).toBeInstanceOf(Order);
});
```

**Why?** Ensures contracts are honored.

---

### E - Exceptional behavior
**Test error conditions**

- Invalid inputs
- Business rule violations
- System errors
- Exception handling

```typescript
it('should throw EmptyOrderError when placing order without items', () => {
  const order = Order.create(customerId);
  expect(() => order.place()).toThrow(EmptyOrderError);
});

it('should throw CurrencyMismatchError when adding different currencies', () => {
  const usd = new Money(10, Currency.USD);
  const eur = new Money(10, Currency.EUR);
  expect(() => usd.add(eur)).toThrow(CurrencyMismatchError);
});

it('should handle database connection failure', async () => {
  jest.spyOn(db, 'query').mockRejectedValue(new Error('Connection lost'));
  await expect(repository.save(order))
    .rejects.toThrow('Connection lost');
});
```

**Why?** Systems must handle failures gracefully.

---

### S - Simple scenarios
**Keep tests simple and focused**

- One assertion per test (when possible)
- Clear test names
- Minimal setup
- Easy to understand

```typescript
// Good - Simple and focused
it('should change status to Placed when placing order', () => {
  order.place();
  expect(order.status).toBe(OrderStatus.Placed);
});

it('should emit OrderPlacedEvent when placing order', () => {
  order.place();
  expect(order.events()).toContainEvent(OrderPlacedEvent);
});

// Avoid - Too complex
it('should handle entire order lifecycle', () => {
  // Tests 10 different things in one test
  // Hard to debug when it fails
});
```

**Why?** Simple tests are maintainable tests.

---

## Applying ZOMBIES to TDD

### The Process

1. **Z** - Start with zero/empty case
2. **O** - Add one element test
3. **M** - Test with many elements
4. **B** - Test boundaries
5. **I** - Verify interface contracts
6. **E** - Test error conditions
7. **S** - Keep it all simple

### Example: Building OrderTotal Calculator

```typescript
// Z - Zero
describe('Order Total Calculation', () => {
  it('should return zero for empty order', () => {
    const order = Order.create(customerId);
    expect(order.calculateTotal()).toEqual(Money.zero());
  });

  // O - One
  it('should calculate total with one item', () => {
    order.addItem(new Product(Money.of(10)), 1);
    expect(order.calculateTotal()).toEqual(Money.of(10));
  });

  // M - Many
  it('should calculate total with multiple items', () => {
    order.addItem(new Product(Money.of(10)), 2);
    order.addItem(new Product(Money.of(5)), 3);
    expect(order.calculateTotal()).toEqual(Money.of(35));
  });

  // B - Boundaries
  it('should handle very large quantities', () => {
    order.addItem(new Product(Money.of(1)), 999999);
    expect(order.calculateTotal()).toEqual(Money.of(999999));
  });

  // I - Interface
  it('should return Money type', () => {
    const total = order.calculateTotal();
    expect(total).toBeInstanceOf(Money);
  });

  // E - Exceptions
  it('should throw when items have different currencies', () => {
    order.addItem(new Product(new Money(10, Currency.USD)), 1);
    order.addItem(new Product(new Money(10, Currency.EUR)), 1);
    expect(() => order.calculateTotal()).toThrow(CurrencyMismatchError);
  });

  // S - Simple
  // Each test above is simple and focused!
});
```

---

## ZOMBIES Checklist

Use this when writing tests:

- [ ] **Z** - Tested zero/empty case?
- [ ] **O** - Tested with one element?
- [ ] **M** - Tested with many elements?
- [ ] **B** - Tested boundary conditions?
- [ ] **I** - Verified interface contract?
- [ ] **E** - Tested error conditions?
- [ ] **S** - Kept tests simple and focused?

---

## When to Use ZOMBIES

### Perfect for:
- Domain model testing
- Algorithm implementation
- Collection operations
- Business rule validation

### Less applicable for:
- Integration tests (use as needed)
- E2E tests (too granular)
- Configuration tests

---

## Benefits

1. **Progressive complexity** - Start simple, add complexity gradually
2. **Better coverage** - Systematic approach catches edge cases
3. **Easier debugging** - Simple tests fail clearly
4. **Confidence** - Each step builds on previous success
5. **Maintainable** - Simple tests are easy to update

---

## Common Mistakes

### ❌ Don't skip Zero
```typescript
// BAD - Starting with complex case
it('should calculate total with multiple items and discounts', () => {
  // Too complex for first test
});
```

### ✅ Start with Zero
```typescript
// GOOD - Start simple
it('should return zero for empty order', () => {
  expect(order.calculateTotal()).toEqual(Money.zero());
});
```

### ❌ Don't combine steps
```typescript
// BAD - Testing many things at once
it('should handle zero, one, and many items', () => {
  // Testing multiple ZOMBIES steps in one test
});
```

### ✅ Keep steps separate
```typescript
// GOOD - One step per test
it('should return zero for empty order', () => { ... });
it('should calculate total with one item', () => { ... });
it('should calculate total with many items', () => { ... });
```

---

## Quick Reference

| Letter | What | Example |
|--------|------|---------|
| **Z** | Zero/Empty | `[]`, `null`, `0` |
| **O** | One | Single element |
| **M** | Many | Multiple elements |
| **B** | Boundaries | Min/max, edges |
| **I** | Interface | Contract compliance |
| **E** | Exceptions | Error cases |
| **S** | Simple | Keep focused |

---

## Integration with TDD

ZOMBIES works perfectly with Red-Green-Refactor:

1. **RED** - Write failing test (start at Z)
2. **GREEN** - Make it pass (simplest way)
3. **REFACTOR** - Improve design
4. **REPEAT** - Move to O, then M, etc.

---

## Related Resources

- [Development System Guide](../2-standards/development-system.md) - TDD practices
- [Code Review Checklist](code-review-checklist.md) - Testing requirements
- [DDD Checklist](ddd-checklist.md) - Domain testing patterns

---

## Remember

**Start simple. Build confidence. Add complexity gradually.**

ZOMBIES isn't a rigid rulebook - it's a guide. Use it to write better tests, incrementally.

---

*Print this. Reference it. Build great tests.*

**Quality isn't achieved once - it's practiced daily.**
