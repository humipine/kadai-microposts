class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :destroy, :followings, :followers, :favoritizings]
  before_action :allow_only_the_user, only: [:edit, :update, :destroy]
  
  def edit
    @user = User.find(params[:id])
  end
  
  # indexのメソッド
  def index
    @users = User.all.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    @count_favoritizings = count_favoritizings(current_user)
    
    # 親のメソッドcounts(user)を呼ぶ
    counts(@user)
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      flash[:sucess] = 'Userは正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'Userは更新されませんでした'
      render :edit
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    @count_favoritizings = count_favoritizings(current_user)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    @count_favoritizings = count_favoritizings(current_user)
    counts(@user)
  end
  
  def favoritizings
    @user = User.find(params[:id])
    @microposts = current_user.favoritizings.order('created_at DESC').page(params[:page])
    @count_favoritizings = count_favoritizings(current_user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    # セッション情報を削除
    session[:user_id] = nil
    
    flash[:success] = 'Userは正常に削除されました'
    redirect_to root_url
    
  end
  
  # private 処理
  private
  
  # 【Strong Parameter】
  # 画面から取得するパラーメータを指定して取得
  # ※ password_confirmation : パスワードの確認用入力の値
  def user_params
    params.require(:user).permit(:id, :name, :email, :password, :password_confirmation, :age, :selfintro)
  end

  def allow_only_the_user
    @user = User.find(params[:id])
    
    # ユーザが現在ログイン中のユーザと違う場合には不正アクセスとみなし、root_urlにリダイレクトする 
    unless @user == current_user
      flash[:danger] = '不正なアクセスです'
      redirect_to root_url
    end

  end
  
end