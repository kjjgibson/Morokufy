# == Schema Information
#
# Table name: aliases
#
#  id          :integer          not null, primary key
#  alias_type  :string
#  alias_value :string
#  player_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Alias < ApplicationRecord

  module AliasType
    EMAIL = 'email'
    NAME = 'name'
    USERNAME = 'username'
  end

  validates_presence_of :alias_type, :alias_value

  belongs_to :player

end
