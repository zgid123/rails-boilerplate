This boilerplate has a generator to integrate `@rails/ujs`, `jquery`, ... for rails.

You must have `vite` integration before using this generator.

# Usage

- Integrate for root app

```sh
rails g ujs_utils --root
```

- Integrate for packages

```sh
rails g ujs_utils --packages=package_1 package_2 package_3 ...
```

- Integrate for both at the same time

```sh
rails g ujs_utils --root --packages=package_1 package_2 package_3 ...
```

# Remove integration

- Remove integration for root app

```sh
rails d ujs_utils --root
```

- Remove integration for packages

```sh
rails d ujs_utils --packages=package_1 package_2 package_3 ...
```

- Remove integration for both at the same time

```sh
rails d ujs_utils --root --packages=package_1 package_2 package_3 ...
```

# Note

- When using `--packages` option, those packages need to be created before or else it does nothing. [How to create package](package.md)
