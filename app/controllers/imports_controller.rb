class ImportsController < ApplicationController
  def create
    @bank_account = policy_scope(BankAccount).find(params[:bank_account_id])

    file = params[:file]
    if file.blank?
      flash.alert = 'No file selected.'
      redirect_to bank_account_path(@bank_account)
      return
    end

    transactions = QIFImport.import_transactions(@bank_account, file.path)

    new_transactions = remove_old_transactions(transactions)
    if save_all_transactions(new_transactions)
      flash.notice = "Imported #{new_transactions.count} transactions. " +
        "(#{transactions.count - new_transactions.count} duplicates skipped.)"
    else
      flash.alert = "Error importing transactions"
    end
    redirect_to bank_account_path(@bank_account)
  end

  private

  def remove_old_transactions(transactions)
    new_transactions = []
    transactions.each do |trans_hash|
      trans = @bank_account.bank_transactions.build(trans_hash)
      new_transactions << trans unless BankTransaction.exists?(trans_hash)
    end
    new_transactions
  end

  def save_all_transactions(transactions)
    transactions.each do |t|
      unless t.save
        return false
      end
    end
    true
  end
end
