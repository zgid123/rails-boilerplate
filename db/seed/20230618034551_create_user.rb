# frozen_string_literal: true

unless Auth::User.find_by(email: 'admin@gmail.com')
  user = Auth::User.create!(email: 'admin@gmail.com', password: '123123')
  user.add_role :admin
end
