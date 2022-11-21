class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.integer :status, default: 5
      t.string :agency_number
      t.string :account_number
      t.integer :balance, default: 0
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
