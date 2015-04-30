require './spec/spec_helper'
require './crier'

describe Crier do

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_redirect, "/ expected to redirect but didn't"
    expect(last_response.location).to include '/messages'
  end

end
