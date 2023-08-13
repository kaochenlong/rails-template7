# frozen_string_literal: true

namespace :db do
  desc 'Check if database connection exists'
  task exists: :environment do
    ActiveRecord::Base.connection
  rescue StandardError
    puts 'database connection error'
    exit 1
  else
    puts 'database connection ok!'
    exit 0
  end
end
