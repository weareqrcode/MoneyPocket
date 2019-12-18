class TransactionsController < ApplicationController

  layout 'frontend'

  def index
    @transactions = Transaction.all
    @transactionitems = TransactionItem.all
  end

  def new
    @transaction = Transaction.new
  end
  
  def create
    @transaction = Transaction.new(item_params)
    if @transaction.save
      redirect_to user_transactions_path, notice: '完成一筆帳目新增'
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
      redirect_to user_transactions_path, notice: '完成一筆帳目更新'
    else
      render :edit
    end
  end

  def destory
    @transaction.destory
    redirect_to user_transactions_path, notice: '完成一筆帳目刪除'
  end

  private

  def transaction_params
    clear_params = params.require(:transactions).premit(:invoice_num, :invoice_photo, :amount, :status, :data)
  end

end
