# Introduce

Boilerplate for Ruby on Rails using Modular architecture. Using `PnPM` workspaces to handle monorepo for JavaScript/TypeScript inside Rails app managed by `Vite`.

# Project Structure

```sh
  ├── apps
  ├── db
  ├── config
  ├── lib
  └── packages
      ├── core
      └── auth
```

- apps: like the normal rails app
- db: contains migrations and seeds from main app and other plugins
- config: like normal rails app
- lib: like normal rails app
- packages
  - core: contains all services/jobs/... for main app and plugins
  - auth: contains all services/jobs/... for authentication and/or authorization

# Run project

- Start `vite` server for plugin before running `rails s`

```sh
pnpm --filter=<plugin package name> dev
```

# Commands

- Run all migrations from main app and all plugins

```sh
rake cli:db:migrate
```

- Create package

```sh
rails g package <package_name>
```

- Remove package

```sh
rails d package <package_name>
```

**Notice**: this will remove your folder entirely

# Env

- If you wanna use credentials, use this command to edit

```sh
EDITOR=vi rails credentials:edit --environment production|staging|development|test
```

# TODO

[ ] Write cli to create migration for package instead of accessing and running rails migration

[ ] Write generator for tailwindcss and windicss with `vite_rails`

[ ] Write cli to run `rails s` with `bin/vite dev` from plugins that use `vite_rails`
