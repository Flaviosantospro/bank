class Debit < ApplicationRecord
  belongs_to :bank_account

  enum debit_type: { withdraw: 5, transfer: 10, fee: 15 }

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 200, message: :greater_than_or_equal_to_integer_number }
  validate :check_active_bank_account, :check_bank_account_balance

  after_create :debit_bank_account_balance

  private

  def check_bank_account_balance
    return unless bank_account && bank_account.balance < amount

    errors.add(:bank_account, :insufficient_balance)
  end

  def check_active_bank_account
    return unless bank_account&.closed?

    errors.add(:bank_account, :closed)
  end

  def debit_bank_account_balance
    bank_account.balance -= amount
    bank_account.save!
  end
end
