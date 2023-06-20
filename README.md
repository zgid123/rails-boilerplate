# Introduce

Boilerplate for Ruby on Rails using Modular architecture. Using `PnPM` workspaces to handle monorepo for JavaScript/TypeScript inside Rails app managed by `Vite`.

**Notes**:

- Even this boilerplate provides a way to integrate `vite` for root app, **DO NOT** use it

- If you still wanna integrate `vite` for root app, you should check plugin config and make it works yourself

# Project Structure

```sh
  ├── apps
  ├── db
  ├── config
  ├── lib
  └── packages
      ├── admin
      ├── core
      └── auth
```

- apps: like the normal rails app
- db: contains migrations and seeds from main app and other plugins
- config: like normal rails app
- lib: like normal rails app
- packages
  - admin: contains all serviers/jobs/... for admin
  - core: contains all services/jobs/... for main app and plugins
  - auth: contains all services/jobs/... for authentication and/or authorization

# Setup

- Create `database.yml` for root project

```sh
cp config/database.yml.example config/database.yml
```

- Remove those blocks in `.gitignore`

```
/db/migrate/*
/db/schema.rb
```

- Apply migrations for project

```sh
rake cli:db:migrate
```

# Run project

- Start `vite` server for plugin before running `rails s`

```sh
pnpm --filter=<plugin package name> dev
```

- Start all plugin's `vite` server

```sh
pnpm -w dev
```

# Docs

- [rake tasks](docs/rake-tasks.md)

- [create/remove package](docs/package.md)

- [integrate vite](docs/vite.md)

- [integrate ujs](docs/ujs_utils.md)

- [integrate tailwind](docs/tailwind.md)

- [create migration for package](docs/migration.md)

# Env

- If you wanna use credentials, use this command to edit

```sh
EDITOR=vi rails credentials:edit --environment production|staging|development|test
```

# TODO

[ ] Write cli to run `rails s` with `bin/vite dev` from plugins that use `vite_rails`

[ ] Update generator `ujs-utils` to integrate `stimulus`, `turbolink` and/or `import_map`

[ ] Make the `clean_content` method better

[ ] Create rake task to setup project

[ ] Create configuration for auth package to config something related to devise like `after_sign_in_path_for`, `after_sign_out_path_for`, ... instead of hard coding the url inside `auth` package
