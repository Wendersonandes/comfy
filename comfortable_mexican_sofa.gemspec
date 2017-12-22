# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'comfortable_mexican_sofa/version'

Gem::Specification.new do |s|
  s.name          = "comfortable_mexican_sofa"
  s.version       = ComfortableMexicanSofa::VERSION
  s.authors       = ["Oleg Khabarov"]
  s.email         = ["oleg@khabarov.ca"]
  s.homepage      = "http://github.com/comfy/comfortable-mexican-sofa"
  s.summary       = "Rails 4/5 CMS Engine"
  s.description   = "ComfortableMexicanSofa is a powerful Rails 4/5 CMS Engine"
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'rails',             '>= 4.0.0', '< 5.1'
  s.add_dependency 'rails-i18n',        '>= 4.0.0'
  s.add_dependency 'bootstrap_form',    '>= 2.2.0'
  s.add_dependency 'active_link_to',    '>= 1.0.0'
  s.add_dependency 'paperclip',         '>= 4.0.0'
  s.add_dependency 'kramdown',          '>= 1.0.0'
  s.add_dependency 'jquery-rails',      '>= 3.0.0'
  s.add_dependency 'jquery-ui-rails',   '>= 5.0.0'
  s.add_dependency 'haml-rails',        '>= 0.3.0'
  s.add_dependency 'sass-rails',        '>= 4.0.3'
  s.add_dependency 'coffee-rails',      '>= 3.1.0'
  s.add_dependency 'codemirror-rails',  '>= 3.0.0'
  s.add_dependency 'bootstrap-sass',    '>= 3.2.0'
  s.add_dependency 'plupload-rails',    '>= 1.2.1'
	s.add_dependency 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
	s.add_dependency 'image_processing'
	s.add_dependency 'mini_magick'
	s.add_dependency 'roda'
	s.add_dependency 'fastimage'
	s.add_dependency 'shrine'
	s.add_dependency 'sucker_punch',			'~> 2.0'
	s.add_dependency "nokogiri",					'>= 1.7.2'
	s.add_dependency 'jquery-fileupload-rails', '>= 0.4.7'
	s.add_dependency 'active_model_serializers', '~> 0.10.5'
	s.add_dependency 'handlebars_assets', '~> 0.23.2'

end
