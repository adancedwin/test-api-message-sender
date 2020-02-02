class CreateMessagingRequestDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :messaging_request_deliveries do |t|
      t.integer :messenger_type, null: false
      t.string :phone_number, null: false
      t.integer :messaging_request_id, null: false
      t.integer :status, null: false
      t.integer :failed_attempts, default: 0, null: false

      t.timestamps
    end
  end
end
