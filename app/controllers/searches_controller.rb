class SearchesController < ApplicationController
    def index
        @searches = Search.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(10)
    end
end
