class API::SendMessage
  def execute(send_to, schedule_at: nil, async: false)
    if async
      request = add_request_to_db!(send_to)
      send_to.each { |el| el[0].merge!({'request_id' => request.id}) }
      push_bulk_to_worker(send_to, schedule_at)
    else
      send_message_to_messenger!(send_to)
    end
  end

  private

  def add_request_to_db!(send_to)
    request = MessagingRequest.new({message: send_to[0][0]['message']})
    request.save
    request.reload
  end

  def push_bulk_to_worker(send_to, schedule_at)
    schedule_at = schedule_at ? Time.parse(schedule_at).to_f : nil
    Sidekiq::Client.push_bulk(
      'queue' => 'messages_sender',
      'class' => SendMessageWorker,
      'at' => schedule_at,
      'retry' => MessagingRequestDelivery::RETRY_LIMIT,
      'args' => send_to
    )
  end

  def send_message_to_messenger!(send_to)
    add_delivery_to_db!(send_to)
    API::Wrappers::MessengersStub.new(send_to).message
  end

  def add_delivery_to_db!(send_to)
    delivery = MessagingRequestDelivery.exists?(
                                                messaging_request_id: send_to['request_id'],
                                                messenger_type: send_to['messenger_type']
                                              )

    unless delivery
      request = MessagingRequest.find(send_to['request_id'])
      request.messaging_request_deliveries.build(
        {
          messenger_type: send_to['messenger_type'],
          phone_number: send_to['phone_number'],
          status: 'pending'
        })
      request.save
    end
  end
end