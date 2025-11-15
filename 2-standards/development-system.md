# OneSyntax Development System
**Domain-Driven Design + Clean Architecture + Test-Driven Development**

Version: 1.0  
Last Updated: November 2025

---

## Overview

At OneSyntax, we follow a proven development system that ensures:
- ✅ Software models the business correctly
- ✅ Systems remain maintainable for years
- ✅ Quality is built in from day one
- ✅ Changes are safe and predictable

**Our system combines three proven approaches:**

1. **Domain-Driven Design (DDD)** - Model the business correctly
2. **Clean Architecture** - Keep the system maintainable
3. **Test-Driven Development (TDD)** - Build quality in

**These aren't optional. They're how OneSyntax works.**

> **💡 Want to understand WHY these specific practices?**
> See [Why These Practices? First Principles Reasoning](why-these-practices.md) for the complete justification from trust problems to technical solutions.

---

## Part 1: Domain-Driven Design (DDD)

### Why DDD?

**Partnership requires understanding.**

If we don't model the client's business correctly, we can't be true partners. DDD forces us to:
- Deeply understand the business domain
- Use the same language as domain experts
- Model complex business rules explicitly
- Protect business invariants

### Core DDD Concepts

#### 1. Ubiquitous Language

**Everyone uses the same terms.**

✅ Good:
```typescript
// Domain expert says "Order" - we say "Order"
class Order {
  place(): void
  cancel(): void
  ship(): void
}
```

❌ Bad:
```typescript
// Domain expert says "Order" - we say "Transaction"  
class Transaction {
  create(): void  // They say "place"
  delete(): void  // They say "cancel"
}
```

**Rule:** If the domain expert wouldn't say it, don't code it.

#### 2. Rich Domain Models

**Business logic lives in the domain, not in services.**

✅ Good:
```typescript
class Order {
  private status: OrderStatus;
  private items: OrderItem[];
  private totalAmount: Money;

  place(): void {
    if (this.items.length === 0) {
      throw new Error("Cannot place order without items");
    }
    if (this.status !== OrderStatus.Draft) {
      throw new Error("Order already placed");
    }
    this.status = OrderStatus.Placed;
    this.emit(new OrderPlacedEvent(this.id));
  }

  addItem(product: Product, quantity: number): void {
    if (quantity <= 0) {
      throw new Error("Quantity must be positive");
    }
    const item = new OrderItem(product, quantity);
    this.items.push(item);
    this.recalculateTotal();
  }

  private recalculateTotal(): void {
    this.totalAmount = this.items
      .reduce((sum, item) => sum.add(item.subtotal()), Money.zero());
  }
}
```

❌ Bad:
```typescript
// Anemic domain model - just getters/setters
class Order {
  status: string;
  items: any[];
  total: number;
}

// Business logic in services
class OrderService {
  placeOrder(order: Order): void {
    if (order.items.length === 0) {
      throw new Error("Cannot place order");
    }
    order.status = "placed";
    // Logic scattered everywhere
  }
}
```

**Rule:** If it's a business rule, it belongs in the domain model.

#### 3. Entities vs Value Objects

**Entities have identity. Value Objects don't.**

✅ Entities (things with unique identity):
```typescript
class Customer {
  constructor(
    private readonly id: CustomerId,  // Identity
    private name: string,
    private email: Email
  ) {}

  // Two customers with same data but different IDs are DIFFERENT
}
```

✅ Value Objects (defined by their attributes):
```typescript
class Money {
  constructor(
    private readonly amount: number,
    private readonly currency: Currency
  ) {}

  add(other: Money): Money {
    if (!this.currency.equals(other.currency)) {
      throw new Error("Cannot add different currencies");
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  // Two Money objects with $10 USD are THE SAME
}
```

**Rule:** Use entities for things with lifecycle and identity. Use value objects for measurements and descriptions.

#### 4. Aggregates

**Aggregates enforce consistency boundaries.**

✅ Good:
```typescript
// Order is the aggregate root
class Order {
  private items: OrderItem[] = [];  // Owned by aggregate

  addItem(product: Product, quantity: number): void {
    // Order controls its items
    const item = new OrderItem(product, quantity);
    this.items.push(item);
    this.recalculateTotal();
  }

  removeItem(itemId: OrderItemId): void {
    // Order enforces invariants
    this.items = this.items.filter(i => !i.id.equals(itemId));
    this.recalculateTotal();
  }
}

// Repository works with aggregate root only
interface OrderRepository {
  save(order: Order): Promise<void>;
  findById(id: OrderId): Promise<Order>;
}
```

