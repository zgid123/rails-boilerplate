# frozen_string_literal: true

Rolify.configure do |config|
  # By default ORM adapter is ActiveRecord. uncomment to use mongoid
  # config.use_mongoid

  # Dynamic shortcuts for User class (user.is_admin? like methods). Default is: false
  # config.use_dynamic_shortcuts

  # Configuration to remove roles from database once the last resource is removed. Default is: true
  # config.remove_role_if_empty = false
end

module Rolify
  def rolify(options = {})
    include Role
    extend Dynamic if Rolify.dynamic_shortcuts

    options.reverse_merge!({ role_cname: 'Role' })
    self.role_cname = options[:role_cname]
    self.role_table_name = options[:role_table_name] || role_cname.tableize.tr('/', '_')

    default_join_table = "#{(table_name.presence || to_s).tableize.tr('/', '_')}_#{role_table_name}"
    options.reverse_merge!({ role_join_table_name: default_join_table })
    self.role_join_table_name = options[:role_join_table_name]

    rolify_options = { class_name: options[:role_cname].camelize }
    rolify_options[:join_table] = role_join_table_name if Rolify.orm == 'active_record'
    hook_options = %i[before_add after_add before_remove after_remove inverse_of]
    rolify_options.merge!(options.select { |k, _v| hook_options.include?(k.to_sym) })

    has_and_belongs_to_many :roles, **rolify_options

    self.adapter = Rolify::Adapter::Base.create('role_adapter', role_cname, name)

    self.strict_rolify = true if options[:strict]
  end
end
