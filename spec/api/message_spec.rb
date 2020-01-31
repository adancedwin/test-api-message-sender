require 'rails_helper'

describe '/v1/message' do
  context 'positive tests' do
    context 'send message to Viber' do

    end
    context 'send message to WhatsApp' do

    end
    context 'send message to Telegram' do

    end
    context 'send scheduled message to Viber' do

    end
  end

  context 'negative tests' do
    context 'send empty message with no messenger_type' do

    end
    context 'send message with no type' do

    end
    context 'send message with no uid' do

    end
  end
end