# Template Name: Kickoff Vite Rails with WindiCSS
# Author: Andy Leverenz
# Author URI: https://web-crunch.com
# Instructions: $ rails new myapp --skip-webpack-install --skip-javascript -d <postgresql, mysql, sqlite3> -m template.rb

require "fileutils"
require "shellwords"

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("kickoff_vite_rails-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/justalever/kickoff_vite_rails.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{kickoff_vite_rails/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise', '~> 4.7', '>= 4.7.3'
  gem 'friendly_id', '~> 5.4', '>= 5.4.2'
  gem 'sidekiq', '~> 6.2', '>= 6.2.1'
  gem 'name_of_person', '~> 1.1', '>= 1.1.1'
  gem 'vite_rails', '~> 2.0', '>= 2.0.9'
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")
end

def copy_templates
  directory "app", force: true
end

def add_vite
  run 'bundle exec vite install'
  inject_into_file('vite.config.ts', "import FullReload from 'vite-plugin-full-reload'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "import StimulusHMR from 'vite-plugin-stimulus-hmr'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "import WindiCSS from 'vite-plugin-windicss'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "\n    FullReload(['config/routes.rb', 'app/views/**/*']),", after: 'plugins: [')
  inject_into_file('vite.config.ts', "\n    StimulusHMR(),", after: 'plugins: [')
  inject_into_file('vite.config.ts', "\n    WindiCSS({
      root: __dirname,
      scan: {
        fileExtensions: ['erb', 'haml', 'html', 'vue', 'js', 'ts', 'jsx', 'tsx'],
        dirs: ['app/views', 'app/frontend'], // or app/javascript, or app/packs
      },
    }),", after: 'plugins: [')
end

def add_javascript
  run "yarn add trix @rails/actiontext @rails/ujs @rails/activestorage @hotwired/stimulus stimulus-vite-helpers vite-plugin-stimulus-hmr vite-plugin-full-reload typescript vite-plugin-windicss windicss"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_friendly_id
  generate "friendly_id"
end

# Main setup
add_template_repository_to_source_path

source_paths

add_gems

after_bundle do
  add_users
  add_sidekiq
  copy_templates
  add_javascript
  add_vite # adds vite + WindiCSS (Tailwind on Steriods)
  add_friendly_id

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }

  say
  say "Kickoff Vite Rails app successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
end
