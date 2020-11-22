# == Schema Information
#
# Table name: bookmarks
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position_id :integer
#  tag_id      :integer
#  user_id     :integer
#
class Bookmark < ApplicationRecord
  
  validates :position_id, :uniqueness => { :case_sensitive => false, :scope => :user_id }
  validates :position_id, :presence => true
  validates :user_id, :presence => true
  
  belongs_to(:position, { required: false, class_name: "Position", foreign_key: "position_id", counter_cache: true })
  has_many(:tags, { class_name: "Tag", foreign_key: "bookmark_id", dependent: :destroy })
  belongs_to(:user, { required: false, class_name: "User", foreign_key: "user_id" })
  belongs_to(:tag, { required: false, class_name: "Tag", foreign_key: "tag_id", counter_cache: true })
end
