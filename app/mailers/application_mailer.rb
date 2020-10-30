# frozen_string_literal: true

# Abstract Mailer all other mailers inherit from
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
