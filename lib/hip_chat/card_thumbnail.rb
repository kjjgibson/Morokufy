module HipChat
  class CardThumbnail

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # The thumbnail url
    attr_accessor :url

    # The original width of the image
    attr_accessor :width

    # The thumbnail url in retina
    attr_accessor :url_retina

    # The original height of the image
    attr_accessor :height

    validates_presence_of :url

  end
end