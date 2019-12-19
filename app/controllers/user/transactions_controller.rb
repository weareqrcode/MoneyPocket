class User::TransactionsController < User::BaseController
  def index
    @transactions = Transaction.all
    @transactionitems = TransactionItem.all
  end

  def new
    @transaction = Transaction.new
    @transaction.transaction_items.new
  end
  
  def create
    @transaction = current_user.transactions.new(transaction_params)
    byebug
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
    params.require(:transaction).permit(:invoice_num, :invoice_photo, :amount, :status, :data, transaction_items_attributes: [:title, :quantity, :price, :total])
  end

  # def item_params
  #   clear_params = params.require(:transaction_items).permit(:title, :quantity, :price, :total)
  # end
end
