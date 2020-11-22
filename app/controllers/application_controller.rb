class ApplicationController < ActionController::Base
  before_action(:load_current_user)
  
  # Uncomment this if you want to force users to sign in before any other actions
  before_action(:force_user_sign_in)
  
  def load_current_user
    the_id = session[:user_id]
    @current_user = User.where({ :id => the_id }).first
  end
  
  def force_user_sign_in
    if @current_user == nil
      redirect_to("/user_sign_in", { :alert => "You have to sign in first." })
    end
  end

 
  def homepage

    render({template: "/homeViews/homepage.html.erb"})  
  end

  def countPiece(position, pieceChar)
    res = 0
    splitPos = position.split("")
    res = splitPos.count(pieceChar)
    return res
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
    if piece == "R"
      return(wRook)
    end
    if piece == "r"
      return(bRook)
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


end
