class User < ActiveRecord::Base

  acts_as_token_authenticatable

  has_one :last_record, -> { order 'created_at DESC' }, :class_name => 'Record'

  has_many :care
  has_many :care_takers, :through => :care

  has_many :inverse_care, :class_name => "Care", :foreign_key => "care_taker_id"
  has_many :care_receivers, :through => :inverse_care, :source => :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  def to_s
    email
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.provider= auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20] unless user.password.present?
    end
  end

end
