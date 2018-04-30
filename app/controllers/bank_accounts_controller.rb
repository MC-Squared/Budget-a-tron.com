class BankAccountsController < ApplicationController
  include BankTransactionsCumulativeSums
  include BankTransactionsByCategory
  include BankTransactionsDirectionals
  include DatesPageableByTimespan
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:edit, :update, :destroy]
  before_action :authorize_bank_account, only: [:edit, :update, :destroy]

  def show
    @bank_account = BankAccount.includes(:bank_transactions, :categories).find(params[:id])
    authorize @bank_account

    dates = @bank_account.bank_transactions.get_dates
    @max_page = get_max_page(dates)
    dates = get_dates_for_timespan_page(dates)
    @bank_transactions = @bank_account.bank_transactions.for_date(dates)

    @bank_account_sums = {
      name: @bank_account.name,
      data: calculate_cumulative_sums_by_day(
        bank_transactions: @bank_transactions,
        start_balance: @bank_account.balance_before_date(dates.first)),
    }

    @bank_transactions_by_category = sum_by_category(
      bank_transactions: @bank_transactions
    )

    @bank_transaction_directionals = sum_by_direction(
      bank_transactions: @bank_transactions
    )
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = current_user.bank_accounts.build(bank_account_params)

    if @bank_account.save
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully created.'
    end
  end

  def edit
  end

  def update
    if @bank_account.update(bank_account_params)
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully updated.'
    end
  end

  def destroy
    @bank_account.destroy
    redirect_to dashboard_path, notice: 'Account was successfully destroyed.'
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
