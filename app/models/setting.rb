class Setting < ActiveRecord::Base

  def self.value(key)
    setting = where(key: key).first
    return setting.value unless setting.nil?
    "#{key}-default"
  end

end
