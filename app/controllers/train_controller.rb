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

    if num_params == 2 # controller and action are only keys in params, need to throw error

      redirect_to("/", { :alert => "You must select at least one tag in order to train"})
    
    else # there are tags selected
      
      playlist_tags = param_keys[0..num_params-3] # last two params are controller and action, all preceding params are tags
      cookies.store(:playlist_tags, playlist_tags)

      redirect_to("/trainRandom")

    end
    
  end

  def trainPosition
    @playlistTags = cookies.fetch(:playlist_tags).split("&") # all tags in playlist, stored as names in array in cookies

    @playlistPositions = []
    Tag.where({ user_id: @current_user.id, name: @playlistTags}).each do |a_tag|
      @playlistPositions.push(a_tag.bookmark.position.fen)
    end

    @curPosition = Position.where({ fen: @playlistPositions.sample() }).first

    @the_board = parseFen(@curPosition.fen)
    
    @the_images = []
    (0..7).each do |i|
      @the_images = @the_images.push([])
      (0..7).each do |j|
        @the_images[i] = @the_images[i].push(pieceToImg(@the_board[i][j]))
      end
    end
    
    
    render({template: "/trainer/playlistPosition.html.erb"})  

  end

  def playAIWhite

    curFEN = "8/1k6/1p6/r7/8/3K4/2Q5/8 w - - 0 1"

    response = HTTParty.post('https://lichess.org/api/challenge/ai', {
      headers: {"Authorization" => "Bearer " + ENV.fetch("LICHESS_API_TOKEN")},
      body: {"level" => 8}
    })

    # redirect_to(#lichess)
    render({plain: response}) 
  end





end