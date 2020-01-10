class TransactionsController < ApplicationController
  layout 'frontend'

  def index
    @transactions = Transaction.all.with_attached_invoice_photo
    @transactionitems = TransactionItem.all
  end
  def prizes
    prize_all
    input = params[:inv_input]
    prize_three = prize_all[0].map { |x| x.scan(/\d{3}$/) }.flatten
    @three_code = prize_three.include?(input)
    @string = prize_all[0].select {|d| d.scan(/\d{3}$/) == [input] }.try(:[], 0)
    @front5 = @string&.scan(/\d{5}/).try(:[], 0)
    @back3 = @string&.scan(/\d{3}$/).try(:[], 0)
  end

  private
  def transaction_params
    params.require(:transactions).premit(:invoice_num, :invoice_photo, :amount, :status, :data)
  end

  def prize_all
    @prizes = Prize.last(2)
    @prizes.map do |x|
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end

end
