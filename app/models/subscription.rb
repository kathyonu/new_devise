class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  has_paper_trail
end
