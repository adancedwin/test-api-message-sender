class MessagingRequest < ApplicationRecord
  has_many :messaging_request_deliveries, dependent: :delete_all
  accepts_nested_attributes_for :messaging_request_deliveries, allow_destroy: true
end
