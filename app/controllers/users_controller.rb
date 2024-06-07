class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 今日の投稿数取得
    @book_count_today = @books.created_today.count
    # 前日の投稿数取得
    @book_count_yesterday = @books.created_yesterday.count
    # 今週の投稿数取得
    @book_count_this_week = @books.created_this_week.count
    # 前週の投稿数取得
    @book_count_last_week = @books.created_last_week.count

    # １週間分の投稿数取得
    @book_count_2day_ago = @books.created_2day_ago.count
    @book_count_3day_ago = @books.created_3day_ago.count
    @book_count_4day_ago = @books.created_4day_ago.count
    @book_count_5day_ago = @books.created_5day_ago.count
    @book_count_6day_ago = @books.created_6day_ago.count
  end

  # 非同期検索用
  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
    render 'search_result'
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
end
