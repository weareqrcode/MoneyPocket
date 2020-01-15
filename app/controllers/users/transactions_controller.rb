class Users::TransactionsController < Users::BaseController
  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  def index
    if (params[:start_date].blank? || params[:end_date].blank?)
      @transactions = current_user.transactions.includes(transaction_items: [:categories]).order('created_at desc') #fixed n+1 problem
      @transactionitems = current_user.transaction_items.order('created_at desc')
      @incomes = current_user.incomes.order('created_at desc')
      # @categories = current_user.transaction_items.categories
    else
      @transactions = current_user.transactions.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
      @incomes = current_user.incomes.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
      @categories = current_user.transaction_items.categories.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
    end

    @incomes_balance = current_user.incomes.where(
      {created_at: Date.today.beginning_of_month..Date.today.end_of_month}).sum(&:total)
      
    @transactions_balance = current_user.transactions.where(
      {created_at: Date.today.beginning_of_month..Date.today.end_of_month}).sum(&:amount)

    respond_to do |format|
      format.html { render "index" }
      point_json = current_user.transactions.group("created_at::date").count
      date_hash = point_json.map { |k, v| { :date => k, :count => v } }
      format.json { render json: date_hash.to_json }
    end

  end

  def new
    @transaction = Transaction.new
    @transaction.transaction_items.new
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if @transaction.save
      redirect_to users_transactions_path, notice: "完成一筆帳目新增"
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
      redirect_to users_transactions_path, notice: "完成一筆帳目更新"
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to users_transactions_path, notice: "完成一筆帳目刪除"
  end

  private

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end
  
  def transaction_params
    params.require(:transaction).permit(:invoice_num, :invoice_photo, :amount, :data, transaction_items_attributes: [:id, :title, :quantity, :price, :total, :category_items, :_destroy])
  end

end
