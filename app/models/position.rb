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

  validates :fen, :uniqueness => { :case_sensitive => true }
  validates :fen, :presence => true
  validate :fen, :isValidFenFormat

  has_many(:bookmarks, { class_name: "Bookmark", foreign_key: "position_id", dependent: :nullify })
  has_many(:users, { through: :bookmarks, source: :user })

  # (simplified) method to check whether a fen has a valid format
  # checks for 8 ranks and files, with a player to move and move count
  def isValidFenFormat
        
    # starting FEN example: 7B/8/8/8/K1k5/8/8/7N w - - 0 1

    splitFen = fen.split(" ") # ["7B/8/8/8/K1k5/8/8/7N", "w", "-", "-", "0", "1"]

    if splitFen.count() != 6
      errors.add(:fen, "Invalid FEN (FEN should have 6 parts)")
    end

    if (splitFen[1] != "w" && splitFen[1] != "b")
      errors.add(:fen, "Invalid FEN (second part of FEN should be 'w' or 'b'")
    end

    if (splitFen[4].to_i.to_s != splitFen[4] || splitFen[5].to_i.to_s != splitFen[5])
      errors.add(:fen, "Invalid FEN (5th and 6th parts need to be integers)")
    end


  end

  def squishFen(fen)
    return fen.squish
  end

  def countPiece(fen, pieceChar)
    res = 0
    


    return res

  end


end
