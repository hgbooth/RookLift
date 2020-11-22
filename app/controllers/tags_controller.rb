class TagsController < ApplicationController
  def index
    matching_tags = Tag.all

    @list_of_tags = matching_tags.order({ :created_at => :desc })

    render({ :template => "tags/index.html.erb" })
  end

  def show
    @tag_name = params.fetch("path_id")

    @users_matching_tags = Tag.where({ :name => @tag_name, :user_id => @current_user.id })
    @others_matching_tags = Tag.where({ :name => @tag_name}).where.not({:user_id => @current_user.id })

    # @the_tag = matching_tags

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
