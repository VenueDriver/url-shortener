class ChangeUniqueKeyColumn < ActiveRecord::Migration
  def change
    change_column :shortened_urls, :unique_key, :string, :limit => 512
  end
end
