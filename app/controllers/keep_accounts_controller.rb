class KeepAccountsController < ApplicationController

  def index
    @transaction_items = Transaction_item.all
  end

  def new
    @transaction_item = Transaction_item.new
  end
  
  def create
    @transaction_item = Transaction_item.new(item_params)
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
    if @transaction_item.update(item_params)
      redirect_to user_transaction_items_path, notice: '完成一筆帳目更新'
    else
      render :edit
  end

  def destory
    @transaction_item.destory
    redirect_to user_transaction_items_path, notice: '完成一筆帳目刪除'
  end

  private

  def item_params
    clear_params = params.require(:transaction_items).premit(:titel, :quantity, :price, :total)
  end

end
