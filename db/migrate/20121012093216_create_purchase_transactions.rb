class CreatePurchaseTransactions < ActiveRecord::Migration
  def change
    create_table :purchase_transactions do |t|
      t.belongs_to :user_account
      t.string :product_id, null: false
      t.string :product_name, null: false
      t.text :product_description
      t.integer :moola_amount, null: false
      t.string :currency_amount, null: false
      t.string :ref
      t.timestamps
    end
    add_index :purchase_transactions, :user_account_id
  end
end
