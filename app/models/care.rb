class Care < ActiveRecord::Base
  belongs_to :user
  belongs_to :care_taker, :class_name => 'User'
end
