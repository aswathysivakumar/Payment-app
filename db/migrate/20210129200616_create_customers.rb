# For creating customer table
class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string last_name
      t.string email
      t.string phone_number
      t.string iban
      t.string address
      t.string unique_key
      t.boolean active
      t.string bic
      t.string creditor_identifier

      t.timestamps
    end
  end
end
