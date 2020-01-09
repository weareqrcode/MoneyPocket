class TransactionsController < ApplicationController
  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  layout 'frontend'

  def index
    @transactions = Transaction.all.with_attached_invoice_photo
    @transactionitems = TransactionItem.all
  end

  def new
    @transaction = Transaction.new
  end
  
  def create
    @transaction = Transaction.new(item_params)
    if @transaction.save
      redirect_to users_transactions_path, notice: '完成一筆帳目新增'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to users_transactions_path, notice: '完成一筆帳目更新'
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to users_transactions_path, notice: '完成一筆帳目刪除'
  end
  
  def prizes
    prize_all
    input = params[:inv_input]
    prize_three = prize_all[0].map { |x| x.scan(/\d{3}$/) }.flatten
    @three_code = prize_three.include?(input)
    @string = prize_all[0].select {|d| d.scan(/\d{3}$/) == [input] }.try(:[], 0)
    @front5 = @string&.scan(/\d{5}/).try(:[], 0)
    @back3 = @string&.scan(/\d{3}$/).try(:[], 0)
    p prize_all[0]
  end

  private

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transactions).premit(:invoice_num, :invoice_photo, :amount, :status, :data)
  end

  def prize_all
    @checks = Check.last(2)
    @checks.map do |x|
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end

end
