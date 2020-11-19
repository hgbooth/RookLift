class BookmarksController < ApplicationController
  def index
    matching_bookmarks = Bookmark.all

    # @list_of_bookmarks = matching_bookmarks.order({ :created_at => :desc })
    @list_of_bookmarks = @current_user.bookmarks.all.order({ :created_at => :desc })


    render({ :template => "bookmarks/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_bookmarks = Bookmark.where({ :id => the_id })

    @the_bookmark = matching_bookmarks.at(0)

    render({ :template => "bookmarks/show.html.erb" })
  end
  
  def create_from_fen
    
    fenInput = params.fetch("query_fen").strip
    typeInput = params.fetch("query_endgame_type")

    if Position.where({fen: fenInput, endgame_type: typeInput}).first == nil

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
      the_bookmark = Bookmark.new
      the_bookmark.position_id = the_position.id
      the_bookmark.user_id = @current_user.id
      the_bookmark.tag_id = 0

      if the_bookmark.valid?
        the_bookmark.save
        redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
      else
        redirect_to("/bookmarks", { :alert => the_bookmark.errors.full_messages.to_sentence })
      end

    else
      redirect_to("/bookmarks", { :alert => the_position.errors.full_messages.to_sentence })
    end
     
    else
      the_position = Position.where({fen: fenInput, endgame_type: typeInput}).first
      
      the_bookmark = Bookmark.new
      the_bookmark.position_id = the_position.id
      the_bookmark.user_id = @current_user.id
      the_bookmark.tag_id = 0

      if the_bookmark.valid?
        the_bookmark.save
        redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
      else
        redirect_to("/bookmarks", { :alert => the_bookmark.errors.full_messages.to_sentence })
      end

    end
  end

  def create
    the_bookmark = Bookmark.new
    the_bookmark.position_id = params.fetch("query_position_id")
    the_bookmark.user_id = params.fetch("query_user_id")
    the_bookmark.tag_id = params.fetch("query_tag_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
    else
      redirect_to("/bookmarks", { :alert => the_bookmark.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.position_id = params.fetch("query_position_id")
    the_bookmark.user_id = params.fetch("query_user_id")
    the_bookmark.tag_id = params.fetch("query_tag_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks/#{the_bookmark.id}", { :notice => "Bookmark updated successfully."} )
    else
      redirect_to("/bookmarks/#{the_bookmark.id}", { :alert => "Bookmark failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.destroy

    redirect_to("/bookmarks", { :notice => "Bookmark deleted successfully."} )
  end
end
