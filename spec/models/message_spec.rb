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
    let(:expected_message_title) { 'Test a' }
    let(:expected_message_date) { Time.new('2015-04-28 16:30:50 +0100') }
    let(:expected_message_body) { 'This is an example' }
    let(:expected_message_types) { ['warning', 'status'] }
    let(:expected_message_css_classes) { 'panel-warning panel-status' }
    let(:message) { Message.find(message_name) }

    it 'should parse them' do
      expect(message.name   ).to eq(message_name)
      expect(message.title  ).to eq(expected_message_title)
      expect(message.date   ).to eq(expected_message_date)
      expect(message.body   ).to eq(expected_message_body)
      expect(message.types  ).to eq(expected_message_types)
      expect(message.classes).to eq(expected_message_css_classes)
    end

  end

 context 'creating a new message' do

  let(:new_name) { 'new_message' }
  let(:new_types) { ['warning'] }
  let(:new_body) { 'This is an example message body' }
  let(:time_created) { Time.new('2015-01-01 16:30:00 +0100') }

  let(:new_message) { Message.new(name:new_name,types:new_types,body:new_body) }

  it 'should create a message with the expected options' do
    allow(Time).to receive(:now).and_return(time_created)

    expect(new_message.name).to eq(new_name)
    expect(new_message.date).to eq(time_created)
    expect(new_message.body).to eq(new_body)
    expect(new_message.types).to eq(new_types)
  end

  context 'after saving' do

    it 'can be retrieved and deleted' do

      new_message.save

      retrieved = Message.find(new_name)

      expect(retrieved.name).to eq(new_name)
      expect(retrieved.date).to eq(time_created)
      expect(retrieved.body).to eq(new_body)
      expect(retrieved.types).to eq(new_types)

      retrieved.delete

      expect(Message.find(new_name)).to be_nil
    end

  end

 end

end
