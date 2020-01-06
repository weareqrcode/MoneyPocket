class ChecksController < ApplicationController
  layout "frontend"

  def index
    @checks = Check.first.jsonb
    respond_to do |check|
      check.html { render "index" }
      prize = @checks.select { |a, b| a =~ /No/ && b != ""}
      prize_map = prize.map { |k, y| {:ID => k , :inter => y}}
      check.json { render json: prize_map.to_json }
    end
  end
end
