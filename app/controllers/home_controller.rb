class HomeController < ApplicationController

  def homepage

    render({template: "/homeViews/homepage.html.erb"})  
  end

end