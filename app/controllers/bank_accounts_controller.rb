class BankAccountsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]
  before_action :authorize_bank_account, only: [:show, :edit, :update, :destroy]

  def index
    bank_accounts = current_user.bank_accounts.includes(:bank_transactions)
    dates = current_user.bank_transactions.distinct(:date).pluck(:date).sort
    @bank_account_sums = []
    bank_accounts.each do |ba|
      @bank_account_sums << {
        name: ba.name,
        data: calculate_cumulative_sums_by_day(ba, dates),
      }
    end
  end

  def show
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
    params.require(:bank_account).permit(:user_id, :name, :bank_number)
  end

  def calculate_cumulative_sums_by_day(bank_account, dates=[])
    daily_balances = bank_account.bank_transactions.sum_by_day
    dates = daily_balances.keys.sort if dates.empty?

    unless dates.empty?
      daily_balances[dates.first - 1.day] = bank_account.start_balance
    end

    running_total = bank_account.start_balance
    dates.each do |d|
      daily_balances[d] ||= 0
      daily_balances[d] += running_total
      running_total = daily_balances[d]
    end

    daily_balances
  end
end
