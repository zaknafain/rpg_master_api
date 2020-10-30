# frozen_string_literal: true

# Abstract Database Model all other Database Models inherit from
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
