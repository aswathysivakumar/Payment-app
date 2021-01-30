# For adding payee list
class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.references :customer, index: true
      t.string :name
      t.string :iban
      t.string bic
      t.string creditor_identifier
      t.boolean :active

      t.timestamps
    end
  end
end
