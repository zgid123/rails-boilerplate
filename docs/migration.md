This boilerplate has a generator to generate a `migration` for a `package`.

# Usage

```sh
rails g package_migration package_1 create_tests
```

It will create migration `create_tests` for package `package_1`

# Remove migration

```sh
rails d package_migration package_1 create_tests
```

It will remove migration `create_tests` for package `package_1`

# Note

- For root app, use the `rails g migration create_tests`

- Package must be existed before using
