# frozen_string_literal: true

Core::InversionContainer.register('admin_user_filter_users_service') do
  Admin::User::FilterUsersService.new
end
