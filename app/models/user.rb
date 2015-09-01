class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_confirmation_of :email, :on => :create
  validates_presence_of :email, :email_confirmation
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :on => :create, :message => "is invalid"
  validates_uniqueness_of :email
  has_paper_trail
end