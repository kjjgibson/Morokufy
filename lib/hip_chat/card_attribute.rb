module HipChat
  class CardAttribute

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # A CardAttributeValue object
    attr_accessor :value

    # Label for the Attribute
    attr_accessor :label

    validates_presence_of :value

    def initialize(label: nil, value: nil)
      @label = label
      @value = value
    end

  end
end
