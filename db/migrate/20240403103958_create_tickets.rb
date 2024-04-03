class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :user
      t.references :event 
      t.integer :quantity

      t.timestamps
    end
  end
end
