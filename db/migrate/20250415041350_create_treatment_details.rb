class CreateTreatmentDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :treatment_details do |t|
      t.integer :status, default: 0
      t.references :medical_procedure, foreign_key: true, null: false
      t.references :doctor, foreign_key: true, null: false
      t.references :patient, foreign_key: true, null: false
      t.references :treatment, foreign_key: true, null: false
      t.timestamps
    end
  end
end
