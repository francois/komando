source :gemcutter

group :development do
  gem "bacon"
  gem "yard"
  gem "jeweler"
  gem "activerecord", "2.3.8"

  platforms :jruby do
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbc-adapter'
    gem 'activerecord-jdbcsqlite3-adapter'
  end

  platforms :ruby do
    gem "bluecloth"
    gem "sqlite3-ruby"
  end
end

# vim: set ft=ruby
