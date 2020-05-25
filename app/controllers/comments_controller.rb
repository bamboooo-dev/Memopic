class CommentsController < ApplicationController
  def index
    @picture = Picture.find(params[:picture_id])
    @comments = @picture.comments.order(created_at: :desc)
    respond_to do |format|
      format.html { redirect_to @picture.album }
      format.js
    end
  end
end
