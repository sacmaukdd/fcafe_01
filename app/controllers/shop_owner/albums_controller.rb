class ShopOwner::AlbumsController < ApplicationController
  layout "shop_owner_layout"

  before_action :authenticate_user!
  before_action :load_album, only: [:edit, :update, :destroy, :show]
  before_action :load_image, only: :update

  def index
    @album = Album.new
    @albums = Album.order_date_desc.album_by_shop(params[:shop_id])
      .paginate page: params[:page], per_page: Settings.per_page
    @shop_id = params[:shop_id]
  end

  def show
    @image = Image.new
    @images = @album.images
    @shop = Shop.find_by id: @album.shop_id
  end

  def create
    ActiveRecord::Base.transaction do
      @album = Album.new album_params
      if @album.save
        image_param.each do |img|
          image = Image.create! picture: img, album_id: @album.id
        end
        flash[:success] = t ".create_complete"
      else
        flash[:danger] = t ".not_create"
      end
      redirect_to :back
    end
    rescue
      flash[:danger] = t ".can_not_create"
      redirect_to :back
  end

  def edit
    @edit_page = params[:action]
  end

  def update
      if @album.update_attributes album_params
        flash[:success] = t ".album_updated"
      else
        flash[:danger] = t ".album_not_update"
      end
      redirect_to shop_owner_shop_albums_path(shop_id: @album.shop_id)
  end

  def destroy
    if @album.destroy
      flash[:success] = t "del_complete"
    else
      flash[:danger] = t "not_delete"
    end
    redirect_to :back
  end

  private
  def album_params
    params.require(:album).permit :name, :shop_id
  end

  def load_album
    @album = Album.find_by id: params[:id]
    unless @album
      flash[:danger] = t "album_not_found"
      redirect_to :back
    end
  end


  def load_image
    @image = Image.where album_id: @album.id
    unless @image
      flash[:danger] = t "image_not_found"
      redirect_to :back
    end
  end
end
