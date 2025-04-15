class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :name, limit: 510, null: false
      t.string :document_number, limit: 510, null: false
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
