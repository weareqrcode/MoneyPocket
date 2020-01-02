class ChecksController < ApplicationController
  layout 'frontend'

  def index
    @checks = Check.where.not(jsonb: nil)
  end
end