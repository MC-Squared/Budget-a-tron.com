class CategoriesController < ApplicationController
  include BankTransactionsDirectionals
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :authorize_category, only: [:edit, :update, :destroy]

  def show
    @category = Category.includes(:category_rules, :bank_transactions)
                        .find(params[:id])
    authorize_category

    @bank_transaction_sums = {
      name: @category.name,
      data: @category.bank_transactions.sum_by_day,
    }

    @bank_transaction_directionals = sum_by_direction(
      bank_transactions: @category.bank_transactions
    )
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
       redirect_to @category, notice: 'Category was successfully created.'
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    end
  end

  def destroy
    @category.destroy
    redirect_to dashboard_path, notice: 'Category was successfully destroyed.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def authorize_category
    authorize @category
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
