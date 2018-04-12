class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bank_accounts = current_user.bank_accounts
  end

  def show
    @bank_account = BankAccount.find(params[:id])
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
    @bank_account = BankAccount.find(params[:id]) #current_user.bank_accounts.find(params[:id])
    # redirect_to root_path unless @bank_account
  end

  def update
    @bank_account = BankAccount.find(params[:id])

    if @bank_account.update(bank_account_params)
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  private

  def bank_account_params
    params.require(:bank_account).permit(:user_id, :name, :bank_number)
  end
end
