require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '.build_made' do
    it 'should return 200' do
      post :create

      expect(response.response_code).to eq(200)
    end
  end

end