module HipChat
  class Card

    include ActiveModel::Validations
    include ActiveModel::Serialization

    module Style
      FILE = 'file'
      IMAGE = 'image'
      APPLICATION = 'application'
      LINK = 'link'
      MEDIA = 'media'
    end

    module Format
      COMPACT = 'compact'
      MEDIUM = 'medium'
    end

    # Type of the card
    attr_accessor :style

    # Application cards can be compact (1 to 2 lines) or medium (1 to 5 lines)
    attr_accessor :format

    # The url where the card will open
    attr_accessor :url

    # The title of the card
    attr_accessor :title

    # An object with the properties or a thumbnail
    attr_accessor :thumbnail

    # The activity will generate a collapsable card of one line showing the html and the ability to maximize to see all the content.
    attr_accessor :activity

    # List of attributes to show below the card
    attr_accessor :attributes

    # An id that will help HipChat recognise the same card when it is sent multiple times
    attr_accessor :id

    # An icon
    attr_accessor :icon

    attr_accessor :description

    validates_presence_of :style
    validates_presence_of :id
    validates_inclusion_of :style, in: lambda { |_| Style.constants.map { |c| Style.const_get(c) } }
    validates_inclusion_of :format, in: lambda { |_| Format.constants.map { |c| Format.const_get(c) } }

    def initialize(id, style)
      @id = id
      @style = style
    end

  end
end
