# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_key       :string
#  shared_secret :string
#  identifier    :string
#

# The Morokufy player
#
# This class holds data specific to Morokufy about the Player
# We also store the Player's corresponding Game System credentials so that we can perform requests to the Client API on their behalf
# The Player's identifier is a unique value used to identify this Player on the Game Server
# The identifier can ultimately be anything but we just use the first piece of information that we get about a Player
# This might be the player's name, username, email, etc.
# Because we get different data about a Player from each webhook, the Player's aliases allow us to link this data to a Particular Player
# Once we have the Player, we always use the identifier when talking to the Game System
class Player < ApplicationRecord

  validates_presence_of :identifier

  has_many :aliases

end
