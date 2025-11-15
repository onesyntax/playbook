# Clean Architecture Quick Reference
**OneSyntax Clean Architecture - One-Page Cheatsheet**

Print this! Keep it visible! ✅

---

## 🎯 The Golden Rule

**Dependencies ALWAYS point inward:**

```
IO → Adapters → Use Cases → Domain
(Framework) → (Interface) → (Application) → (Business)
```

**Domain depends on NOTHING. Everything depends on Domain.**

---

## 📐 The Layers

### Layer 1: Domain (Entities) 🏰
**Pure business logic. No dependencies.**

```typescript
// ✅ What goes here
class Order {
  private items: OrderItem[]
  private status: OrderStatus

  place(): void {
    this.validateCanBePlaced()
    this.status = OrderStatus.Placed
  }

  private validateCanBePlaced(): void {
    if (this.items.length === 0) {
      throw new InvalidOrderError()
    }
  }
}

// Value Objects
class Money { ... }
class OrderId { ... }

// Domain Services (when logic doesn't belong to one entity)
class PricingService { ... }
```

**Ask:**
- [ ] Is this pure business logic?
- [ ] Could this run without any framework?
- [ ] Would a business person understand this?

**NEVER put here:**
- ❌ Database code
- ❌ HTTP/API code
- ❌ Framework classes
- ❌ External service calls

---

### Layer 2: Use Cases (Application) 🎯
**Orchestrate business logic. Coordinate domain objects.**

```typescript
class PlaceOrderUseCase {
  constructor(
    private orderRepo: OrderRepository,
    private eventBus: EventBus
  ) {}

  execute(command: PlaceOrderCommand): void {
    // 1. Load
    const order = this.orderRepo.find(command.orderId)

    // 2. Execute (business logic in domain!)
    order.place()

    // 3. Persist
    this.orderRepo.save(order)

    // 4. Notify
    this.eventBus.publish(new OrderPlacedEvent(order.id))
  }
}
```

**Ask:**
- [ ] Does it orchestrate, not implement?
- [ ] Is business logic delegated to domain?
- [ ] Is it thin (10-30 lines)?

**NEVER put here:**
- ❌ Business validation (goes in domain)
- ❌ Database queries (goes in repository)
- ❌ HTTP handling (goes in controller)
- ❌ Framework-specific code

---

### Layer 3: Adapters (Interface) 🔌
**Convert between external world and domain.**

```typescript
// Controllers (HTTP → Use Case)
class OrderController {
  async placeOrder(req: Request): Response {
    const command = this.toCommand(req.body)
    await this.placeOrderUseCase.execute(command)
    return Response.ok()
  }
}

// Presenters (Domain → HTTP)
class OrderPresenter {
  toJSON(order: Order): object {
    return {
      id: order.id.value,
      status: order.status.toString(),
      total: order.total.amount
    }
  }
}

// Repositories (Interface only!)
interface OrderRepository {
  find(id: OrderId): Order
  save(order: Order): void
}
```

**Ask:**
- [ ] Does it adapt/translate only?
- [ ] No business logic here?
- [ ] Thin conversion layer?

---

### Layer 4: IO (Frameworks & Drivers) 🚀
**Frameworks, databases, external services.**

```typescript
// Database implementation
class EloquentOrderRepository implements OrderRepository {
  find(id: OrderId): Order {
    const model = OrderModel.find(id.value)
    return this.toDomain(model)
  }

  save(order: Order): void {
    const model = this.toModel(order)
    model.save()
  }

  private toDomain(model: OrderModel): Order { ... }
  private toModel(order: Order): OrderModel { ... }
}

// External service
class StripePaymentGateway implements PaymentGateway {
  charge(amount: Money): void {
    this.stripe.charges.create({ ... })
  }
}
```

**This is where:**
- ✅ Framework code lives (Eloquent, Express, etc.)
- ✅ Database queries happen
- ✅ External APIs are called
- ✅ Infrastructure concerns live

---

## 🎨 Dependency Rule Visualization

```
┌─────────────────────────────────────┐
│         IO Layer                    │  ← Framework, DB, APIs
│  (OrderModel, StripeClient)         │
└──────────────┬──────────────────────┘
               │ depends on ↓
┌──────────────▼──────────────────────┐
│      Adapters Layer                 │  ← Controllers, Presenters
│  (OrderController, OrderPresenter)  │     Repository Interfaces
└──────────────┬──────────────────────┘
               │ depends on ↓
┌──────────────▼──────────────────────┐
│      Use Cases Layer                │  ← Application logic
│  (PlaceOrderUseCase)                │     Orchestration
└──────────────┬──────────────────────┘
               │ depends on ↓
┌──────────────▼──────────────────────┐
│       Domain Layer                  │  ← Pure business logic
│  (Order, OrderItem, Money)          │     NO dependencies!
└─────────────────────────────────────┘
```

