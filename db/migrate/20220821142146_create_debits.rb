class CreateDebits < ActiveRecord::Migration[7.0]
  def change
    create_table :debits do |t|
      t.integer :debit_type
      t.integer :amount
      t.references :bank_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
