# == Schema Information
#
# Table name: positions
#
#  id              :integer          not null, primary key
#  bishop_present  :boolean
#  bookmarks_count :integer
#  endgame_type    :string
#  fen             :string
#  knight_present  :boolean
#  material_count  :integer
#  pawn_present    :boolean
#  pieces          :string
#  queen_present   :string
#  rook_present    :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Position < ApplicationRecord

  validates :fen, :uniqueness => { :case_sensitive => false }
  validates :fen, :presence => true

  has_many(:bookmarks, { class_name: "Bookmark", foreign_key: "position_id", dependent: :nullify })
  has_many(:users, { through: :bookmarks, source: :user })
end
