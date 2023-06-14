# Introduce

Boilerplate for Ruby on Rails using Modular architecture.

# Project Structure

```sh
  ├── apps
  ├── db
  ├── config
  ├── lib
  └── packages
      └── core
```

- apps: like the normal rails app
- db: contains migrations and seeds from main app and other plugins
- config: like normal rails app
- lib: like normal rails app
- packages
  - core: contains all services/jobs/... for main app and plugins

# Commands

- Run all migrations from main app and all plugins

```sh
rake cli:db:migrate
```

- Create plugin

```sh
rails plugin new packages/<plugin_name> --mountable
```

# Env

- If you wanna use credentials, use this command to edit

```sh
EDITOR=vi rails credentials:edit --environment production|staging|development|test
```

# TODO

[ ] Write cli or rake task to create plugin to `packages` folder instead of passing prefix
[ ] Write cli to create migration for package instead of accessing and running rails migration
