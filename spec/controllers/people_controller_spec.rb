# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  include_context 'shared context'

  before :each do

    @user=create(:user)
    sign_in @user
  end

  describe 'GET #show' do
    it 'render person show view' do
      get :show, params: { use_route: 'people/', id: person.id }
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end

    it 'render person show view with filter params' do
      get :show, params: { use_route: 'people/', id: person.id, min_amount: 0, max_amount: 10000}
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end

    it 'render person show view with min_amount params' do
      get :show, params: { use_route: 'people/', id: person.id, min_amount: 0}
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end

    it 'render person show view with max_amount params' do
      get :show, params: { use_route: 'people/', id: person.id, max_amount: 10000}
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end
  end
end
