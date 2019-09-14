require "webpacker/configuration"

say "Copying angular templateUrl/styleUrls loaders to config/webpack/loaders"
copy_file "#{__dir__}/loaders/angular/html.js", Rails.root.join("config/webpack/loaders/html.js").to_s
copy_file "#{__dir__}/loaders/angular/sass.js", Rails.root.join("config/webpack/loaders/sass.js").to_s
copy_file "#{__dir__}/loaders/angular/typescript.js", Rails.root.join("config/webpack/loaders/typescript.js").to_s

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const html = require('./loaders/html')\n",
  after: /require\(('|")@rails\/webpacker\1\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const sass = require('./loaders/sass')\n",
  after: /require\(('|")@rails\/webpacker\1\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.loaders.insert('html', html)\n",
  after: /environment.loaders.prepend\(('|")typescript\1, typescript\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.loaders.prepend('sass', sass)\n",
  after: /environment.loaders.insert\(('|")html\1, html\);?\n/

say "Updating webpack paths to include .html file extension"
insert_into_file Webpacker.config.config_path,
  "- .html\n".indent(4),
  after: /\s+-\s+\.jpg\n/

say "Copying angular example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/angular/hello_angular.js", "#{Webpacker.config.source_entry_path}/hello_angular.js"

say "Copying hello_angular app to #{Webpacker.config.source_path}"
directory "#{__dir__}/examples/angular/hello_angular", "#{Webpacker.config.source_path}/hello_angular"

say "Installing all angular dependencies"
run "yarn add core-js zone.js rxjs @angular/core @angular/common @angular/compiler @angular/platform-browser @angular/platform-browser-dynamic angular2-template-loader html-loader to-string-loader css-loader sass-loader"

if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 1
  say "You need to enable unsafe-eval rule.", :yellow
  say "This can be done in Rails 5.2+ for development environment in the CSP initializer", :yellow
  say "config/initializers/content_security_policy.rb with a snippet like this:", :yellow
  say "if Rails.env.development?", :yellow
  say "  policy.script_src :self, :https, :unsafe_eval", :yellow
  say "else", :yellow
  say "  policy.script_src :self, :https", :yellow
  say "end", :yellow
end

say "Webpacker now supports angular 🎉", :green
