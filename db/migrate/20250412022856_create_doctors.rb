class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :name, null: false
      t.string :document_number, null: false, index: { unique: true, name: "unique_doctor_documents" }
      t.integer :crm, null: false
      t.string :crm_location, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
