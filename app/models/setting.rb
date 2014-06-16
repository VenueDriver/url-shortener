class Setting < ActiveRecord::Base

  def self.value(key)
    value = where(key: key).first
    return value unless value.nil?
    "#{key}-default"
  end

end
