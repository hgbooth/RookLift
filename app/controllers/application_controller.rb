class ApplicationController < ActionController::Base
  before_action(:load_current_user)
  
  # Uncomment this if you want to force users to sign in before any other actions
  # before_action(:force_user_sign_in)
  
  def load_current_user
    the_id = session[:user_id]
    @current_user = User.where({ :id => the_id }).first
  end
  
  def force_user_sign_in
    if @current_user == nil
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    end
  end

 
  def homepage

    render({template: "/homeViews/homepage.html.erb"})  
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
    

  end



end
