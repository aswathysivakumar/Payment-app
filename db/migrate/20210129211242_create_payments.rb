# For creating payment model
class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :customer, index: true
      t.references :recipient, index: true
      t.float :amount
      t.string :currency
      t.status :string

      t.timestamps
    end
  end
end
