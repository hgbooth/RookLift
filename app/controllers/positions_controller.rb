class PositionsController < ApplicationController
  def index
    matching_positions = Position.all

    @list_of_positions = matching_positions.order({ :created_at => :desc })

    render({ :template => "positions/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_positions = Position.where({ :id => the_id })

    @the_position = matching_positions.at(0)

    render({ :template => "positions/show.html.erb" })
  end
  
  def countPiece(position, pieceChar)
    res = 0
    splitPos = position.split("")
    res = splitPos.count(pieceChar)
    return res
  end

  def create
    the_position = Position.new
    the_position.fen = params.fetch("query_fen").strip
    the_position.endgame_type = params.fetch("query_endgame_type")

    pos = the_position.fen.split(" ")[0]

    wPawns = countPiece(pos, "P")
    wBishops = countPiece(pos, "B")
    wKnights = countPiece(pos, "N")
    wRooks = countPiece(pos, "R")
    wQueens = countPiece(pos, "Q")
    
    bPawns = countPiece(pos, "p")
    bBishops = countPiece(pos, "b")
    bKnights = countPiece(pos, "n")
    bRooks = countPiece(pos, "r")
    bQueens = countPiece(pos, "q")

    numPawns = wPawns + bPawns
    numBishops = wBishops + bBishops
    numKnights = wKnights + bKnights
    numRooks = wRooks + bRooks
    numQueens = wQueens + bQueens

    totalMaterial = numPawns + 3*numBishops + 3*numKnights + 5*numRooks + 9*numQueens

    the_position.material_count = totalMaterial
    the_position.pawn_present = numPawns > 0
    the_position.bishop_present = numBishops > 0
    the_position.knight_present = numKnights > 0
    the_position.rook_present = numRooks > 0
    the_position.queen_present = numQueens > 0

    the_position.bookmarks_count = 0

    pieces = "K"
    wQueens.times do
      pieces = pieces + "Q"      
    end
    wRooks.times do
      pieces = pieces + "R"      
    end
    wBishops.times do
      pieces = pieces + "B"      
    end
    wKnights.times do
      pieces = pieces + "N"      
    end
    wPawns.times do
      pieces = pieces + "P"      
    end

    pieces = pieces + " v K"

    bQueens.times do
      pieces = pieces + "Q"      
    end
    bRooks.times do
      pieces = pieces + "R"      
    end
    bBishops.times do
      pieces = pieces + "B"      
    end
    bKnights.times do
      pieces = pieces + "N"      
    end
    bPawns.times do
      pieces = pieces + "P"      
    end

    the_position.pieces = pieces 

    if the_position.valid?
      the_position.save
      redirect_to("/positions", { :notice => "Position created successfully." })
    else
      redirect_to("/positions", { :alert => the_position.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_position = Position.where({ :id => the_id }).at(0)

    the_position.fen = params.fetch("query_fen")
    the_position.material_count = params.fetch("query_material_count")
    the_position.pawn_present = params.fetch("query_pawn_present", false)
    the_position.knight_present = params.fetch("query_knight_present", false)
    the_position.bishop_present = params.fetch("query_bishop_present", false)
    the_position.rook_present = params.fetch("query_rook_present", false)
    the_position.queen_present = params.fetch("query_queen_present")
    the_position.bookmarks_count = params.fetch("query_bookmarks_count")

    if the_position.valid?
      the_position.save
      redirect_to("/positions/#{the_position.id}", { :notice => "Position updated successfully."} )
    else
      redirect_to("/positions/#{the_position.id}", { :alert => "Position failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_position = Position.where({ :id => the_id }).at(0)

    the_position.destroy

    redirect_to("/positions", { :notice => "Position deleted successfully."} )
  end
end
