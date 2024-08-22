class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, manager: 1 }

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end
end
