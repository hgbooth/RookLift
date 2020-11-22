Rails.application.routes.draw do

  get("/", {controller: "train", action: "homepage"})
  get("/trainer", {controller: "train", action: "trainerStart"})

  # Routes for the Tag resource:
  post("/insert_tag", { :controller => "tags", :action => "create" })
  # get("/tags", { :controller => "tags", :action => "index" })
  get("/tags/:path_id", { :controller => "tags", :action => "show" })
  post("/modify_tag/:path_id", { :controller => "tags", :action => "update" })
  get("/delete_tag/:path_id", { :controller => "tags", :action => "destroy" })

  #------------------------------

  # Routes for the User account:
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })        
  post("/insert_user", { :controller => "user_authentication", :action => "create"  })
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })       
  post("/modify_user", { :controller => "user_authentication", :action => "update" })
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })

  # ------------------------------

  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })

  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })      

  #------------------------------

  # Routes for the Bookmark resource:
  post("/insert_bookmark", { :controller => "bookmarks", :action => "create" })
  post("/insert_bookmark_from_fen", { :controller => "bookmarks", :action => "create_from_fen" })
  get("/bookmarks", { :controller => "bookmarks", :action => "index" })
  get("/bookmarks/:path_id", { :controller => "bookmarks", :action => "show" })
  post("/modify_bookmark/:path_id", { :controller => "bookmarks", :action => "update" })
   get("/delete_bookmark/:path_id", { :controller => "bookmarks", :action => "destroy" })

  #------------------------------

  # Routes for the Position resource:
  post("/insert_position", { :controller => "positions", :action => "create" })
  get("/positions", { :controller => "positions", :action => "index" })
  get("/positions/:path_id", { :controller => "positions", :action => "show" })
  post("/modify_position/:path_id", { :controller => "positions", :action => "update" })
  get("/delete_position/:path_id", { :controller => "positions", :action => "destroy" })

  #------------------------------

end
