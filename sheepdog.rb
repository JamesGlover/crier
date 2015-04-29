require 'Sinatra'
require 'sinatra/assetpack'

class Sheepdog < Sinatra::Base

  set :server, :puma
  register Sinatra::AssetPack

  get '/' do
    "Woo Hoo"
  end

end
