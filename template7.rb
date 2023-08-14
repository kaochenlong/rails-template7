def set_source_path!
  if __FILE__ =~ %r{\Ahttps?://}
    tempdir = Dir.mktmpdir("rails-template-")
    source_paths.unshift(tempdir)
    at_exit { remove_dir(tempdir) }
    git clone: "--quiet #{SOURCE_REPO} #{tempdir}"
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

set_source_path!

gem_group :development do
  gem 'annotate', '~> 3.2'
  gem 'letter_opener', '~> 1.8'
  gem 'rubocop-rails', '~> 2.20'
end

after_bundle do
  application do <<-CONFIG
    config.generators do |g|
      g.stylesheets false
      g.helper false
      g.test_framework nil
      g.system_tests nil
    end
    CONFIG
  end

  copy_file "variants/.rubocop.yml", ".rubocop.yml"
  copy_file "variants/.prettierrc.json", ".prettierrc.json"
  copy_file "variants/.rspec", ".rspec"
  copy_file "variants/jsconfig.json", "jsconfig.json"

  copy_file "rakefiles/check_db_connection.rake", "lib/tasks/db/check_db_connection.rake"
  copy_file "rakefiles/auto_annotate_models.rake", "lib/tasks/utils/auto_annotate_models.rake"

  copy_file "views/pages/home.html.erb", "app/views/pages/home.html.erb"

  remove_dir "test"

  generate :controller, "pages"
  route "root to: 'pages#home'"

  run "bundle exec rubocop -A"
end
