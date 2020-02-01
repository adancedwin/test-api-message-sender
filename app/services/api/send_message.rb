class API::SendMessage
  def execute(message, send_to, schedule_at: nil, async: false)
    schedule_at = schedule_at ? Time.parse(schedule_at).to_f : nil
    if async
      Sidekiq::Client.push(
        'queue' => 'messages_sender',
        'class' => SendMessagesWorker,
        'at' => schedule_at,
        'retry' => 5,
        'args' => [message, send_to]
      )
    else
      puts '#############################'
      puts send_to
      puts '#############################'
    end
  end
end