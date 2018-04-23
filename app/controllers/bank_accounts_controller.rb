class BankAccountsController < ApplicationController
  include BankTransactionCumulativeSums
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:edit, :update, :destroy]
  before_action :authorize_bank_account, only: [:edit, :update, :destroy]

  def index
    bank_accounts = policy_scope(BankAccount).includes(:bank_transactions)
    dates = policy_scope(BankTransaction).distinct(:date).pluck(:date).sort
    @bank_account_sums = []
    bank_accounts.each do |ba|
      @bank_account_sums << {
        name: ba.name,
        data: calculate_cumulative_sums_by_day(
          bank_transactions: ba.bank_transactions,
          start_balance: ba.start_balance,
          dates: dates),
      }
    end

    @bank_transactions_by_category = policy_scope(BankTransaction)
      .sum_by_category
      .map { |cat_sum|
        [
          cat_sum[0].try(:name) || 'No Category',
          cat_sum[1]
        ]
      }
  end

  def show
    @bank_account = BankAccount.includes(:bank_transactions, :categories).find(params[:id])
    authorize @bank_account

    @bank_account_sums = {
      name: @bank_account.name,
      data: calculate_cumulative_sums_by_day(
        bank_transactions: @bank_account.bank_transactions,
        start_balance: @bank_account.start_balance),
    }

    @bank_transactions_by_category = @bank_account.bank_transactions
      .sum_by_category
      .map { |cat_sum|
        [
          cat_sum[0].try(:name) || 'No Category',
          cat_sum[1]
        ]
      }
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = current_user.bank_accounts.build(bank_account_params)

    if @bank_account.save
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bank_account.update(bank_account_params)
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bank_account.destroy
    redirect_to bank_accounts_url, notice: 'Account was successfully destroyed.'
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def authorize_bank_account
    authorize @bank_account
  end

  def bank_account_params
    params.require(:bank_account).permit(:user_id, :name, :bank_number, :start_balance)
  end
end
