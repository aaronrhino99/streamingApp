class AddDeviseTokenAuthToUsers < ActiveRecord::Migration[8.0]
   def change
    # Only add if column doesn't already exist
    add_column :users, :provider, :string, null: false, default: 'email' unless column_exists?(:users, :provider)
    add_column :users, :uid, :string, null: false, default: '' unless column_exists?(:users, :uid)
    add_column :users, :tokens, :json unless column_exists?(:users, :tokens)

    add_index :users, [:uid, :provider], unique: true unless index_exists?(:users, [:uid, :provider])
  end
end
