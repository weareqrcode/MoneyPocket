class TransactionsController < ApplicationController
  layout 'frontend'

  def index
  end
  
  def prizes
    prize_all
    input = params[:inv_input]
    full_number = params[:inv_full_number]
    prize_three = prize_all[0].map { |x| x.scan(/\d{3}$/) }.flatten
    @three_code = prize_three.include?(input)
    @string = prize_all[0].select {|d| d.scan(/\d{3}$/) == [input] }.try(:[], 0)
    @front5 = @string&.scan(/\d{5}/).try(:[], 0)
    @back3 = @string&.scan(/\d{3}$/).try(:[], 0)
    @status = false

    if (full_number != "" && !full_number.nil?)
      all_prize_number = Prize.where("jsonb @> ?", {invoYm: "10810"}.to_json)
                              .first.jsonb
                              .filter { |k, v| k =~ /^\w+PrizeNo\d?$/ && v != "" }
      
      not_spc_prize = all_prize_number
                              .filter { |k, v| !["spcPrizeNo", "superPrizeNo"].include? k }

      six_prize = not_spc_prize
                              .filter {|k, v| v[-3..-1] == full_number[-3..-1] }

      five_prize = not_spc_prize
                              .filter {|k, v| v[-4..-1] == full_number[-4..-1] } 

      four_prize = not_spc_prize
                              .filter {|k, v| v[-5..-1] == full_number[-5..-1] } 

      three_prize = not_spc_prize
                              .filter {|k, v| v[-6..-1] == full_number[-6..-1] } 

      two_prize = not_spc_prize
                              .filter {|k, v| v[-7..-1] == full_number[-7..-1] } 

      first_prize = not_spc_prize
                              .filter {|k, v| v == full_number[-8..-1] }

      spc_prize = all_prize_number
                              .filter { |k, v| ["spcPrizeNo"].include? k }
                              .filter {|k, v| v == full_number[-8..-1] }

      super_prize = all_prize_number
                              .filter { |k, v| ["superPrizeNo"].include? k }
                              .filter {|k, v| v == full_number[-8..-1] }

      if not super_prize.empty?
        @front = full_number[0..1]
        @back = super_prize.values[0][-8..-1]
        @status = true
        @prize = "特別獎"
      elsif not spc_prize.empty?
        @front = full_number[0..1]
        @back = spc_prize.values[0][-8..-1]
        @status = true
        @prize = "特獎"
      elsif not first_prize.empty?
        @front = full_number[0..1]
        @back = first_prize.values[0][-8..-1]
        @status = true
        @prize = "頭獎"
      elsif not two_prize.empty?
        @front = full_number[0..-8]
        @back = two_prize.values[0][-7..-1]
        @status = true
        @prize = "二獎"
      elsif not three_prize.empty?
        @front = full_number[0..-7]
        @back = three_prize.values[0][-6..-1]
        @status = true
        @prize = "三獎"
      elsif not four_prize.empty?
        @front = full_number[0..-6]
        @back = four_prize.values[0][-5..-1]
        @status = true
        @prize = "四獎"
      elsif not five_prize.empty?
        @front = full_number[0..-5]
        @back = five_prize.values[0][-4..-1]
        @status = true
        @prize = "五獎"
      elsif not six_prize.empty?
        @front = full_number[0..-4]
        @back = six_prize.values[0][-3..-1]
        @status = true
        @prize = "六獎"
      end
    end
  end

  private
  def prize_all
    @prizes = Prize.last(2)
    @prizes.map do |x|
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end
end