❌ Bad:
```typescript
// Items modified outside aggregate
class OrderItemRepository {
  save(item: OrderItem): Promise<void>;  // Violates aggregate boundary
}

// Direct modification bypasses business rules
orderItem.quantity = -5;  // Should be impossible!
await orderItemRepository.save(orderItem);
```

**Rule:** Only modify aggregates through their root. Never expose internal entities.

#### 5. Domain Events

**Important business moments are modeled explicitly.**

✅ Good:
```typescript
class Order {
  place(): void {
    // ... validation and state change
    this.status = OrderStatus.Placed;
    this.emit(new OrderPlacedEvent(
      this.id,
      this.customerId,
      this.totalAmount,
      occurredAt: new Date()
    ));
  }
}

// Event handlers react to domain events
class SendOrderConfirmationEmail {
  handle(event: OrderPlacedEvent): void {
    const email = this.buildConfirmationEmail(event);
    this.emailService.send(email);
  }
}
```

**Rule:** Model important business moments as events. Use events to decouple systems.

### Bounded Contexts

**Different parts of business have different models.**

Example in E-commerce:

```
[Sales Context]
- Order (with payment, shipping)
- Customer (with billing info)

[Inventory Context]  
- Product (with stock levels)
- Warehouse (with locations)

[Shipping Context]
- Shipment (with tracking)
- Delivery (with routes)
```

**Rule:** Don't try to create one model for everything. Separate contexts have separate models.

---

## Part 2: Clean Architecture

### Why Clean Architecture?

**Trust requires reliability.**

Clients trust us with their business. If our software becomes unmaintainable after 6 months, we've broken that trust. Clean Architecture ensures:
- Business logic doesn't depend on frameworks
- We can swap databases without changing business rules
- We can test business logic without infrastructure
- Changes are isolated and safe

### The Layers

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  (API, Web, CLI)
├─────────────────────────────────────┤
│        Application Layer            │  (Use Cases)
├─────────────────────────────────────┤
│          Domain Layer               │  (Business Logic)
├─────────────────────────────────────┤
│       Infrastructure Layer          │  (DB, External APIs)
└─────────────────────────────────────┘
```

**Dependency Rule:** Inner layers NEVER depend on outer layers.

#### Layer 1: Domain Layer (Core)

**Pure business logic. No dependencies.**

```typescript
// domain/entities/Order.ts
export class Order {
  private constructor(
    private readonly id: OrderId,
    private status: OrderStatus,
    private items: OrderItem[],
    private totalAmount: Money
  ) {}

  static create(customerId: CustomerId): Order {
    return new Order(
      OrderId.generate(),
      OrderStatus.Draft,
      [],
      Money.zero()
    );
  }

  place(): void {
    if (this.items.length === 0) {
      throw new EmptyOrderError();
    }
    this.status = OrderStatus.Placed;
  }
}
```

**No framework imports. No database code. Just business logic.**

#### Layer 2: Application Layer (Use Cases)

**Orchestrates domain objects to fulfill use cases.**

```typescript
// application/usecases/PlaceOrder.ts
export class PlaceOrderUseCase {
  constructor(
    private orderRepository: OrderRepository,  // Interface
    private eventPublisher: EventPublisher     // Interface
  ) {}

  async execute(command: PlaceOrderCommand): Promise<void> {
    // 1. Load aggregate
    const order = await this.orderRepository.findById(command.orderId);

    // 2. Execute business logic
    order.place();

    // 3. Persist
    await this.orderRepository.save(order);

    // 4. Publish events
    await this.eventPublisher.publish(order.events());
  }
}
```

**Orchestration only. No business rules. No infrastructure details.**

#### Layer 3: Infrastructure Layer

**Implements interfaces defined by inner layers.**

```typescript
// infrastructure/persistence/PostgresOrderRepository.ts
export class PostgresOrderRepository implements OrderRepository {
  constructor(private db: PostgresClient) {}

  async save(order: Order): Promise<void> {
    const data = OrderMapper.toPersistence(order);
    await this.db.query(
      'INSERT INTO orders ... VALUES ...',
      data
    );
  }

