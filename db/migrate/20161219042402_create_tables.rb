class CreateTables < ActiveRecord::Migration[5.0]
  def change

    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :user_type
      t.timestamps
    end

    create_table :boxes do |t|
      t.string :name
      t.float :balance
      t.text :description
      t.timestamps
    end

    create_table :loans do |t|
      t.belongs_to :users, index: true
      t.belongs_to :boxes, index: true
      t.float :amount
      t.integer :term
      t.float :interest_fee
      t.float :balance
      t.float :amount_paid
      t.float :interest_paid
      t.boolean :approved
      t.text :description
      t.timestamps
    end

    create_table :transactions do |t|
      t.belongs_to :loans, index: true
      t.belongs_to :users, index: true
      t.date :transaction_date
      t.string :transaction_type
      t.float :amount
      t.integer :fee_number
      t.float :balance_amount
      t.float :interest_amount
      t.float :loan_balance
      t.text :description
      t.timestamps
    end

  end
end
