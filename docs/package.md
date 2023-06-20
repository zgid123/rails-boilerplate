This boilerplate has a generator to generate a `package` (rails engine) into folder `packages`. All engines need to be inside that folder or else you should do other integration by yourself.

# Usage

- Create package acts as library

```sh
rails g package package_1
```

- Create package with api controller

```sh
rails g package package_1 --rails-api
```

- Create package with normal controller

```sh
rails g package package_1 --rails-app
```

- Create package with both controllers

```sh
rails g package package_1 --rails-app --rails-api
```

# Remove package

```sh
rails d package package_1
```

This will remove `packages/package_1` entirely. It will ask to confirm, when `yes`, the folder will be removed entirely, all the ingrations and related code will be gone. **BE CAREFUL**.
