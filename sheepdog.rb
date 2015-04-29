require 'Sinatra'

require 'sass'
require 'bootstrap-sass'

require 'sinatra/assetpack'
require './app/models/message'

class Sheepdog < Sinatra::Base

  set :server, :puma
  register Sinatra::AssetPack

  set :views, settings.root + '/app/views'

  assets do

    serve '/assets/javascripts', :from => 'app/assets/javascripts'
    serve '/assets/stylesheets', :from => 'app/assets/stylesheets'

    css :application, '/assets/stylesheets/app.css', [
      '/assets/stylesheets/*.css',
    ]

    js :application, '/assets/javascripts/app.js', [
      '/assets/javascripts/jquery.min.js',
      '/assets/javascripts/bootstrap.min.js',
      '/assets/javascripts/application.js'
    ]


    js_compression :jsmin
    css_compression :sass
  end

  get '/' do
    erb :index, locals: {messages:Message.all}
  end

end