  async findById(id: OrderId): Promise<Order> {
    const row = await this.db.query(
      'SELECT * FROM orders WHERE id = $1',
      [id.value]
    );
    return OrderMapper.toDomain(row);
  }
}
```

**Database-specific. Implements domain interfaces.**

#### Layer 4: Presentation Layer

**Handles HTTP, validation, serialization.**

```typescript
// presentation/http/controllers/OrderController.ts
export class OrderController {
  constructor(private placeOrder: PlaceOrderUseCase) {}

  async placeOrder(req: Request, res: Response): Promise<void> {
    const command = new PlaceOrderCommand(req.body.orderId);
    
    try {
      await this.placeOrder.execute(command);
      res.status(200).json({ success: true });
    } catch (error) {
      if (error instanceof EmptyOrderError) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Internal error' });
      }
    }
  }
}
```

**HTTP-specific. Delegates to use cases.**

### Dependency Injection

**Outer layers construct inner layers.**

```typescript
// infrastructure/di/container.ts
export function buildContainer(): Container {
  const container = new Container();

  // Infrastructure
  container.register('Database', () => new PostgresClient(config));
  container.register('EventBus', () => new RabbitMQEventBus(config));

  // Repositories (infrastructure implements domain interfaces)
  container.register('OrderRepository', (c) => 
    new PostgresOrderRepository(c.resolve('Database'))
  );

  // Use Cases (application layer)
  container.register('PlaceOrderUseCase', (c) =>
    new PlaceOrderUseCase(
      c.resolve('OrderRepository'),
      c.resolve('EventBus')
    )
  );

  // Controllers (presentation layer)
  container.register('OrderController', (c) =>
    new OrderController(c.resolve('PlaceOrderUseCase'))
  );

  return container;
}
```

---

## Part 3: Test-Driven Development (TDD)

### Why TDD?

**Quality is built in, not tested in.**

TDD ensures:
- We think through behavior before coding
- Every line of code is tested
- Refactoring is safe
- Design emerges naturally

### The TDD Cycle

```
1. RED   - Write failing test
2. GREEN - Make it pass (simplest way)
3. REFACTOR - Improve design
```

### Example: TDD for Domain Model

#### Step 1: RED (Write failing test)

```typescript
// domain/entities/Order.spec.ts
describe('Order', () => {
  it('should not allow placing empty order', () => {
    const order = Order.create(customerId);
    
    expect(() => order.place()).toThrow(EmptyOrderError);
  });
});
```

**Test fails - Order.place() doesn't exist yet.**

#### Step 2: GREEN (Make it pass)

```typescript
// domain/entities/Order.ts
export class Order {
  place(): void {
    if (this.items.length === 0) {
      throw new EmptyOrderError();
    }
    this.status = OrderStatus.Placed;
  }
}
```

**Test passes.**

#### Step 3: REFACTOR (Improve design)

```typescript
// Extract validation to guard clause
export class Order {
  place(): void {
    this.guardAgainstEmptyOrder();
    this.status = OrderStatus.Placed;
  }

