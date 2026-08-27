# Horizontal Modularization in iOS

A practical example of **Horizontal Modularization** in an iOS application using **Swift Package Manager** and local Swift packages.

This repository accompanies **Episode 12** of the iOS Architecture series:

> **Horizontal Modularization — Creating The Packages Step By Step**

The goal of this project is not just to organize code into folders, but to create **real module boundaries that the Swift compiler can enforce**.

---

## 🎯 What We Build

In this project, the application is split horizontally into five local Swift packages:

```text
App
│
├── Presentation
│
├── Data
│   ├── Domain
│   └── Networking
│
├── Domain
│
├── DesignSystem
│
└── Networking
```

Each package has a clear responsibility and can only access the modules it explicitly depends on.

This gives us **compile-time enforcement** of our architecture instead of relying only on conventions.

---

## 📦 Modules

### 🌐 Networking

Contains the low-level networking infrastructure.

Responsibilities include:

- `HTTPClient`
- `URLSessionHTTPClient`
- HTTP requests
- Network responses
- Networking errors

The Networking package knows nothing about:

- Features
- UI
- Domain models
- Business logic

```text
Networking
└── No feature knowledge
```

---

### 🎨 DesignSystem

Contains reusable UI components and styling shared across the application.

Examples:

- Colors
- Typography
- Reusable SwiftUI components
- Common UI styles

The goal is to keep shared presentation primitives in one isolated module.

---

### 🧠 Domain

The core business layer of the application.

It contains:

- Domain models
- Repository protocols
- Use cases
- Business rules

The most important rule:

> **Domain depends on nothing.**

```text
Domain
└── Zero dependencies
```

It doesn't know how data is fetched, where it comes from, or how it is displayed.

---

### 💾 Data

Responsible for implementing the contracts defined by the Domain layer.

It contains:

- Repository implementations
- DTOs
- API mapping
- Remote data access
- Domain model mapping

The dependency direction is important:

```text
Data
├── Domain
└── Networking
```

The **Domain defines the protocol**, while **Data implements it**.

This is dependency inversion in practice.

DTOs also remain internal to the Data module and never leak into Domain or Presentation.

---

### 🖥️ Presentation

Contains the presentation logic of the application.

Examples:

- View models
- Presentation models
- UI state
- Feature presentation logic

Presentation communicates with the application through abstractions defined by the Domain layer rather than depending directly on networking or concrete data implementations.

---

## 🔗 Dependency Direction

One of the main goals of this architecture is controlling dependency direction.

```text
                 ┌──────────────┐
                 │     App      │
                 └──────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
   Presentation       Data      DesignSystem
          │          /    \
          │         ▼      ▼
          └────► Domain  Networking
```

The compiler prevents modules from accessing code they don't explicitly depend on.

For example:

```swift
import Domain
```

works only when `Domain` is declared as a dependency of that package.

Trying to import an undeclared module results in a build error.

That's exactly what we want.

---

## 🧩 The Composition Root

The final dependency wiring happens inside the **App target**.

The App is the only place that knows about all the concrete implementations.

Conceptually:

```swift
let httpClient = URLSessionHTTPClient()

let repository = RemotePostsRepository(
    httpClient: httpClient
)

let useCase = GetPostsUseCase(
    repository: repository
)

let viewModel = PostsViewModel(
    getPostsUseCase: useCase
)
```

This is the **Composition Root**.

Instead of modules constructing their own dependencies, the application creates them and injects them from one place.

```text
App
 ↓
Creates concrete dependencies
 ↓
Connects modules together
 ↓
Starts the application
```

---

## 🏗️ Package Creation Order

When creating the architecture from scratch, package order matters.

The packages are created in this order:

```text
1. Networking
      ↓
2. DesignSystem
      ↓
3. Domain
      ↓
4. Data
      ↓
5. Presentation
      ↓
6. App
```

Every package is created only after the modules it depends on already exist.

This prevents unnecessary dependency and build errors while setting up the project.

---

## 🧪 Testing The Boundaries

One advantage of using local Swift packages is that architectural rules become compiler rules.

We can intentionally try things that should **not** be allowed.

For example, attempting to import Networking directly inside Domain:

```swift
import Networking
```

should fail if Networking isn't declared as a Domain dependency.

Similarly, Domain should never need to know about:

```swift
URLSession
```

or concrete implementations such as:

```swift
URLSessionHTTPClient
```

Those implementation details belong outside the business layer.

---

## ❌ "No Such Module"

While creating local packages in Xcode, you may encounter:

```text
No such module 'Domain'
```

or a similar error.

Before changing your architecture, verify that:

- The local package has been added correctly.
- The required package product is linked to the correct target.
- The dependency is declared in `Package.swift`.
- Xcode has resolved the local Swift packages.
- You're importing the package's product/module name correctly.

A module should only be importable when the dependency is intentional.

---

## 🌐 Sample API

The project uses the **DummyJSON Posts API** as the sample backend:

`https://dummyjson.com/posts`

The API is intentionally simple so the focus stays on **architecture and module boundaries**, not backend complexity.

---

## 🎬 Episode 12

### Horizontal Modularization — Creating The Packages Step By Step

In this episode, we build five local Swift packages in Xcode and prove that the compiler actually enforces the boundaries.

### You'll Learn

- Local Swift packages vs framework targets
- Why Swift packages create real module boundaries
- The correct package creation order
- Building an isolated Networking layer
- Creating a Domain package with zero dependencies
- Dependency inversion between Domain and Data
- Keeping DTOs internal to the Data module
- Building the Presentation module
- Creating the Composition Root
- Testing architecture boundaries with intentional build errors
- Fixing the classic `No such module` error in Xcode

---

## 📚 Previous Episode

**Episode 11 — Horizontal Modularization: How It Works & When To Use It**

Episode 11 focuses on designing and understanding the architecture.

Episode 12 takes that design and **builds it for real in Xcode**.

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/afathe7090/Horizontal-Modularization-Youtube.git
```

Open the Xcode project:

```text
HorizontalModularization.xcodeproj
```

Then allow Xcode to resolve the local Swift package dependencies and run the application.

---

## 💡 Why Horizontal Modularization?

As an iOS codebase grows, putting everything inside one application target makes architectural boundaries increasingly difficult to maintain.

Horizontal modularization separates the application by **technical responsibility**:

```text
Networking
DesignSystem
Domain
Data
Presentation
```

This can provide:

- Clear dependency boundaries
- Better separation of concerns
- Compiler-enforced architecture
- Easier testing
- More maintainable code
- Reduced accidental coupling
- Better scalability as the project grows

But modularization also introduces complexity.

The goal isn't:

> "Create as many modules as possible."

The goal is:

> **Create boundaries where boundaries provide value.**

---

## 👨‍💻 Course

Part of the **iOS Architecture Series** by **Ahmed Fathy**.

The series focuses on building scalable iOS applications while understanding not only **how** architectural patterns work, but **why and when** to use them.

---

## 🏷️ Topics

`iOS Development` · `Swift` · `Swift Package Manager` · `SwiftUI` · `Xcode` · `Modularization` · `iOS Architecture` · `Clean Architecture` · `Scalable Apps`

---

## ⭐ Support

If this repository or the series helps you understand iOS architecture, consider giving the repository a ⭐.

It helps support the series and makes the project easier for other iOS developers to discover.

---

**Ahmed Fathy — iOS Architecture Series**
