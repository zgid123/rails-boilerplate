This file contains all usages and notes for this boilerplate.

# Structure

One package is a one mono project. If one or more collections are related each other, you can create a package contains those collections and only those ones.

Root app should mount the package (engine) only. Do not create anything in root app if you don't have specific use case - most of times you don't need to.

# Utils

## Inversion of Control (IoC)

This boilerplate is using [dry-container](https://dry-rb.org/gems/dry-container) and [dry-auto_inject](https://dry-rb.org/gems/dry-auto_inject) to do IoC.

In any package, you should create a file `config/initializers/inversion_container.rb` to register all pacakge's services/jobs/... into IoC's container. And then inject them into class/module that you need to use the services/jobs/...

### Usage

```rb
# packages/admin/app/services/admin/user/filter_users_service.rb
# frozen_string_literal: true

module Admin
  module User
    class FilterUsersService < ::Core::BaseService
      def call
        Auth::User.all
      end
    end
  end
end
```

```rb
# packages/admin/config/initializers/inversion_container.rb
# frozen_string_literal: true

Core::InversionContainer.register('admin_user_filter_users_service') do
  Admin::User::FilterUsersService.new # register this service into Ioc's container from core package
end
```

```rb
# packages/admin/app/controllers/admin/users_controller.rb
# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    # inject admin_user_filter_users_service from container
    # and rename it to filter_users_service for short name
    include Core::Inject[
      filter_users_service: 'admin_user_filter_users_service'
    ]

    def index
      @users = filter_users_service.call
    end
  end
end
```

## Render resource for API

Core package provides a concern render (at `packages/core/app/controllers/concerns/core/render.rb`). This provide a public method `render_resource` to respond the view model to frontend.

It uses [blueprinter](https://github.com/procore/blueprinter) to do serialize the view model.

### Usage

```rb
class UsersController < Core::ApiController
  def index
    users = User.all

    render_resource(users)
  end
end
```

The default `options` will get `UserSerializer` as serializer class. In case you have a different name, you can use

```rb
class UsersController < Core::ApiController
  def index
    users = User.all

    render_resource(users, each_serializer: YourSerializer)
  end
end
```

Options detail:

- `each_serializer`: serializer class for array of resources - default first element class
- `serializer`: serializer class for resource (instance of class) - default resource's class
- `root`: the key of the response with value is the serialized resource(s) - default `:data`
- `module`: a namespace or array of namespaces that the serializer class is belonged to - example `%i[admin provider]` will get `Admin::Provider::UserSerializer`
- `keep_namespace`: in case your model is in a namespace - example Auth::User, the class name will be `Auth::User` and you want to keep `Auth::`, set this by true
