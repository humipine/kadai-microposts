class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build # form_forの新規入力用
      
      # すでに登録済みのレコードを取得
      # @microposts = current_user.microposts.order('created_at DESC').page(params[:page])
      @microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
    end
  end
end
