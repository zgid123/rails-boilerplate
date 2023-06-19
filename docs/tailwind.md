This boilerplate has a generator to integrate `tailwind` for rails.

When using this generator, it will invoke `vite` generator because `tailwind` will be managed by `vite`.

# Usage

- Integrate for root app

```sh
rails g tailwind --root
```

- Integrate for packages

```sh
rails g tailwind --packages=package_1 package_2 package_3 ...
```

- Integrate for both at the same time

```sh
rails g tailwind --root --packages=package_1 package_2 package_3 ...
```

- Integrate if already had `vite` config

```sh
rails g tailwind --packages=package_1 package_2 package_3 ... --skip-vite
```

# Remove integration

- Remove integration for root app

```sh
rails d tailwind --root
```

- Remove integration for packages

```sh
rails d tailwind --packages=package_1 package_2 package_3 ...
```

- Remove integration for both at the same time

```sh
rails d tailwind --root --packages=package_1 package_2 package_3 ...
```

# Note

- When using `--packages` option, those packages need to be created before or else it does nothing. [How to create package](package.md)
