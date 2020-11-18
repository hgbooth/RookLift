class PositionsController < ApplicationController
  def index
    matching_positions = Position.all

    @list_of_positions = matching_positions.order({ :created_at => :desc })

    render({ :template => "positions/index.html.erb" })
  end

   # Reads a FEN, and returns a matrix of whether each of the 64 squares are blank or which piece is there
  def parseFen(fen)
    splitFen = fen.split(" ") # ["7B/8/8/8/K1k5/8/8/7N", "w", "-", "-", "0", "1"]
    pos = splitFen[0]
    ranks = pos.split("/")

    curRow = []
    res = []

    ranks.each do |rank|
      curRow = []
      
      splitRank = rank.split("")
      splitRank.each do |c|
        if c.to_i.to_s == c
          c.to_i.times do 
            curRow = curRow.push("blank") 
          end
        else
          curRow = curRow.push(c)
        end

      end
      
      res = res.push(curRow)
    end

    return(res)
  end

  def pieceToImg(piece)
  
    wKing = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Chess_klt45.svg/1024px-Chess_klt45.svg.png"
    bKing = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Chess_kdt45.svg/1024px-Chess_kdt45.svg.png"
    wQueen = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Chess_qlt45.svg/1024px-Chess_qlt45.svg.png"
    bQueen = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Chess_qdt45.svg/1024px-Chess_qdt45.svg.png"
    wRook = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chess_rlt45.svg/1024px-Chess_rlt45.svg.png"
    bRook = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Chess_rdt45.svg/1024px-Chess_rdt45.svg.png"
    wBishop = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Chess_blt45.svg/1024px-Chess_blt45.svg.png"
    bBishop = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Chess_bdt45.svg/1024px-Chess_bdt45.svg.png"
    wKnight = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Chess_nlt45.svg/1024px-Chess_nlt45.svg.png"
    bKnight = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Chess_ndt45.svg/1024px-Chess_ndt45.svg.png"
    wPawn = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Chess_plt45.svg/1024px-Chess_plt45.svg.png"
    bPawn = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Chess_pdt45.svg/1024px-Chess_pdt45.svg.png"

    if piece == "K"
      return(wKing)
    end
    if piece == "k"
      return(bKing)
    end
    if piece == "Q"
      return(wQueen)
    end
    if piece == "q"
      return(bQueen)
    end
    if piece == "B"
      return(wBishop)
    end
    if piece == "b"
      return(bBishop)
    end
    if piece == "N"
      return(wKnight)
    end
    if piece == "n"
      return(bKnight)
    end
    if piece == "P"
      return(wPawn)
    end
    if piece == "p"
      return(bPawn)
    end
    
    return("blank")
    
  end

  def show
    the_id = params.fetch("path_id")

    matching_positions = Position.where({ :id => the_id })

    @the_position = matching_positions.at(0)
    @the_board = parseFen(@the_position.fen)

    @url = pieceToImg(@the_board[0][3])

    (0..7).each do |i|
      (0..7).each do |j|
        @the_board[i][j] = pieceToImg(@the_board[i][j])
      end
    end

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
