class ChecksController < ApplicationController
  layout "frontend"

  def index
    @checks = Check.first.jsonb
  end
end
