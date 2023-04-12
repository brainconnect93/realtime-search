class ArticlesController < ApplicationController
  before_action :current_user
  def index
    query = params[:query]

    if query.present?
      @articles = Article.where('title LIKE ?', "%#{query}%")

      create_search(query, current_user.id) if @articles.any? && current_user
    else
      @articles = Article.all
    end
    # @articles = @articles.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def create_search(query, user_id)
    return unless query.present? && query.length >= 3

    last_search = Search.where(user_id: user_id).last

    if last_search && last_search.created_at > 1.hour.ago

      if last_search.query != query
        last_search.update(query: query)
      end
    else
      Search.create(query: query, user_id: user_id)
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
