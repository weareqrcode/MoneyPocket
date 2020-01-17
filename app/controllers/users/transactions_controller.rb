class Users::TransactionsController < Users::BaseController
  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  def index
    if (params[:start_date].blank? || params[:end_date].blank?)
      @transactions = current_user.transactions.includes(transaction_items: [:categories]).order('created_at desc') #fixed n+1 problem
      @transactionitems = current_user.transaction_items.order('created_at desc')
      @incomes = current_user.incomes.order('created_at desc')
      @pie_count = @transactionitems.where({created_at: Date.today.beginning_of_month..Date.today.end_of_month})
                                    .unscope(:order)
                                    .joins(:categories)
                                    .select('transaction_items.total', 'categories.tag_name')
                                    .group('categories.tag_name')
                                    .sum('transaction_items.total')
    else
      @transactions = current_user.transactions.where("created_at BETWEEN :start_date AND :end_date", {
        start_date: params[:start_date].to_date, end_date: params[:end_date].to_date}
      )
      @incomes = current_user.incomes.where("created_at BETWEEN :start_date AND :end_date", {
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
      income_json = current_user.incomes.group("created_at::date").count
      income_array = income_json.map { |k, v| { :date => k, :count => v } }
      point_array = point_json.map { |k, v| { :date => k, :count => v } }
      main_hash = { income: income_array, point: point_array }
      format.json { render json: main_hash.to_json }
    end
  end

  def act
    @transactions = current_user.transactions.select("status" == "pending").order(created_at: :desc)
    @transactions.each do |t|
      invoice_num = t.invoice_num.gsub(/\A\w{2}(\d*)\z/,'\\1')
      next if invoice_num.blank?
      month = "#{(t.invoice_date.strftime('%Y').to_i) -1911}#{t.invoice_date.strftime('%m')}"
      month_two = in_two_months?(month, prize_all.keys)
      next if (in_two_months?(month, prize_all.keys)) == false

      result = false
      prize_all[month_two].keys.each do |method|
        num = invoice_num.scan(/\d{#{method}}$/)[0]
        if prize_all[month_two][method].include?(num) && t.status == "pending"
          t.win! 
          result = true
          break
        end
        if t.status == "pending"
          t.miss! unless result
        end
      end
    end
    redirect_to users_transactions_path, notice: "兌獎完成!!!"
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

  def redeem
  end

  private

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end
  
  def transaction_params
    params.require(:transaction).permit(:invoice_num, :invoice_photo, :amount, :data, :invoice_date, transaction_items_attributes: [:id, :title, :quantity, :price, :total, :category_items, :_destroy])
  end

  def prize_all
    @prizes = Prize.last(2).reduce({}) do |rs, pz|
      prize_select = pz.jsonb.select { |a, b| a =~ /No/ && b != "" }
      methods = {
        8 => prize_select.values,
        3 => prize_select.values.map { |pz| pz.scan(/\d{3}$/)[0] }
      }
      rs.merge( pz.jsonb['invoYm'] => methods )
   endg
  end

  def in_two_months?(cur_month, target_month)
    next_month = ((cur_month.to_i) + 1).to_s
    if (cur_month.in?target_month) == true
      cur_month = cur_month
    elsif(next_month.in?target_month) == true
      return cur_month = next_month
    else
      return false
    end
  end
end
