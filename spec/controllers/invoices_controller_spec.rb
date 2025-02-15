# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  include_context 'shared context'

  before :each do
    @user=create(:user)
    sign_in @user
    @file = fixture_file_upload('test.xml', 'text/xml')
    ActiveJob::Base.queue_adapter = :test
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

  describe 'POST #create' do
    it 'render new view with errors' do
      post :create, params: { use_route: 'invoices/' }
      expect(response.status).to eq(200)
      expect(response).to render_template("new")
    end

    it 'create invoice upload job' do
      array_of_files = Array.new
      array_of_files << @file
      post :create, params: { use_route: 'invoices/', xmls: array_of_files }
      expect(InvoiceImportJob)
        .to have_been_enqueued
    end
  end
end
