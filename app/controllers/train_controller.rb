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
    param_keys = params.keys
    num_params = param_keys.count()

    @playlist_tags = param_keys[0..num_params-3] # last two params are controller and action, all preceding params are tags

    render({template: "/trainer/test.html.erb"})  
  end

  def trainPosition



  end



end