class CreateMedicalProcedureDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_procedure_details do |t|
      t.decimal :price, precision: 10, scale: 2
      t.references :medical_procedure
      t.timestamps
    end
  end
end
