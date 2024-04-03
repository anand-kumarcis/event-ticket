class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.text :location
      t.datetime :date
      t.string :time
      t.integer :total_tickets
      t.integer :booked_tickets
      t.references :user

      t.timestamps
    end
  end
end
