# db/migrate/20231128000002_add_risk_factors_to_patients.rb

class AddRiskFactorsToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :risk_factors, :text
  end
end