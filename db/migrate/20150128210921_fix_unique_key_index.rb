class FixUniqueKeyIndex < ActiveRecord::Migration
  def up
    remove_index(:shortened_urls, :name => 'index_shortened_urls_on_unique_key')
    add_index(:shortened_urls, [:unique_key, :domain_name], unique: true, :name => 'index_shortened_urls_on_unique_key')
  end
end
