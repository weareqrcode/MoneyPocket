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
    # 這邊可以用 full_number.present? 如果是空字串或是 nil 都會回傳 false
    if (full_number != "" && !full_number.nil?)
      all_prize_number = Prize.where("jsonb @> ?", {invoYm: "10810"}.to_json).first.jsonb.filter { |k, v| k =~ /^\w+PrizeNo\d?$/ && v != "" }

      not_spc_prize = all_prize_number.filter { |k, v| !["spcPrizeNo", "superPrizeNo"].include? k }

      six_prize = not_spc_prize.filter {|k, v| v[-3..-1] == full_number[-3..-1] }

      five_prize = not_spc_prize.filter {|k, v| v[-4..-1] == full_number[-4..-1] }

      four_prize = not_spc_prize.filter {|k, v| v[-5..-1] == full_number[-5..-1] }

      three_prize = not_spc_prize.filter {|k, v| v[-6..-1] == full_number[-6..-1] }

      two_prize = not_spc_prize.filter {|k, v| v[-7..-1] == full_number[-7..-1] }

      first_prize = not_spc_prize.filter {|k, v| v == full_number[-8..-1] }

      spc_prize = all_prize_number.filter { |k, v| ["spcPrizeNo"].include? k }.filter {|k, v| v == full_number[-8..-1] }

      super_prize = all_prize_number.filter { |k, v| ["superPrizeNo"].include? k }.filter {|k, v| v == full_number[-8..-1] }

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

  # 這方法被用了三次
  def prize_all
    @prizes = Prize.last(2)
    @prizes.map do |x|

      # 可以寫個註解這在幹嘛，另外 |a, b| 可以改寫 |k, v| 比較知道是 key value 的意思
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }

      # 這行似乎可以改成
      # prize_map = prize_select.map{ |k, v| v}
      # 或甚至
      # prize_map = prize_select.values
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end
end

# x = Prize.first
# prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
# prize_map = prize_select.values


# def comparea(input, answer)
#   i = -2
#   while true
#     i = i-1
#     break if i == -9
#     next if input[i..-1] == answer[i..-1]
#     break
#   end
#   prize_hash = {
#     -3 => "六獎",
#     -4 => "五獎",
#     -5 => "四獎",
#     -6 => "三獎",
#     -7 => "二獎",
#     -8 => "頭獎",
#   }
#   @prize = prize_hash[i+1]
# end


# 算兌獎寫法
# def comparea(input, answer)
#   i = -2
#   while true
#     i = i-1
#     break if i == -9
#     next if input[i..-1] == answer[i..-1]
#     break
#   end
#   i
# end

# result = []
# prize_select = {"spcPrizeNo"=>"58837976", "superPrizeNo"=>"41482012", "firstPrizeNo1"=>"20379435", "firstPrizeNo2"=>"47430762", "firstPrizeNo3"=>"36193504", "sixthPrizeNo1"=>"693", "sixthPrizeNo2"=>"043", "sixthPrizeNo3"=>"425"}
# prize_select.each do |k, v|
#   puts k, v
#   result << comparea('58030976', v)
# end
# prize_hash = {
#   -3 => "六獎",
#   -4 => "五獎",
#   -5 => "四獎",
#   -6 => "三獎",
#   -7 => "二獎",
#   -8 => "頭獎",
# }
# @prize = prize_hash[result.min + 1]
