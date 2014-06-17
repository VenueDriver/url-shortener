class AddUtmParametersToShortenedUrls < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :utm_source, :String
    add_column :shortened_urls, :utm_medium, :String
    add_column :shortened_urls, :utm_term, :String
    add_column :shortened_urls, :utm_content, :String
    add_column :shortened_urls, :utm_name, :String
  end
end
