class ResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
  	@resources = Resource.page(params[:page]).per(15)
  end


  def show
        @resource = Resource.where(:id => params[:id]).first
  end

  def edit
    @resource = Resource.where(:id => params[:id]).first
  end

  def new
  	@resource = current_user.resources.build
  end


  def update
    @resource = Resource.where(:id => params[:id]).first
    if @resource.update(resources_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end


  def destroy
 	  @toDelete = Resource.where(:id => params[:id]).first
 	  puts @toDelete.id

    if @toDelete.destroy
      flash[:notice] = "Successfully deleted post!"
      redirect_to root_path
    else
      flash[:alert] = "Error updating post!"
    end
  end



  def create
  	@resource= current_user.resources.build(resources_params)

    @filelocation = params[:image]
    puts @filelocation
    @uploader = ImageUploader.new
    @uploader.store!(@filelocation)


  	if @resource.save
    	redirect_to root_path
    	flash[:alert] = "Successfully created new resource!"
    else
      render "new"
    end
    
  end


   def upvote
     @resource = Resource.find(params[:id])
     @resource.upvote_by current_user
     redirect_to :back
   end
 
    def downvote
     @resource = Resource.find(params[:id])
     @resource.downvote_from current_user
     redirect_to :back
   end

   def form 
    file_name = params[:upload][:file].original_filename

    end


 



  private

   def resources_params
 	    params.require(:resource).permit(:title, :url, :description, :image, :tag, :shortdescription)
   end

 end

