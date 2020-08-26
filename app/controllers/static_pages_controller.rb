class StaticPagesController < ApplicationController

    def top
      redirect_to albums_url if user_signed_in?
    end
  
  end
  