class TransactionItemsController < ApplicationController

  def index
    @transactionitems = TransactionItem.all
  end

  def new
    @transactionitem = TransactionItem.new
  end
  
  def create
    @transactionitem = TransactionItem.new(item_params)
    if @transaction_item.save
      redirect_to user_transaction_items_path, notice: '完成一筆帳目新增'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @transactionitem.update(item_params)
      redirect_to user_transaction_items_path, notice: '完成一筆帳目更新'
    else
      render :edit
    end
  end

  def destory
    @transactionitem.destory
    redirect_to user_transaction_items_path, notice: '完成一筆帳目刪除'
  end

  private

  def item_params
    clear_params = params.require(:transaction_items).premit(:titel, :quantity, :price, :total)
  end

end
