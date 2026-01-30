# Component Library

A comprehensive React component library built with TypeScript, Tailwind CSS, and accessibility best practices for the C.QR Tech project.

## 🎨 Design System

This component library is built following the design system tokens defined in:
- `tailwind.config.ts` - Tailwind configuration with comprehensive color palette and design tokens
- `app/globals.css` - CSS custom properties and component base styles
- Figma Design System: [Mobile Opt - C.QR Tech - Launch](https://www.figma.com/make/UmF8b7cFeZ0JQvQDGxqrvt/Mobile-Opt---C.QR-Tech---Launch)

## 📁 Component Structure

```
app/components/
├── ui/                     # Core UI primitives
│   ├── Button/
│   │   ├── Button.tsx      # Main component
│   │   ├── Button.types.ts # TypeScript interfaces
│   │   └── index.ts        # Export barrel
│   ├── Input/
│   ├── Card/
│   ├── Modal/
│   └── ...
├── forms/                  # Form-specific components
│   ├── LoginForm/
│   ├── ContactForm/
│   └── ...
├── layout/                 # Layout components
│   ├── Header/
│   ├── Navigation/
│   ├── Sidebar/
│   └── Footer/
├── feedback/               # User feedback components
│   ├── Toast/
│   ├── Alert/
│   ├── Loading/
│   └── ...
└── icons/                  # Icon components
    ├── ChevronIcon/
    ├── UserIcon/
    └── ...
```

## 🧩 Component Categories

### UI Primitives (`ui/`)
Core reusable components that form the foundation of the design system:
- **Button** - Primary, secondary, destructive, and ghost button variants
- **Input** - Text inputs, textareas, selects with validation states
- **Card** - Container component with header, content, and footer areas
- **Modal** - Accessible modal dialogs with backdrop and focus management
- **Dropdown** - Dropdown menus and select components
- **Badge** - Status indicators and tags
- **Avatar** - User profile images with fallbacks
- **Switch** - Toggle switches for boolean settings
- **Checkbox** - Checkbox inputs with indeterminate state
- **RadioGroup** - Radio button groups

### Form Components (`forms/`)
Composed form components for specific use cases:
- **LoginForm** - Complete authentication form
- **ContactForm** - Contact/support form
- **SearchForm** - Search input with filters
- **SettingsForm** - User settings and preferences

### Layout Components (`layout/`)
Structural components for page organization:
- **Header** - Site header with navigation and user menu
- **Navigation** - Primary navigation component
- **Sidebar** - Collapsible sidebar navigation
- **Footer** - Site footer with links and info
- **Container** - Responsive container wrapper
- **Grid** - CSS Grid layout component

### Feedback Components (`feedback/`)
Components for user feedback and system states:
- **Toast** - Temporary notification messages
- **Alert** - Persistent alert messages
- **Loading** - Loading spinners and skeletons
- **ProgressBar** - Progress indicators
- **ErrorBoundary** - Error handling wrapper

### Icon Components (`icons/`)
SVG icon components optimized for accessibility:
- **ChevronIcon** - Directional arrows
- **UserIcon** - User-related icons
- **SystemIcons** - System status and action icons

## 🎯 Design Principles

### Accessibility First
- All components follow WCAG 2.1 AA guidelines
- Proper ARIA labels and descriptions
- Keyboard navigation support
- Focus management and visible focus indicators
- Screen reader compatibility

### Mobile-First Responsive
- Components designed for mobile-first approach
- Touch-friendly interactive elements (44px minimum)
- Responsive breakpoints following Tailwind defaults
- Optimized for various screen sizes

### Performance Optimized
- Tree-shakeable exports
- Lazy loading for complex components
- Minimal bundle impact
- Optimized re-renders with React.memo where appropriate

### Type Safety
- Full TypeScript support
- Comprehensive prop interfaces
- Generic components where applicable
- Runtime prop validation in development

## 🚀 Usage

### Basic Component Usage
```tsx
import { Button, Card, Input } from '@/app/components/ui';

function MyComponent() {
  return (
    <Card>
      <Card.Header>
        <h2>Login Form</h2>
      </Card.Header>
      <Card.Content>
        <Input placeholder="Email" type="email" />
        <Input placeholder="Password" type="password" />
      </Card.Content>
      <Card.Footer>
        <Button variant="primary">Sign In</Button>
      </Card.Footer>
    </Card>
  );
}
```

### Form Component Usage
```tsx
import { LoginForm } from '@/app/components/forms';

function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <LoginForm 
        onSubmit={handleLogin}
        onForgotPassword={handleForgotPassword}
      />
    </div>
  );
}
```

## 🎨 Theming

Components automatically adapt to the design system theme:

```tsx
// Light and dark mode support
<Button variant="primary">   // Uses CSS custom properties
<Card className="bg-card">   // Automatic theme adaptation
```

### CSS Custom Properties
All components use CSS custom properties defined in `globals.css`:
- `--primary` - Brand primary color
- `--background` - Page background
- `--foreground` - Text color
- `--muted` - Subdued content
- `--border` - Border colors
- And many more...

## 🔧 Development Guidelines

### Component Creation Checklist
- [ ] Component follows naming conventions
- [ ] TypeScript interfaces defined
- [ ] Accessibility attributes included
- [ ] Responsive design implemented
- [ ] Dark mode support
- [ ] Export added to index.ts
- [ ] Props documented with JSDoc
- [ ] Error boundaries where appropriate

### Code Standards
- Use TypeScript for all components
- Follow React functional component patterns
- Use Tailwind classes for styling
- Implement proper error handling
- Include loading and error states
- Add proper ARIA labels and roles

## 📚 Resources

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [React Accessibility Guide](https://reactjs.org/docs/accessibility.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [TypeScript React Patterns](https://react-typescript-cheatsheet.netlify.app/)

## 🤝 Contributing

When adding new components:
1. Follow the established directory structure
2. Include comprehensive TypeScript types
3. Implement accessibility best practices
4. Add responsive design support
5. Test across different devices and browsers
6. Update this README with new components

---

*This component library is part of the C.QR Tech design system and follows modern web development best practices for accessibility, performance, and maintainability.*
