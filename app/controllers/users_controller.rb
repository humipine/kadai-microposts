class UsersController < ApplicationController
  
  # indexのメソッド
  def index
    @users = User.all.page(params[:page])
    
    if @user.save
      flash[:sucess] = 'ユーザを登録しました。'
      
      # users#show のアクションへリクエストを出す
      # createアクション⇢showアクション⇢showのviewクラス(show.html.erb)が呼ばれる
      redirect_to @user
      
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      
      # リクエストせずレンダリングで新規作成画面(users/new.html.erb)を表示
      render :new
      
    end
  end
  
  def show
    @user = User.find(params[:id])
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
  
  # private 処理
  private
  
  # 【Strong Parameter】
  # 画面から取得するパラーメータを指定して取得
  # ※ password_confirmation : パスワードの確認用入力の値
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end