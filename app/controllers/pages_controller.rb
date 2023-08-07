class PagesController < ApplicationController
  def home
    render json: { message: 'Welcome to the home page.' }
  end

  def about
    render json: { message: 'This is the about page.' }
  end
end
