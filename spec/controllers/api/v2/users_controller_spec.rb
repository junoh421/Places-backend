require 'spec_helper'

RSpec.describe Api::V2::UsersController, type: :controller do

  let(:show_params) {{
    data: {
      username: User.first.username
    },
    format: :json
   }
  }

	describe 'show' do 
    get 'show', :params => show_params
    expect(response).to be_success
    json = JSON.parse(response.body)
	end
end