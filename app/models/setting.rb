class Setting < ActiveRecord::Base

  def self.value(key)
    value = find_by_key(key).value
    return value unless value.nil?
    "#{key}-default"
  end

end
