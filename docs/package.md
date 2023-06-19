This boilerplate has a generator to generate a `package` (rails engine) into folder `packages`. All engines need to be inside that folder or else you should do other integration by yourself.

# Usage

```sh
rails g package package_1
```

This will create `packages/package_1` with minimal config.

# Remove package

```sh
rails d package package_1
```

This will remove `packages/package_1` entirely. It will ask to confirm, when `yes`, the folder will be removed entirely, all the ingrations and related code will be gone. **BE CAREFUL**.
