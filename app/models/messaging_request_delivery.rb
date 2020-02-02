class MessagingRequestDelivery < ApplicationRecord
  include AASM

  RETRY_LIMIT = 4

  belongs_to :messaging_request

  enum messenger_type: {viber: 0, telegram: 1, whatsapp: 2}, _prefix: true
  enum status: {pending: 0, in_progress: 1, delivered: 2, failed: 3, never_delivered: 4}, _prefix: true

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :in_progress
    state :delivered
    state :failed
    state :never_delivered

    event :start do
      transitions from: :pending, to: :in_progress
    end

    event :fail do
      transitions from: :in_progress, to: :failed
    end

    event :retry do
      transitions from: :failed, to: :in_progress
    end

    event :finish_success do
      transitions from: :in_progress, to: :delivered
    end

    event :finish_failure do
      transitions from: :in_progress, to: :never_delivered
    end
  end
end
