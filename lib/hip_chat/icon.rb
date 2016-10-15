module HipChat
  class Icon

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # The url where the icon is
    attr_accessor :url

    # The url for the icon in retina
    attr_accessor :url_retina

    validates_presence_of :url

    def initialize(url)
      @url = url
    end

  end
end
