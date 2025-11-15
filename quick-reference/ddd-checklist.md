# DDD Quick Reference Checklist
**OneSyntax Domain-Driven Design - One-Page Guide**

Print this and keep it at your desk! ✅

---

## 🎯 Core Question
**"Does my code model the business correctly?"**

If not, it's wrong. Fix it.

---

## ✅ Entity Checklist

```typescript
class Order {
  // ✅ Has unique identity
  private readonly id: OrderId

  // ✅ Encapsulates business rules
  place(): void {
    if (!this.hasValidItems()) {
      throw new InvalidOrderError()
    }
    this.status = OrderStatus.Placed
  }

  // ✅ Protects invariants
  private hasValidItems(): boolean {
    return this.items.length > 0
  }
}
```

**Ask yourself:**
- [ ] Does it have unique identity?
- [ ] Are business rules inside the entity?
- [ ] Are invariants protected?
- [ ] Can it be created in invalid state? (Should be NO!)

---

## ✅ Value Object Checklist

```typescript
class Money {
  constructor(
    private readonly amount: number,
    private readonly currency: Currency
  ) {
    if (amount < 0) throw new Error()
  }

  // ✅ Immutable
  add(other: Money): Money {
    return new Money(
      this.amount + other.amount,
      this.currency
    )
  }

  // ✅ Equality by value
  equals(other: Money): boolean {
    return this.amount === other.amount &&
           this.currency === other.currency
  }
}
```

**Ask yourself:**
- [ ] Is it immutable?
- [ ] Does it validate on construction?
- [ ] Does it compare by value?
- [ ] Is it side-effect free?

---

## ✅ Aggregate Checklist

```typescript
class Order { // Aggregate Root
  private items: OrderItem[] // Internal entities

  // ✅ Single entry point
  addItem(item: OrderItem): void {
    this.validateItem(item)
    this.items.push(item)
  }

  // ✅ Enforces consistency
  private validateItem(item: OrderItem): void {
    if (this.status === OrderStatus.Shipped) {
      throw new Error("Cannot modify shipped order")
    }
  }
}
```

**Ask yourself:**
- [ ] Is there a clear aggregate root?
- [ ] Do all changes go through the root?
- [ ] Are boundaries well-defined?
- [ ] Is it the right size? (Not too big!)

---

## ✅ Use Case Checklist

```typescript
class PlaceOrderUseCase {
  execute(command: PlaceOrderCommand): void {
    // ✅ Load aggregate
    const order = this.orderRepo.find(command.orderId)

    // ✅ Execute business logic (in domain!)
    order.place()

    // ✅ Persist
    this.orderRepo.save(order)

    // ✅ Publish event
    this.eventBus.publish(new OrderPlacedEvent(order.id))
  }
}
```

**Ask yourself:**
- [ ] Is business logic in domain, not use case?
- [ ] Does it orchestrate, not implement?
- [ ] Is it thin and focused?
- [ ] Does it handle one use case?

---

## 🚫 Common Mistakes

### ❌ Anemic Domain Model
```typescript
// WRONG - Just data bags
class Order {
  public status: string
  public items: any[]
}

// Business logic in service
orderService.placeOrder(order) {
  order.status = "placed" // ❌ No validation!
}
```

### ✅ Rich Domain Model
```typescript
// RIGHT - Business logic inside
class Order {
  place(): void {
    this.validateCanBePlaced()
    this.status = OrderStatus.Placed
  }
}
```

---

### ❌ Breaking Encapsulation
```typescript
// WRONG - Exposing internals
order.items.push(newItem) // ❌ Bypasses validation!
```

### ✅ Proper Encapsulation
```typescript
// RIGHT - Through methods
order.addItem(newItem) // ✅ Validates!
```

---

### ❌ Wrong Aggregate Boundaries
```typescript
// WRONG - Too big!
class Customer {
  orders: Order[]        // ❌ Different lifecycle
  invoices: Invoice[]    // ❌ Different lifecycle
  payments: Payment[]    // ❌ Different lifecycle
}
```

### ✅ Right Aggregate Boundaries
```typescript
// RIGHT - Separate aggregates
class Customer {
  // Just customer data
}

class Order {
  customerId: CustomerId // ✅ Reference by ID
}
```

---

## 💭 Quick Decision Tree

**Q: Does it have an ID?**
- Yes → Entity or Aggregate Root
- No → Value Object

**Q: Does it need to change?**
- Yes → Entity
- No → Value Object

**Q: Can it exist independently?**
- Yes → Aggregate Root
- No → Part of another Aggregate

**Q: Where does business logic go?**
- Always in Domain (Entity/Value Object/Domain Service)
- Never in Use Case (orchestration only)
- Never in Controller (delegate to Use Case)

---

## 🎯 Before You Commit

- [ ] Business logic is in domain layer
- [ ] Entities enforce their own invariants
- [ ] Use cases are thin orchestrators
- [ ] Aggregates have clear boundaries
- [ ] Value objects are immutable
- [ ] Ubiquitous language is used
- [ ] No anemic models

---

## 📚 Need Help?

**Quick:** [Development System Guide](../2-standards/development-system.md)
**Deep:** [System Deep Dive](../reference/system-deep-dive.md)
**Ask:** #architecture channel

---

*Keep this checklist handy. Review before every PR.*

**Remember: DDD isn't academic - it's how we honor our clients' trust.**
