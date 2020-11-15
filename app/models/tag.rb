# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  bookmark_id :integer
#  user_id     :integer
#
class Tag < ApplicationRecord

  belongs_to(:user, { required: false, class_name: "User", foreign_key: "user_id" })
  has_many(:bookmarks, { class_name: "Bookmark", foreign_key: "tag_id", dependent: :destroy })
end
