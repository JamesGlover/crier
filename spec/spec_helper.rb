
ENV['RACK_ENV'] = 'test'

require './lib/filesystem_persister'
require 'rack/test'
require 'rspec'

module RSpecMixin
  include Rack::Test::Methods
  def app(); described_class; end

  ['get','delete','post','put'].each do |protocol|
    eval %Q{
      def #{protocol}_json(path,params={},rake_options={})
        rake_options.merge!({'HTTP_ACCEPT' => 'application/json'})
        #{protocol}(path,params,rake_options)
      end
    }
  end
end

RSpec.configure { |c| c.include RSpecMixin }