**Rule:** Arrows ONLY point down. Never up!

---

## 🚫 Common Violations

### ❌ Domain Depending on Framework
```typescript
// WRONG - Domain importing framework
import { Model } from 'eloquent'

class Order extends Model { // ❌ NO!
  // Business logic
}
```

**Fix:**
```typescript
// RIGHT - Pure domain
class Order {
  // Pure business logic
}

// In IO layer:
class OrderModel extends Model {
  toDomain(): Order { ... }
}
```

---

### ❌ Use Case Doing Business Logic
```typescript
// WRONG
class PlaceOrderUseCase {
  execute(command) {
    // ❌ Validation in use case
    if (order.items.length === 0) {
      throw new Error()
    }
    // ❌ Calculation in use case
    const total = order.items.reduce(...)
  }
}
```

**Fix:**
```typescript
// RIGHT
class PlaceOrderUseCase {
  execute(command) {
    order.place() // ✅ Business logic in domain!
    this.repo.save(order)
  }
}
```

---

### ❌ Controller with Business Logic
```typescript
// WRONG
class OrderController {
  async placeOrder(req) {
    // ❌ Business logic in controller
    const total = this.calculateTotal(req.items)
    if (total < 0) throw new Error()

    await Order.create({ total }) // ❌ Direct DB access
  }
}
```

**Fix:**
```typescript
// RIGHT
class OrderController {
  async placeOrder(req) {
    const command = this.toCommand(req.body)
    await this.useCase.execute(command) // ✅ Delegate!
    return Response.ok()
  }
}
```

---

## 📁 File Structure Example

```
app/
├── Domain/                   # Layer 1
│   ├── Order/
│   │   ├── Order.ts          # Entity
│   │   ├── OrderItem.ts      # Entity
│   │   ├── OrderId.ts        # Value Object
│   │   └── OrderStatus.ts    # Value Object
│   └── Shared/
│       └── Money.ts          # Value Object
│
├── UseCases/                 # Layer 2
│   └── Order/
│       ├── PlaceOrderUseCase.ts
│       └── CancelOrderUseCase.ts
│
├── Adapters/                 # Layer 3
│   ├── Controllers/
│   │   └── OrderController.ts
│   ├── Presenters/
│   │   └── OrderPresenter.ts
│   └── Repositories/
│       └── OrderRepository.ts  # Interface only!
│
└── IO/                       # Layer 4
    ├── Database/
    │   └── EloquentOrderRepository.ts  # Implementation
    └── External/
        └── StripePaymentGateway.ts
```

---

## 🎯 Quick Decision Tree

**Q: Is this business logic?**
→ Yes: Domain layer
→ No: Continue...

**Q: Is this application workflow?**
→ Yes: Use Case layer
→ No: Continue...

**Q: Is this conversion/translation?**
→ Yes: Adapter layer
→ No: Continue...

**Q: Is this framework/infrastructure?**
→ Yes: IO layer

---

## ✅ Pre-Commit Checklist

Before you commit, verify:

- [ ] Domain has no imports from outer layers
- [ ] Use cases only import from domain
- [ ] Adapters define interfaces (impl in IO)
- [ ] IO layer implements interfaces from adapters
- [ ] Business logic is in domain (not use cases)
- [ ] Controllers are thin (just delegate)
- [ ] Dependencies point inward

---

## 🎯 The Test

**Can you:**
- [ ] Test domain without any framework?
- [ ] Swap databases without changing domain?
- [ ] Swap frameworks without changing use cases?
- [ ] Run use cases without HTTP?

**If yes to all → You got it! ✅**
**If no to any → Fix the architecture! 🔧**

---

## 📚 Need Help?

**Quick:** [Development System](../2-standards/development-system.md#clean-architecture)
**Deep:** [System Deep Dive](../reference/system-deep-dive.md)
**Examples:** [Architecture Guide](../reference/architecture-guide.md)
**Ask:** #architecture channel

---

## 💡 Remember

**Clean Architecture isn't about being "pure" or "academic".**

It's about:
- ✅ Making change easy
- ✅ Protecting business logic
- ✅ Enabling testing
- ✅ Honoring client investment

**Frameworks come and go. Business logic stays.**

---

*Keep this visible. Reference it daily. Master it.*

**"The center should not depend on the outside." - Uncle Bob**
