class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @picture = Picture.find(params[:picture_id])
    @comments = @picture.comments.order(created_at: :desc)
    respond_to do |format|
      format.html { redirect_to @picture.album }
      format.js
    end
  end

  def create
    @picture = Picture.find(params[:picture_id])
    current_user.join(@picture.album) unless current_user.joining?(@picture.album)
    @comment = @picture.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.html { redirect_to @picture.album }
      format.js
    end
  end

  private

    def comment_params
      params.permit(:content, :picture_id)
    end
end
