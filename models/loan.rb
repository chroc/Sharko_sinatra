class Loan < ActiveRecord::Base

  belongs_to :user
  belongs_to :box

  has_many :transactions

end
