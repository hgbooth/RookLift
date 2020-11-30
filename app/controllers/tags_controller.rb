class TagsController < ApplicationController
  def index
    matching_tags = Tag.all

    @list_of_tags = matching_tags.order({ :created_at => :desc })

    render({ :template => "tags/index.html.erb" })
  end

  def show
    @tag_name = params.fetch("path_id")

    user_tags = Tag.where({ :name => @tag_name, :user_id => @current_user.id })
    other_tags = Tag.where({ :name => @tag_name}).where.not({:user_id => @current_user.id })
    
    @users_matching_tags = []
    @others_matching_tags = []

    user_tags.each do |a_tag|
      curRow = {}
      curRow["id"] = a_tag.id
      curRow["bookmarkId"] = a_tag.bookmark.id

      the_board = parseFen(a_tag.bookmark.position.fen)
    
      the_images = []
      (0..7).each do |i|
        the_images = the_images.push([])
        (0..7).each do |j|
          the_images[i] = the_images[i].push(pieceToImg(the_board[i][j]))
        end
      end

      curRow["the_board"] = the_board
      curRow["the_images"] = the_images

      @users_matching_tags = @users_matching_tags.push(curRow)
    end

    
    other_tags.each do |a_tag|
      curRow = {}
      curRow["id"] = a_tag.id
      curRow["positionId"] = a_tag.bookmark.position.id

      the_board = parseFen(a_tag.bookmark.position.fen)
    
      the_images = []
      (0..7).each do |i|
        the_images = the_images.push([])
        (0..7).each do |j|
          the_images[i] = the_images[i].push(pieceToImg(the_board[i][j]))
        end
      end

      curRow["the_board"] = the_board
      curRow["the_images"] = the_images

      @others_matching_tags = @others_matching_tags.push(curRow)
    end

    render({ :template => "tags/show.html.erb" })
  end

  def create
    the_tag = Tag.new
    the_tag.bookmark_id = params.fetch("query_bookmark_id")
    the_tag.user_id = params.fetch("query_user_id")
    the_tag.name = params.fetch("query_name").downcase

    if the_tag.valid?
      the_tag.save
      redirect_to("/bookmarks", { :notice => "Tag created successfully." })
    else
      redirect_to("/bookmarks", { :alert => the_tag.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_tag = Tag.where({ :id => the_id }).at(0)

    the_tag.bookmark_id = params.fetch("query_bookmark_id")
    the_tag.user_id = params.fetch("query_user_id")
    the_tag.name = params.fetch("query_name")

    if the_tag.valid?
      the_tag.save
      redirect_to("/tags/#{the_tag.id}", { :notice => "Tag updated successfully."} )
    else
      redirect_to("/tags/#{the_tag.id}", { :alert => "Tag failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_tag = Tag.where({ :id => the_id }).at(0)

    the_tag.destroy

    redirect_to("/bookmarks", { :notice => "Tag deleted successfully."} )
  end
end
