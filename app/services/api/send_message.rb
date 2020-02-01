class API::SendMessage
  def execute(send_to, schedule_at: nil, async: false)
    schedule_at = schedule_at ? Time.parse(schedule_at).to_f : nil
    if async
      Sidekiq::Client.push_bulk(
        'queue' => 'messages_sender',
        'class' => SendMessageWorker,
        'at' => schedule_at,
        'retry' => 5,
        'args' => send_to
      )
    else
      API::Wrappers::MessengersStub.new.message(send_to)
    end
  end
end