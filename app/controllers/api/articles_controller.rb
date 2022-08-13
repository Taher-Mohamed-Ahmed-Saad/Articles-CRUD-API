module Api
    class ArticlesController < ApplicationController

        def index
            articles = Article.order('created_at DESC')
            render json: {
                status: 'SUCCESS',
                message: 'Loaded articles',
                data: articles
            }, status: :ok
        end

        def show
            begin
                article = Article.find(params[:id])
                render json: {
                    status: 'SUCCESS',
                    message: 'Loaded article',
                    data: article
                }, status: :ok
            rescue
                render json: {
                    status: 'ERROR',
                    message: "can\'t find article article with id #{params[:id]}",
                }, status: :not_found
            end
        end

        def create
            article = Article.new(article_params)
            if article.save
                render json: {
                    status: 'SUCCESS',
                    message: 'Saved article',
                    data: article
                }, status: :created
            else
                render json: {
                    status: 'ERROR',
                    message: 'Article not added to the database',
                    data: article.errors
                }, status: :bad_request
            end            
        end
        
        def destroy
            begin 
                article = Article.find(params[:id])
                article.destroy
                if article.destroyed?
                    render json: {
                        status: 'SUCCESS',
                        message: 'Article Deleted',
                        data: article
                    }, status: :ok            
                else
                    render json: {
                        status: 'ERROR',
                        message: 'Article not deleted',
                        data: article.errors
                    }, status: :internal_server_error
                end      
            rescue
                render json: {
                    status: 'ERROR',
                    message: 'Article not deleted',
                }, status: :not_found
            end      
        end

        def update
            begin 
                article = Article.find(params[:id])
                if  article.update_attribute( :title , article_params[:title]) and article.update_attribute( :body , article_params[:body]) 
                    render json: {
                        status: 'SUCCESS',
                        message: 'Article updated',
                        data: article
                    }, status: :ok            
                else
                    render json: {
                        status: 'ERROR',
                        message: 'Article not updated',
                        data: article.errors
                    }, status: :internal_server_error
                end      
            rescue
                render json: {
                    status: 'ERROR',
                    message: 'Article not updated',
                }, status: :not_found
            end      
        end

        private
        def article_params
            params.permit(:title, :body)
        end
    end
end