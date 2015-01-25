# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
#Rails.application.config.assets.precompile += %w( dist/flat-ui.css )
#Rails.application.config.assets.precompile += %w( flat-ui/switch/mask.png )
#Rails.application.config.assets.precompile += %w( flat-ui/tile/ribbon.png )
#Rails.application.config.assets.precompile += %w( flat-ui/tile/ribbon-2x.png )
#Rails.application.config.assets.precompile += %w( flat-ui/todo/todo.png )
#Rails.application.config.assets.precompile += %w( flat-ui/todo/done.png )
#Rails.application.config.assets.precompile += %w( flat-ui/*)
Rails.application.config.assets.precompile += %w( recipes.css )
Rails.application.config.assets.precompile += %w( home.css )
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
