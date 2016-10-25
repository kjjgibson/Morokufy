module HipChat
  class CardAttributeValue

    include ActiveModel::Validations
    include ActiveModel::Serialization

    module Style
      LOZENGE_SUCCESS ='lozenge-success'
      LOZENGE_ERROR = 'lozenge-error'
      LOZENGE_CURRENT = 'lozenge-current'
      LOZENGE_COMPLETE = 'lozenge-complete'
      LOZENGE_MOVED = 'lozenge-moved'
      LOZENGE = 'lozenge'
    end

    # Url to be opened when a user clicks on the label
    attr_accessor :url

    # AUI Integrations for now supporting only lozenges
    attr_accessor :style

    # The text representation of the value
    attr_accessor :label

    # An Icon object
    attr_accessor :icon

    validates_presence_of :label

    def initialize(label: nil)
      @label = label
    end

  end
end
