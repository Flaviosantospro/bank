class Credit < ApplicationRecord
  belongs_to :bank_account

  enum credit_type: { deposit: 5, transfer: 10 }

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 200, message: :greater_than_or_equal_to_integer_number }
  validate :check_active_bank_account

  after_create :credit_bank_account_balance

  private

  def check_active_bank_account
    return unless bank_account&.closed?

    errors.add(:bank_account, :closed)
  end

  def credit_bank_account_balance
    bank_account.balance += amount
    bank_account.save!
  end
end
