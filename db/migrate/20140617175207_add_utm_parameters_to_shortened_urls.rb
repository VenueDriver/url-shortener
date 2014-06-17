class AddUtmParametersToShortenedUrls < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :utm_source, :string
    add_column :shortened_urls, :utm_medium, :string
    add_column :shortened_urls, :utm_term, :string
    add_column :shortened_urls, :utm_content, :string
    add_column :shortened_urls, :utm_name, :string
  end
end
