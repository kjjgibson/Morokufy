# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ApplicationRecord

  validates_presence_of :name, :email

end
