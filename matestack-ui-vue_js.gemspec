$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "matestack/ui/vue_js/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "matestack-ui-vue_js"
  s.version     = Matestack::Ui::VueJs::VERSION
  s.authors     = ["Jonas Jabari"]
  s.email       = ["jonas@matestack.io"]
  s.homepage    = "https://matestack.io"
  s.summary     = "Escape the frontend hustle & easily create interactive web apps in pure Ruby."
  s.description = "Matestack provides a collection of open source gems made for Ruby on Rails developers. Matestack enables you to craft interactive web UIs without JavaScript in pure Ruby with minimum effort. UI code becomes a native and fun part of your Rails app."
  s.license     = "MIT"
  s.metadata    = { "source_code_uri" => "https://github.com/matestack/matestack-ui-vue_js" }

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", '>= 5.2'
end
