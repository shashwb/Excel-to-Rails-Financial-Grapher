class RemoveModelNameFromFinancialElements < ActiveRecord::Migration
  def change
  	remove_column :financial_elements, :model_name
  end
end
