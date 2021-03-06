class BankAccountsController < ApplicationController
  include BankTransactionsCumulativeSums
  include BankTransactionsByCategory
  include BankTransactionsDirectionals
  include DatesPageableByTimespan
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]
  before_action :authorize_bank_account, only: [:show, :edit, :update, :destroy]
  before_action :set_bank_account_last_date, only: [:show, :edit]

  def show
    dates = @bank_account.bank_transactions.get_sorted_dates
    @max_page = get_max_page(dates)
    dates = get_dates_for_timespan_page(dates)
    unordered_bank_transactions = @bank_account.bank_transactions.includes(:category)
                                        .for_date_range(dates.first, dates.last)

    @bank_account_sums = {
      name: @bank_account.name,
      data: calculate_cumulative_sums_by_day(
        bank_transactions: unordered_bank_transactions.order(date: :asc),
        start_balance: @bank_account.balance_before_date(dates.first)),
      }

    @bank_transactions_by_category = sum_by_category(
      bank_transactions: unordered_bank_transactions
    )

    @bank_transaction_directionals = sum_by_direction(
      bank_transactions: unordered_bank_transactions
    )

    @bank_transactions = unordered_bank_transactions.order(date: :desc)
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

  def set_bank_account_last_date
    @last_balance_date = @bank_account.last_transaction_date
  end

  def bank_account_params
    params.require(:bank_account).permit(:user_id, :name, :bank_number, :last_balance)
  end
end
