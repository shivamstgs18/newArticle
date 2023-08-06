class PagesController < ApplicationController
  def home
    respond_to do |format|
      format.html 
      format.json { render json: { message: 'Welcome to the home page.' } }
    end
  end

  def about
    respond_to do |format|
      format.html
      format.json { render json: { message: 'This is the about page.' } }
    end
  end
end
