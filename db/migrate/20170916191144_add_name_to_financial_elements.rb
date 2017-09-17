class AddNameToFinancialElements < ActiveRecord::Migration
  def change
  	add_column :financial_elements, :name, :string
  end
end
