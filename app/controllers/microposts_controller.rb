class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
  end
  # GET /microposts/new
  def new
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      # sucessful
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      # not sucessful put error message and take to home page
      @feed_items = []
      render "static_pages/home"
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
  end
  
  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
