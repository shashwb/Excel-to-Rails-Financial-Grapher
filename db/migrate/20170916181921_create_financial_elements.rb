class CreateFinancialElements < ActiveRecord::Migration
  def change
    create_table :financial_elements do |t|
      t.date :day
      t.string :model_name
      t.float :model_value

      t.timestamps null: false
    end
  end
end
