require 'sinatra/base'
require 'sinatra/respond_with'

require 'sass'
require 'bootstrap-sass'

require 'sinatra/assetpack'
require './app/models/message'


begin
  require "./config/#{ENV['RACK_ENV'].downcase}"
rescue LoadError
  $stderr.puts '*'*80
  $stderr.puts "No configuration file found for environment '#{ENV['RACK_ENV']}'."
  $stderr.puts "You will need to create a #{ENV['RACK_ENV'].downcase}.rb file in ./config"
  $stderr.puts '*'*80
  Kernel.exit(false)
end

class Crier < Sinatra::Base

  register Sinatra::RespondWith

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

  respond_to :html, :json

  get '/' do
    redirect '/messages'
  end

  get '/messages' do
    respond_with :index, messages:Message.all
  end

  # get '/messages', :provides => 'json' do
  #   erb :index, locals: {messages:Message.all}
  # end


  delete '/messages/:name' do
    message = Message.find(params['name']) || pass
    message.delete
    erb :deleted, locals:{message_name:params['name']}
  end

  put '/messages/:name' do
  end

end
