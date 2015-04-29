require './spec/spec_helper'
require './app/models/message'

describe Message do

  it 'should allow us to find individual messengers' do
    expect(Message.find('test_a')).to be_an_instance_of(Message)
  end

  it 'should allow us to find all messengers' do
    expect(Message.all).to be_an_instance_of(Array)
    expect(Message.all.count).to eq(2)
    expect(Message.all.first).to be_an_instance_of(Message)
  end


  context 'with file' do

    let(:message_name) { 'test_a' }
    let(:expected_message_date) { Time.new('2015-04-28 16:30:50 +0100') }
    let(:expected_message_body) { 'This is an example' }
    let(:message) { Message.find(message_name) }

    it 'should parse them' do
      expect(message.name).to eq(message_name)
      expect(message.date).to eq(expected_message_date)
      expect(message.body).to eq(expected_message_body)
    end

  end
end
