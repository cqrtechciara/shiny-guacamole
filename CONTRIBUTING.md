# Contributing to Shiny Guacamole

Welcome to the Shiny Guacamole project! We're excited that you're interested in contributing. This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Contributions](#making-contributions)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](https://docs.github.com/articles/github-community-guidelines). Please read it before contributing.

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- **Node.js 18+** installed
- **npm** package manager
- **Git** version control
- **Supabase** account (for database-related contributions)
- Basic knowledge of **Next.js**, **TypeScript**, and **Tailwind CSS**

### First-time Setup

1. **Fork the repository** to your GitHub account
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/shiny-guacamole.git
   cd shiny-guacamole
   ```
3. **Add upstream remote:**
   ```bash
   git remote add upstream https://github.com/cqrtechciara/shiny-guacamole.git
   ```
4. **Install dependencies:**
   ```bash
   npm install
   ```
5. **Set up environment variables** (copy `.env.example` to `.env.local`)

## Development Setup

### Running the Development Server

```bash
npm run dev
```

The application will be available at `http://localhost:3000`

### Database Setup

For Supabase-related development:

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link project
supabase link --project-ref your-project-ref

# Apply migrations
supabase db push
```

## Making Contributions

### Types of Contributions

We welcome various types of contributions:

- 🐛 **Bug fixes**
- ✨ **New features**
- 📚 **Documentation improvements**
- 🧪 **Tests**
- 🎨 **UI/UX enhancements**
- ⚡ **Performance improvements**
- 🔧 **Configuration and tooling**

### Before You Start

1. **Check existing issues** to avoid duplicate work
2. **Create an issue** for major changes to discuss the approach
3. **Keep changes focused** - one feature/fix per PR
4. **Update documentation** if your changes affect usage

## Pull Request Process

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make Your Changes

- Write clean, well-documented code
- Follow our [coding standards](#coding-standards)
- Add tests for new functionality
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run tests
npm test

# Run linting
npm run lint

# Check types
npm run type-check

# Test build
npm run build
```

### 4. Commit Your Changes

We follow [Conventional Commits](https://conventionalcommits.org/):

```bash
# Examples:
git commit -m "feat: add user authentication flow"
git commit -m "fix: resolve mobile navigation issue"
git commit -m "docs: update API documentation"
```

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:

- Clear title and description
- Screenshots for UI changes
- Reference to related issues
- Checklist of completed tasks

## Coding Standards

### TypeScript

- Use strict TypeScript configuration
- Define proper types and interfaces
- Avoid `any` types when possible
- Use meaningful variable and function names

### React/Next.js

- Use functional components with hooks
- Implement proper error boundaries
- Follow Next.js best practices for routing and API routes
- Use Server Components when appropriate

### Styling

- Use Tailwind CSS utility classes
- Follow mobile-first responsive design
- Maintain consistent spacing and typography
- Use semantic HTML elements

### File Organization

```
shiny-guacamole/
├── app/                  # Next.js app directory
│   ├── (auth)/          # Route groups
│   ├── api/             # API routes
│   └── globals.css      # Global styles
├── components/          # Reusable UI components
├── lib/                 # Utility functions
├── types/               # TypeScript type definitions
└── supabase/           # Database migrations and config
```

## Testing

### Writing Tests

- Write unit tests for utilities and components
- Add integration tests for critical user flows
- Test accessibility with screen readers
- Verify responsive design across devices

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

## Documentation

### Code Documentation

- Add JSDoc comments for functions and components
- Document complex business logic
- Keep README.md up to date
- Update API documentation for new endpoints

### Commit Messages

Follow the format: `type(scope): description`

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (not affecting functionality)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

## Community

### Getting Help

- 📝 **Create an issue** for bugs or feature requests
- 💬 **Start a discussion** for questions or ideas
- 📧 **Contact maintainers** for urgent matters

### Recognition

All contributors are recognized in our project documentation and release notes. We appreciate every contribution, no matter how small!

## License

By contributing to Shiny Guacamole, you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers the project.

---

**Thank you for contributing to Shiny Guacamole! 🥑✨**

We're building something amazing together, and your contributions make it possible.
