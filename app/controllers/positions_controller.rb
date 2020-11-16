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
  
  def create
    the_position = Position.new
    the_position.fen = params.fetch("query_fen").strip
    the_position.endgame_type = params.fetch("query_endgame_type")

    the_position.bookmarks_count = 0

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
