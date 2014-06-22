class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :only => [:index, :new]


  def index
	  @user = current_user

	  @offers = @user.offers
	  @requests = @user.requests
	  @json = Location.all.to_gmaps4rails
  end

  # GET /profiles
  # GET /profiles.json
  # def index
	 # @post = Post.where(:user_id => current_user.id)
  #
  #
  # end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
	  @profile  = Profile.find(params[:id])
	  unless @profile.gallery.nil?
		  @gallery = @profile.gallery
		  @pictures = @gallery.pictures
	  end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @gallery = @profile.build_gallery
    @pictures = @gallery.pictures
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
	  @profile = Profile.new request_params
	  @profile.build_gallery
	  @pictures = @profile.gallery.pictures


	  respond_to do |format|
		  if @profile.save

			  if params[:images]
				  # The magic is here ;)
				  params[:images].each { |image|
					  @pictures.create(image: image)
				  }
			  end
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :email, :bio, :image_url, gallery_attributes: [:id, :name, :description]).merge(user_id: current_user.id)
    end
end
