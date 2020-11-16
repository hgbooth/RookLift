Rails.application.routes.draw do

  get("/", {controller: "application", action: "homepage"})

  # Routes for the Tag resource:
  post("/insert_tag", { :controller => "tags", :action => "create" })
  get("/tags", { :controller => "tags", :action => "index" })
  get("/tags/:path_id", { :controller => "tags", :action => "show" })
  post("/modify_tag/:path_id", { :controller => "tags", :action => "update" })
  get("/delete_tag/:path_id", { :controller => "tags", :action => "destroy" })

  #------------------------------

  # Routes for the User account:
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })        
  post("/insert_user", { :controller => "user_authentication", :action => "create"  })
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })       
  # UPDATE RECORD
  post("/modify_user", { :controller => "user_authentication", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })
             
  #------------------------------

  # Routes for the Bookmark resource:

  # CREATE
  post("/insert_bookmark", { :controller => "bookmarks", :action => "create" })
          
  # READ
  get("/bookmarks", { :controller => "bookmarks", :action => "index" })
  
  get("/bookmarks/:path_id", { :controller => "bookmarks", :action => "show" })
  
  # UPDATE
  
  post("/modify_bookmark/:path_id", { :controller => "bookmarks", :action => "update" })
  
  # DELETE
  get("/delete_bookmark/:path_id", { :controller => "bookmarks", :action => "destroy" })

  #------------------------------

  # Routes for the Position resource:

  # CREATE
  post("/insert_position", { :controller => "positions", :action => "create" })
          
  # READ
  get("/positions", { :controller => "positions", :action => "index" })
  
  get("/positions/:path_id", { :controller => "positions", :action => "show" })
  
  # UPDATE
  
  post("/modify_position/:path_id", { :controller => "positions", :action => "update" })
  
  # DELETE
  get("/delete_position/:path_id", { :controller => "positions", :action => "destroy" })

  #------------------------------

end
