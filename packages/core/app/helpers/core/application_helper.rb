# frozen_string_literal: true

module Core
  module ApplicationHelper
    def format_date(date, format: '%d %B %Y', default_value: '')
      return default_value if date.blank?

      date.strftime(format)
    end
  end
end
