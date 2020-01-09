class ChecksController < ApplicationController
  layout "frontend"
  before_action :prize_all, only: [:index, :prizes]

  def index
    @check = @checks.map { |check| check.jsonb["invoYm"] }
  end

  def prizes
    input = params[:inv_input]
    date_index = params[:optioned].to_i
    prize_three = prize_all[date_index].map { |x| x.scan(/\d{3}$/) }.flatten
    @three_code = prize_three.include?(input)
    @string = prize_all[date_index].select {|d| d.scan(/\d{3}$/) == [input] }.try(:[], 0)
    @front5 = @string&.scan(/\d{5}/).try(:[], 0)
    @back3 = @string&.scan(/\d{3}$/).try(:[], 0)
  end
  
  private

  def prize_all
    @checks = Check.last(3)
    @checks.map do |x|
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end
end
