class AddColumnLoanInterest < ActiveRecord::Migration[5.0]
  def change
    add_column :loans, :interest, :float
  end
end
