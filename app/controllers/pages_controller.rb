class PagesController < ApplicationController
  def home
  end

  def user_home
  end

  def error
    redirect_to root_path if flash.empty?
  end
end
