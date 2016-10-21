# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

Dir.entries(File.join(Rails.root, "app", "assets", "javascripts")).each do |x| 
  if x.include?(".js")
    Rails.application.config.assets.precompile << x
  end
end

Dir.entries(File.join(Rails.root, "app", "assets", "stylesheets")).each do |x| 
  if x.include?(".css")
    Rails.application.config.assets.precompile << x
  end
end
Rails.application.config.assets.precompile += %w( scaffold.css )
Rails.application.config.assets.precompile += %w( filterrific/filterrific-spinner.gif )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
