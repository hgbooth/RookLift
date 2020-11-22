# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  bookmarks_count :integer
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bookmark_id     :integer
#  user_id         :integer
#
class Tag < ApplicationRecord

  validates :name, :uniqueness => { :scope => [:bookmark_id] }
  validates :name, :presence => true

  belongs_to(:bookmark, { required: false, class_name: "Bookmark", foreign_key: "bookmark_id" })
  belongs_to(:user, { required: false, class_name: "User", foreign_key: "user_id" })
  has_many(:bookmarks, { class_name: "Bookmark", foreign_key: "tag_id", dependent: :destroy })
end
