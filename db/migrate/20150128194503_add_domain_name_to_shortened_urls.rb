class AddDomainNameToShortenedUrls < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :domain_name, :string
  end
end
