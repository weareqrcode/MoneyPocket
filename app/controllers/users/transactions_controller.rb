class Users::TransactionsController < Users::BaseController
  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  def index
    if (params[:start_date].blank? || params[:end_date].blank?)
      @transactions = current_user.transactions.order('created_at desc')
      @transactionitems = current_user.transaction_items.order('created_at desc')
      @incomes = current_user.incomes.order('created_at desc')
    else
      @transactions = Transaction.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
      @incomes = Income.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
    end

    @incomes_balance = Income.where(
      {created_at: Date.today.beginning_of_month..Date.today.end_of_month}).sum(&:total)
      
    @transactions_balance = Transaction.where(
      {created_at: Date.today.beginning_of_month..Date.today.end_of_month}).sum(&:amount)

    respond_to do |format|
      format.html { render "index" }
      point_json = current_user.transactions.group("created_at::date").count
      income_json = current_user.incomes.group("created_at::date").count
      income_array = income_json.map { |k, v| { :date => k, :count => v } }
      point_array = point_json.map { |k, v| { :date => k, :count => v } }
      main_hash = { income: income_array, point: point_array }
      format.json { render json: main_hash.to_json }
      end

    cot = Transaction.select("created_at")
    @cot = cot.map {|s| s.created_at.strftime('%Y-%m-%d')}
      @cot.each do |x|
        @cc = (((Date.today+11).to_time - (("2019-10-31").to_time))/1.month.second).round(2)
      end
      p @cc
      prize_all
    input = params[:inv_input]
    prize_three = prize_all[0].map { |x| x.scan(/\d{3}$/) }.flatten
    @three_code = prize_three.include?(input)
    @string = prize_all[0].select {|d| d.scan(/\d{3}$/) == [input] }.try(:[], 0)
    @front5 = @string&.scan(/\d{5}/).try(:[], 0)
    @back3 = @string&.scan(/\d{3}$/).try(:[], 0)
  
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
    params.require(:transaction).permit(:invoice_num, :invoice_photo, :amount, :data, transaction_items_attributes: [:id, :title, :quantity, :price, :total, :_destroy])
  end

  def prize_all
    @prizes = Prize.last(2)
    @prizes.map do |x|
      prize_select = x.jsonb.select { |a, b| a =~ /No/ && b != "" }
      prize_map = prize_select.map { |k, y| { :ID => k, :inter => y } }.map { |c| c[:inter] }
    end
  end
end
