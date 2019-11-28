class BankTransactionsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_bank_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authorize_bank_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @bank_account = policy_scope(BankAccount)
                      .includes(:bank_transactions)
                      .find(params[:bank_account_id])
  end

  def show
  end

  def new
    @bank_transaction = policy_scope(BankAccount)
                        .find(params[:bank_account_id])
                        .bank_transactions.build
  end

  def edit
  end

  def create
    @bank_transaction = policy_scope(BankAccount)
                          .find(params[:bank_account_id])
                          .bank_transactions
                          .build(bank_transaction_params)

    if @bank_transaction.save
       redirect_to bank_account_bank_transactions_path(@bank_transaction.bank_account, @bank_transaction), notice: 'Bank transaction was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bank_transaction.update(bank_transaction_params)
      redirect_back fallback_location: bank_account_bank_transactions_path(@bank_transaction.bank_account, @bank_transaction), notice: 'Bank transaction was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bank_transaction.destroy
    redirect_to bank_account_bank_transactions_path(@bank_transaction.bank_account), notice: 'Bank transaction was successfully destroyed.'
  end

  private
    def set_bank_transaction
      @bank_transaction = BankTransaction.find(params[:id])
    end

    def authorize_bank_transaction
      authorize @bank_transaction
    end

    def bank_transaction_params
      params.require(:bank_transaction).permit(
        :date,
        :amount,
        :status,
        :number,
        :payee,
        :memo,
        :address,
        :bank_category,
        :category_id)
    end
end
