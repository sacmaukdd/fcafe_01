class Image < ApplicationRecord
  belongs_to :album

  mount_uploader :picture, PictureUploader
end
