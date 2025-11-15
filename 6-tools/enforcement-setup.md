# Enforcement Tools Setup Guide
**ArchUnit, Linters, and CI/CD Configuration**

Version: 1.0  
Last Updated: November 2025

---

## Overview

This guide shows you how to set up automated enforcement of OneSyntax architecture standards.

**Tools we use:**
1. **ArchUnit** - Architecture testing (TypeScript/JavaScript version)
2. **ESLint + Custom Rules** - Code quality and patterns
3. **SonarQube** - Code analysis
4. **GitHub Actions** - CI/CD pipeline

---

## 1. ArchUnit Setup (TypeScript)

### Installation

```bash
npm install --save-dev ts-arch jest @types/jest
```

### Configuration

Create `archunit.config.ts`:

```typescript
import { filesOfProject } from 'ts-arch';

export const project = filesOfProject();

// Define layer patterns
export const layers = {
  domain: 'src/domain/**/*.ts',
  application: 'src/application/**/*.ts',
  infrastructure: 'src/infrastructure/**/*.ts',
  presentation: 'src/presentation/**/*.ts'
};
```

### Architecture Rules

Create `src/__tests__/architecture.spec.ts`:

```typescript
import { filesOfProject, Rule } from 'ts-arch';
import { layers } from '../archunit.config';

describe('Architecture Rules', () => {
  
  it('domain should not depend on infrastructure', async () => {
    const rule = filesOfProject()
      .inFolder(layers.domain)
      .shouldNot()
      .dependOnFiles()
      .inFolder(layers.infrastructure);

    await expect(rule).toPassAsync();
  });

  it('domain should not depend on application', async () => {
    const rule = filesOfProject()
      .inFolder(layers.domain)
      .shouldNot()
      .dependOnFiles()
      .inFolder(layers.application);

    await expect(rule).toPassAsync();
  });

  it('domain should not depend on presentation', async () => {
    const rule = filesOfProject()
      .inFolder(layers.domain)
      .shouldNot()
      .dependOnFiles()
      .inFolder(layers.presentation);

    await expect(rule).toPassAsync();
  });

  it('application should not depend on infrastructure', async () => {
    const rule = filesOfProject()
      .inFolder(layers.application)
      .shouldNot()
      .dependOnFiles()
      .inFolder(layers.infrastructure);

    await expect(rule).toPassAsync();
  });

  it('use cases should end with UseCase', async () => {
    const rule = filesOfProject()
      .inFolder('src/application/usecases/**/*.ts')
      .should()
      .matchName(/.*UseCase\.ts$/);

    await expect(rule).toPassAsync();
  });
});
```

---

## 2. ESLint Setup

### Installation

```bash
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### Configuration

Create `.eslintrc.json`:

```json
{
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "rules": {
    "max-lines-per-function": ["error", 50],
    "complexity": ["error", 10],
    "max-depth": ["error", 3],
    "no-console": "error",
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "error"
  }
}
```

---

## 3. CI/CD Pipeline (GitHub Actions)

Create `.github/workflows/quality.yml`:

```yaml
name: Quality Checks

on:
  pull_request:
    branches: [ main, develop ]
  push:
    branches: [ main, develop ]

jobs:
  quality:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Lint
      run: npm run lint
    
    - name: Architecture Tests
      run: npm run test:arch
    
    - name: Unit Tests
      run: npm run test:unit
    
    - name: Coverage Check
      run: npm run test:coverage
      
    - name: Build
      run: npm run build
```

---

## 4. Package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts",
    "lint:fix": "eslint . --ext .ts --fix",
    "test:arch": "jest --testPathPattern=architecture.spec.ts",
    "test:unit": "jest --testPathIgnorePatterns=architecture.spec.ts",
    "test:coverage": "jest --coverage --coverageThreshold='{\"global\":{\"lines\":80}}'",
    "test": "npm run lint && npm run test:arch && npm run test:unit"
  }
}
```

---

## 5. SonarQube Setup (Optional)

```yaml
# sonar-project.properties
sonar.projectKey=onesyntax-project
sonar.sources=src
sonar.tests=src/__tests__
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.coverage.exclusions=**/*.spec.ts,**/*.test.ts
```

---

## Enforcement in Action

### Local Development

```bash
# Before committing
npm run lint
npm run test:arch
npm run test

# Auto-fix what's possible
npm run lint:fix
```

### Pull Request

1. Developer creates PR
2. GitHub Actions runs automatically
3. All checks must pass:
   - ✅ Linting
   - ✅ Architecture rules
   - ✅ Unit tests
   - ✅ Coverage >80%
4. Senior reviews code
5. PR approved → Merge allowed

### What Happens on Failure

**Architecture violation detected:**
```
❌ FAILED: domain should not depend on infrastructure

  File: src/domain/entities/Order.ts
  Violates: Imports from src/infrastructure/database/PostgresClient.ts
  
  Fix: Remove infrastructure dependency from domain layer
```

**Action:** Developer fixes, pushes again, checks re-run

---

## Custom Rules Examples

### Rule: No Anemic Domain Models

```typescript
// Custom ESLint rule (simplified)
it('entities should have business methods', async () => {
  const rule = filesOfProject()
    .inFolder('src/domain/entities/**/*.ts')
    .should()
    .haveMinimumMethods(3); // More than just getters/setters

  await expect(rule).toPassAsync();
});
```

### Rule: Use Cases Return DTOs

```typescript
it('use cases should not return domain entities', async () => {
  const rule = filesOfProject()
    .inFolder('src/application/usecases/**/*.ts')
    .shouldNot()
    .haveReturnType(/Entity|Aggregate/);

  await expect(rule).toPassAsync();
});
```

---

## Troubleshooting

**Issue: Too many false positives**
- Review and adjust rules
- Add exceptions where justified
- Document why exceptions exist

**Issue: Rules too slow**
- Run architecture tests separately
- Cache dependencies in CI
- Optimize rule patterns

**Issue: Team pushback**
- Show value (bugs caught)
- Adjust strict rules
- Better education on WHY

---

## Maintenance

**Monthly:**
- Review violations
- Adjust rules if needed
- Update to latest tool versions

**Quarterly:**
- Add new rules based on issues found
- Remove rules that don't add value
- Celebrate improvements

---

**Let's build software that matters. Together.**
