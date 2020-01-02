class Users::IncomeController < ApplicationController
  def index
    @incomes = Income.all
  end

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.new(income_params)
    if @income.save
      redirect_to users_transactions_path, notice: "完成一筆收入新增"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @income.update(income_params)
      redirect_to users_transactions_path, notice: "完成一筆收入更新"
    else
      render :edit
    end
  end

  private

  def find_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).premit(:id, :title, :description, :total)
  end

end
