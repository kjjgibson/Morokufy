module HipChat
  class CardActivity

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # Html for the activity to show in one line a summary of the action that happened
    attr_accessor :html

    # An Icon object
    attr_accessor :icon

    validates_presence_of :html

    def initialize(html)
      @html = html
    end

  end
end