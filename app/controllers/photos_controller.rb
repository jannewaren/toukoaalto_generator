class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos/1
  # GET /photos/1.json
  def show
    @emptyphoto = Photo.new
    @photo = Photo.find_by_secret_id(params[:id])
    @top5 = Photo.popular

    @photo.add_to_view_count(1)
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)
    @photo.slug = (photo_params[:start].to_s.mb_chars.downcase+photo_params[:text].to_s.mb_chars.downcase).gsub(/[^a-z0-9äöåÄÖÅ\s]/i, '')
    @photo.views = 0
    @photo.secret_id = Time.now.to_i.to_s + '_' + SecureRandom.hex.to_s
    @photo.url = '/images/'+@photo.secret_id.to_s+'.jpg'

    @photo.addtext(@photo.url.to_s)
    @photo.add_to_view_count(5)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find_by_secret_id(params[:secret_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def photo_params
    params.require(:photo).permit(:text, :start)
  end
end
