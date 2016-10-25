module HipChat
  class CardDescription

    include ActiveModel::Validations
    include ActiveModel::Serialization

    module ValueFormat
      HTML = 'html'
      TEXT = 'text'
    end

    # A descriptive string
    attr_accessor :value

    # THe format of the value string - the format that can be html or text
    attr_accessor :format

    validates_presence_of :value, :format

    def initialize(value: nil, format: ValueFormat::TEXT)
      @value = value
      @format = format
    end

  end
end
