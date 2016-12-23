class User < ActiveRecord::Base
  # User.new({first_name: 'Admin', last_name: 'Admin', email: 'admin@email.com', phone_number: '0414580411', address: 'CBD', user_type: 'admin', user_number: '1037585081', password: 'admin'})
  has_secure_password

  validates :password, confirmation: true

  has_many :loans
  
end
