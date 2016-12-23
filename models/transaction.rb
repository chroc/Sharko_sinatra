class Transaction < ActiveRecord::Base

  belongs_to :loan
  belongs_to :user

end
