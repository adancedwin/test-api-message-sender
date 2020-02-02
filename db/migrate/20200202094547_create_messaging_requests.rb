class CreateMessagingRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :messaging_requests do |t|
      t.string :message, null: false

      t.timestamps
    end
  end
end
