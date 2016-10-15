module HipChat
  class RoomNotification

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # Valid values for the 'color' attribute
    module Color
      YELLOW = 'yellow'
      GREEN = 'green'
      RED = 'red'
      PURPLE = 'purple'
      GRAY = 'gray'
      RANDOM = 'random'
    end

    # Valid values for the 'message_format' attribute
    # html - Message is rendered as HTML and receives no special treatment.
    #   Must be valid HTML and entities must be escaped (e.g.: '&amp;' instead of '&').
    #   May contain basic tags: a, b, i, strong, em, br, img, pre, code, lists, tables.
    # text - Message is treated just like a message sent by a user.
    #   Can include @mentions, emoticons, pastes, and auto-detected URLs (Twitter, YouTube, images, etc).
    module MessageFormat
      HTML = 'html'
      TEXT = 'text'
    end

    # A label to be shown in addition to the sender's name. Valid length range: 0 - 64.
    attr_accessor :from

    # Determines how the message is treated by the server and rendered inside HipChat applications
    attr_accessor :message_format

    # Background color for message
    attr_accessor :color

    # Whether this message should trigger a user notification (change the tab color, play a sound, notify mobile phones, etc). Each recipient's notification preferences are taken into account.
    attr_accessor :notify

    # The message body
    attr_accessor :message

    # An optional card object
    attr_accessor :card

    validates :from, length: { minimum: 0, maximum: 64}
    validates_presence_of :message
    validates_inclusion_of :color, in: lambda { |_| Color.constants.map { |c| Color.const_get(c) } }
    validates_inclusion_of :message_format, in: lambda { |_| MessageFormat.constants.map { |c| MessageFormat.const_get(c) } }

    def initialize(message)
      @message = message
    end

  end
end
