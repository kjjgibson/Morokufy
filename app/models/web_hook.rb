# == Schema Information
#
# Table name: web_hooks
#
#  id          :integer          not null, primary key
#  name        :string
#  request_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WebHook < ApplicationRecord

  has_many :web_hook_rules
  has_many :web_hook_alias_keys

  validates_presence_of :name, :request_url
  validates_uniqueness_of :name, :request_url

end
