class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
  end
  
  def create
    # 10.3 → _favoritize_button.html
    @user = current_user
    mic = Micropost.find_by(id: params[:addtofavorite_id])
    @user.favoritize(mic)
    flash[:success] = '投稿をお気に入りに追加しました'
    # redirect_to user_path(current_user)
    @count_favoritizings = count_favoritizings(@user)
    redirect_back(fallback_location: root_path)
    
  end

  def destroy
    @user = current_user
    mic = @user.favoritizings.find_by(id: params[:addtofavorite_id])
    @user.unfavoritize(mic)
    flash[:success] = '投稿をお気に入りから削除しました'
    # redirect_to user_path(current_user)
    @count_favoritizings = count_favoritizings(@user)
    redirect_back(fallback_location: root_path)
  end
  
end
