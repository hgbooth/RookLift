# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  
  validates :username, :presence => true

  has_many(:bookmarks, { class_name: "Bookmark", foreign_key: "user_id", dependent: :destroy })
  has_many(:tags, { class_name: "Tag", foreign_key: "user_id", dependent: :destroy })
  has_many(:positions, { through: :bookmarks, source: :position })
end
