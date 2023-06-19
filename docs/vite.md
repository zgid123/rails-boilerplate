This boilerplate has a generator to integrate `vite` for rails using `vite_rails` gem.

# Usage

- Integrate for root app

```sh
rails g vite --root
```

- Integrate for packages

```sh
rails g vite --packages=package_1 package_2 package_3 ...
```

- Integrate for both at the same time

```sh
rails g vite --root --packages=package_1 package_2 package_3 ...
```

# Remove integration

- Remove integration for root app

```sh
rails d vite --root
```

- Remove integration for packages

```sh
rails d vite --packages=package_1 package_2 package_3 ...
```

- Remove integration for both at the same time

```sh
rails d vite --root --packages=package_1 package_2 package_3 ...
```

# Note

- When using `--packages` option, those packages need to be created before or else it does nothing. [How to create package](package.md)

- When remove integration, if you insert some code lines between the generated code, the generator won't remove code entirely for you, you should remove manually
