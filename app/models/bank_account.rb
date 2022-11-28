class BankAccount < ApplicationRecord
  belongs_to :client
  has_many :credits
  has_many :debits

  enum status: { active: 7, closed: 10 }

  validates :account_number, uniqueness: { case_sensitive: false }
  validates :agency_number, :account_number, :balance, presence: true
  validates :agency_number, :account_number, numericality: { only_integer: true, greater_than: 0 }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_agency_and_account_numbers

  def real_balance
    CentsToIntegerConverter.call(balance)
  end

  private

  def generate_agency_and_account_numbers
    self.agency_number ||= SecureRandom.random_number(9999)
    self.account_number ||= SecureRandom.random_number(9999999)
  end
end
