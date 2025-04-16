class CreateTreatments < ActiveRecord::Migration[8.0]
  def change
    create_table :treatments do |t|
      t.datetime :performed_at, null: false
      t.timestamps
    end
  end
end
