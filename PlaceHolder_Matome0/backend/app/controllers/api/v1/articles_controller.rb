module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :set_article, only: [:show, :update, :destroy]

      # GET /api/v1/articles
      def index
        @articles = Article.includes(:article_metadata).all
        render json: @articles.as_json(include: :article_metadata, methods: :formatted_category)
      end

      # GET /api/v1/articles/1
      def show
        render json: @article.as_json(include: :article_metadata)
      end

      # POST /api/v1/articles
      def create
        @article = Article.new(article_params)

        if @article.save
          render json: @article, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/articles/1
      def update
        if @article.update(article_params)
          render json: @article
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/articles/1
      def destroy
        @article.destroy
        head :no_content
      end

      private
        def set_article
          @article = params[:id].match?(/\A\d+\z/) ? 
            Article.find(params[:id]) : 
            Article.find_by(slug: params[:id])
        end

        def article_params
          params.require(:article).permit(:title, :content, :published_at, :slug, :category)
        end
    end
  end
end
