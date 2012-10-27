guard 'sprockets', destination: 'public/compiled', assets_paths: ["assets/javascripts", "assets/stylesheets"] do
  watch (%r{^assets/javascripts/.*}) { |m| "assets/javascripts/application.js.coffee" }
  watch (%r{^assets/stylesheets/.*}) { |m| "assets/stylesheets/application.css.less" }
end
