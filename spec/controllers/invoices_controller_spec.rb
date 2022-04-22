# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  include_context 'shared context'

  before :each do
    @user=create(:user)
    sign_in @user
  end

  describe 'GET #index' do
    it 'render invoice index view' do
      get :index, params: { use_route: 'invoices' }
      expect(response.status).to eq(200)
      expect(response).to render_template("index")
    end
  end

  describe 'GET #show' do
    it 'render invoice show view' do
      invoice = create(:invoice)
      get :show, params: { use_route: 'invoices/', id: invoice.id }
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end
  end

  describe 'GET #new' do
    it 'render invoice show view' do
      get :new, params: { use_route: 'invoices/new' }
      expect(response.status).to eq(200)
      expect(response).to render_template("new")
    end
  end
end
