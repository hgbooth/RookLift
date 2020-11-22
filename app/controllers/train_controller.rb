class TrainController < ApplicationController

  def homepage

    users_tags = @current_user.tags
    @users_tag_names = []
    intermediate_hash ={}

    users_tags.each do |a_tag|
      intermediate_hash[a_tag.name] = 0
    end

    @users_tag_names = intermediate_hash.keys

    render({template: "/trainer/homepage.html.erb"})  
  end

  def trainerStart



  end



end