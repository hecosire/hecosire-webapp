class User < ActiveRecord::Base

  acts_as_token_authenticatable

  has_one :last_record, -> { order 'created_at DESC' }, :class_name => 'Record'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def to_s
    email
  end

end
