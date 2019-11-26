require "qif"

class QifImporter
  def self.import_transactions(bank_account, filepath)
    qif = Qif::Reader.new(open(filepath))
    transactions = []

    qif.each do |transaction|
      transactions << {
        date: transaction.date,
        amount: transaction.amount,
        status: transaction.status,
        number: transaction.number,
        payee: transaction.payee,
        memo: transaction.memo,
        address: transaction.adress,
        bank_category: transaction.category
      }
    end
    transactions
  end
end
