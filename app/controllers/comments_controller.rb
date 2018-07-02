class CommentsController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, :only => [:destroy]
    
    def edit
        @product = Product.find(params[:product_id])
        @comment = @product.comments.find(params[:id])
    end

    def create
        @product = Product.find(params[:product_id])
        @comment = @product.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
            redirect_to product_path(@product)
            flash.keep[:notice] = "Created new Comment"
        else
            flash.keep[:alert] = "Something wrong in creating a comment"
            redirect_to product_path(@product)
        end
    end

    def update 
        @product = Product.find(params[:product_id])
        @comment = @product.comments.find(params[:id])
        if @comment.user == current_user
            @comment.update(comment_params)
            if @comment.save
                redirect_to product_path(@product)
                flash.keep[:notice] = "Comment updated"
            else
                render 'edit'
                flash.keep[:alert] = "Comment not updated"
            end
        else
            redirect_to product_path(@product)
            flash.keep[:alert] = "You can't update the Comment"
        end
    end

    def destroy
        @product = Product.find(params[:product_id])
        @comment = @product.comments.find(params[:id])
        if @comment.user == current_user || current_user.admin?
            @comment.destroy
            redirect_to product_path(@product)
            flash.keep[:notice] = "Comment deleted"
        else
            flash.keep[:alert] = "You can't delete the comment"
        end
    end

    
    private
        def comment_params
            params.require(:comment).permit(:title,:text)
        end
end
