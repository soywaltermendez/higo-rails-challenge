# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :destroy]

  # GET /people/1
  def show
    @invoice = Person.find(params[:id])
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end
end
