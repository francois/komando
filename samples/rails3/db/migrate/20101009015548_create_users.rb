class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :token, :limit => 40
      t.string :state, :limit => 12, :null => false

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
