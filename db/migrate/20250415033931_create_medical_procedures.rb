class CreateMedicalProcedures < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_procedures do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
