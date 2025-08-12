# Shiny Guacamole
A responsive mobile-enhanced website built with Next.js and Supabase integration for the c.qr tech pilot project.

## 🚀 Quick Development Setup

1. Clone the repository:
```bash
git clone https://github.com/cqrtechciara/shiny-guacamole.git
cd shiny-guacamole
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables (see [Environment Variables](#environment-variables))

4. Run the development server:
```bash
npm run dev
```

5. Open [http://localhost:3000](http://localhost:3000) in your browser

## 🛠 Tech Stack

- **Framework:** Next.js 14
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **Database:** Supabase (PostgreSQL)
- **Authentication:** Supabase Auth
- **Deployment:** Vercel (Production)
- **Package Manager:** npm
- **Type:** Responsive Mobile-Enhanced Website

## 💻 Local Development

### Prerequisites

- Node.js 18+
- npm
- Git
- Supabase account

### Setup Steps

1. Clone and install:
```bash
git clone https://github.com/cqrtechciara/shiny-guacamole.git
cd shiny-guacamole
npm install
```

2. Environment setup:
   - Copy .env.example to .env.local
   - Fill in your Supabase credentials

3. Database setup:
   - Run Supabase migrations
   - Seed the database (optional)

4. Start development:
```bash
npm run dev
```

## 🔐 Environment Variables

Create a .env.local file in the root directory with the following variables:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Database URL (for migrations)
DATABASE_URL=your_database_connection_string_here

# Next.js Configuration
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your_nextauth_secret_here

# Additional environment-specific variables
NODE_ENV=development
```

## 🚢 Deploy to Vercel

This mobile-enhanced website is designed to be deployed on Vercel for optimal performance and scalability.

### One-Click Deploy

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/cqrtechciara/shiny-guacamole)

### Manual Deployment

1. Install Vercel CLI:
```bash
npm i -g vercel
```

2. Login to Vercel:
```bash
vercel login
```

3. Deploy:
```bash
vercel
```

4. Set environment variables in Vercel dashboard:
   - Go to your project settings
   - Add all environment variables from .env.local
   - Redeploy if necessary

### Production Environment Variables

Make sure to set these in your Vercel project settings:
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY
- DATABASE_URL
- NEXTAUTH_URL (your production URL)
- NEXTAUTH_SECRET

## 🗄️ Supabase Migration Instructions

### Initial Setup

1. Install Supabase CLI:
```bash
npm install -g supabase
```

2. Login to Supabase:
```bash
supabase login
```

3. Link your project:
```bash
supabase link --project-ref your-project-ref
```

### Running Migrations

1. Apply existing migrations:
```bash
supabase db push
```

2. Reset database (development only):
```bash
supabase db reset
```

### Creating New Migrations

1. Generate a new migration:
```bash
supabase migration new your_migration_name
```

2. Edit the migration file in `supabase/migrations/`

3. Apply the migration:
```bash
supabase db push
```

### Database Schema Management

1. Pull schema changes from remote:
```bash
supabase db pull
```

2. Generate types (TypeScript):
```bash
supabase gen types typescript --local > types/supabase.ts
```

### Seeding Data

1. Run seed script:
```bash
supabase db seed
```

2. Custom seed files are located in `supabase/seed.sql`

## 📁 Project Structure

```
shiny-guacamole/
├── app/                    # Next.js app directory
├── lib/                    # Utility libraries
│   └── supabase/          # Supabase client configuration
├── supabase/              # Supabase configuration
│   ├── migrations/        # Database migrations
│   └── seed.sql          # Database seed data
├── types/                 # TypeScript type definitions
├── .env.local            # Environment variables (create this)
├── .env.example          # Environment variables template
├── package.json          # Dependencies and scripts
└── README.md            # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run tests: `npm test`
5. Commit your changes: `git commit -am 'Add feature'`
6. Push to the branch: `git push origin feature-name`
7. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

c.qr tech pilot project - A responsive mobile-enhanced website built with ❤️ using Next.js and Supabase
