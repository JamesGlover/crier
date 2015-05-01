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
    let(:expected_message_date) { Time.parse('2015-04-28 16:30:50 +0100') }
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
    let(:time_created) { Time.parse('2015-01-01 16:30:00 +0100') }

    let(:new_message) { Message.new(name:new_name,types:new_types,body:new_body) }

    it 'should create a message with the expected options' do
      allow(Time).to receive(:now).and_return(time_created)

      expect(new_message.name).to eq(new_name)
      expect(new_message.date).to eq(time_created)
      expect(new_message.body).to eq(new_body)
      expect(new_message.types).to eq(new_types)
    end


    context 'when updated' do

      let(:updated_body)  { 'updated body'  }
      let(:updated_types) { 'updated_types' }

      let(:original_name) { 'original_message' }
      let(:original_types) { ['warning'] }
      let(:original_body) { 'This is an example message body' }

      let(:original_message) { Message.new(name:original_name,types:original_types,body:original_body) }

      it 'it changes the properties' do

        message = original_message
        updated_message = message.update(body:updated_body,types:updated_types,invalid:'ignore')

        expect(message.body).to eq(updated_body)
        expect(message.types).to eq(updated_types)
        expect(updated_message).to eq(message)
      end

    end

    context 'with invalid names' do
      let(:new_name) { '../new_message' }

      it 'should not save' do
        message = new_message
        expect(message.save).to eq(false)
        expect(message.errors).to eq(['Name can only contain letters, numbers and underscores.'])
      end
    end

    context 'after saving' do

      it 'can be retrieved and deleted' do

        allow(Time).to receive(:now).and_return(time_created)

        new_message.save

        retrieved = Message.find(new_name)

        expect(retrieved.name).to eq(new_name)
        expect(retrieved.date).to eq(time_created)
        expect(retrieved.body).to eq(new_body)
        expect(retrieved.types).to eq(new_types)

        retrieved.delete

        expect(Message.find(new_name)).to be_nil
      end

      # Cleanup if we go wrong
      after do
        Message.find(new_name).delete unless  Message.find(new_name).nil?
      end

    end

  end

end
