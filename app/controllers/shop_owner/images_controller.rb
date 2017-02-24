class ShopOwner::ImagesController < ApplicationController
  layout "shop_owner_layout"
  skip_before_action :verify_authenticity_token

  def create
    @image = Image.new image_param
    @album = Album.find_by id: params[:album_id]
    unless @album
      flash[:danger] = t ".album_not_found"
      redirect_to :back
    end
    @images = @album.images
    @shop = Shop.find_by id: @album.id
    if @image.save
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t ".image_not_create"
      redirect_to :back
    end
  end

  def image_param
    params.require(:image).permit :picture, :album_id
  end
end