  private guardAgainstEmptyOrder(): void {
    if (this.items.length === 0) {
      throw new EmptyOrderError();
    }
  }
}
```

**Tests still pass. Design is better.**

### Testing Strategy

**Different layers need different tests:**

#### 1. Domain Tests (Unit Tests)
```typescript
// Fast, no dependencies
describe('Money', () => {
  it('should add same currency', () => {
    const a = new Money(10, Currency.USD);
    const b = new Money(5, Currency.USD);
    
    expect(a.add(b)).toEqual(new Money(15, Currency.USD));
  });

  it('should reject adding different currencies', () => {
    const a = new Money(10, Currency.USD);
    const b = new Money(5, Currency.EUR);
    
    expect(() => a.add(b)).toThrow(CurrencyMismatchError);
  });
});
```

#### 2. Application Tests (Integration Tests)
```typescript
// Test use cases with in-memory implementations
describe('PlaceOrderUseCase', () => {
  it('should place order and publish event', async () => {
    const repository = new InMemoryOrderRepository();
    const eventBus = new InMemoryEventBus();
    const useCase = new PlaceOrderUseCase(repository, eventBus);

    const order = Order.create(customerId);
    order.addItem(product, 1);
    await repository.save(order);

    await useCase.execute(new PlaceOrderCommand(order.id));

    const saved = await repository.findById(order.id);
    expect(saved.status).toBe(OrderStatus.Placed);
    expect(eventBus.published).toContainEvent(OrderPlacedEvent);
  });
});
```

#### 3. Infrastructure Tests (Integration Tests)
```typescript
// Test actual database
describe('PostgresOrderRepository', () => {
  let db: PostgresClient;
  let repository: PostgresOrderRepository;

  beforeEach(async () => {
    db = await setupTestDatabase();
    repository = new PostgresOrderRepository(db);
  });

  it('should persist and retrieve order', async () => {
    const order = Order.create(customerId);
    await repository.save(order);

    const retrieved = await repository.findById(order.id);
    expect(retrieved).toEqual(order);
  });

  afterEach(async () => {
    await cleanupTestDatabase(db);
  });
});
```

#### 4. End-to-End Tests
```typescript
// Test full flow through HTTP
describe('POST /orders/:id/place', () => {
  it('should place order', async () => {
    const orderId = await createTestOrder();
    
    const response = await request(app)
      .post(`/orders/${orderId}/place`)
      .expect(200);

    const order = await getOrderFromDatabase(orderId);
    expect(order.status).toBe('placed');
  });
});
```

---

## Putting It All Together

**A complete example:**

### 1. Start with Domain (TDD)
```typescript
// 1. Write test
it('should calculate order total correctly');
// 2. Implement domain logic
class Order { calculateTotal() { ... } }
// 3. Refactor
```

### 2. Build Use Case
```typescript
class PlaceOrderUseCase {
  // Orchestrate domain
  // Delegates to domain methods
}
```

### 3. Implement Infrastructure
```typescript
class PostgresOrderRepository implements OrderRepository {
  // Database-specific implementation
}
```

### 4. Add Presentation
```typescript
class OrderController {
  // HTTP handling
  // Delegates to use case
}
```

---

## Enforcement

**We enforce this architecture through:**

1. **ArchUnit Tests** - Automated dependency checks
2. **Code Review** - Manual verification
3. **Pull Request Templates** - Structured review
4. **CI/CD Pipeline** - Automated quality gates

See [Enforcement System](../03-processes/enforcement.md) for details.

---

## Common Mistakes

### ❌ Anemic Domain Models
```typescript
// DON'T
class Order {
  status: string;
  items: any[];
}

class OrderService {
  placeOrder(order: Order) {
    // Business logic in service
  }
}
```

### ✅ Rich Domain Models
```typescript
// DO
class Order {
  place(): void {
    // Business logic in domain
  }
}
```

### ❌ Framework Dependencies in Domain
```typescript
// DON'T
import { Entity } from 'typeorm';

@Entity()
class Order { ... }
```

### ✅ Pure Domain
```typescript
// DO
class Order {
  // No framework imports
}
```

### ❌ Business Logic in Controllers
```typescript
// DON'T
class OrderController {
  placeOrder() {
    if (order.items.length === 0) {
      throw new Error(); // Business rule in controller!
    }
  }
}
```

### ✅ Thin Controllers
```typescript
// DO
class OrderController {
  async placeOrder() {
    await this.placeOrderUseCase.execute(command);
  }
}
```

---

## 📚 Want More Detail?

This is the **practical guide** (751 lines) - focused on day-to-day application.

For **comprehensive coverage** including:
- ✅ Detailed examples for every pattern
- ✅ Common pitfalls and how to avoid them
- ✅ Philosophy and reasoning behind each decision
- ✅ Advanced techniques and edge cases
- ✅ Full context and theory (1,647 lines)

**See:** [System Deep Dive](../reference/system-deep-dive.md)

---

## Learning Resources

- **Book:** Domain-Driven Design by Eric Evans
- **Book:** Implementing Domain-Driven Design by Vaughn Vernon
- **Book:** Clean Architecture by Robert C. Martin
- **Video:** [Clean Architecture Series] by Uncle Bob
- **Internal:** [OneSyntax Workshops](../04-training/workshops.md)

---

## Questions?

- **Slack:** #architecture
- **Workshop:** Weekly DDD office hours
- **1:1:** Your tech lead

**Remember:** These aren't academic exercises. This is how we keep our promise to clients.

**Let's build software that matters. Together.**
