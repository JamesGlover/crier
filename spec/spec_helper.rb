require './lib/filesystem_persister'
require 'rack/test'
require 'rspec'

module RSpecMixin
  include Rack::Test::Methods
  def app(); described_class; end
end

RSpec.configure { |c| c.include RSpecMixin }


FilesystemPersister::Config.configure do |c|

  c.directory = './spec/test_store'

end
