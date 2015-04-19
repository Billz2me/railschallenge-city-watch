class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :name, null: false
      t.integer :capacity, null: false
      t.string :type, null: false
      t.boolean :on_duty, default: false
      t.string :emergency_code

      t.timestamps null: false
    end

    add_index(:responders, :name, unique: true)
  end
end
