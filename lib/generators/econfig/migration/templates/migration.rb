class CreateEconfig < ActiveRecord::Migration
  def up
    create_table :econfig_options do |t|
      t.string :key, :null => false
      t.string :value
    end
    add_index :econfig_options, :key, :unique => true
  end

  def down
    drop_table :econfig_options
  end
end
