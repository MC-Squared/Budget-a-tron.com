class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update]

  def index
    @bank_accounts = current_user.bank_accounts
  end

  def show
    authorize @bank_account
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
    authorize @bank_account
  end

  def update
    authorize @bank_account

    if @bank_account.update(bank_account_params)
      redirect_to bank_account_path(@bank_account), notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:user_id, :name, :bank_number)
  end
end
