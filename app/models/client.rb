class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :bank_account

  validates :email, uniqueness: true
  validates :registration_number, uniqueness: true
  validates :registration_number, :name, :surname, :birth_date, :email, presence: true
  validates :registration_number, numericality: { only_integer: true }
  validates :registration_number, length: { is: 11 }
  validate :age_over_18_years

  after_create :set_bank_account

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def bank_account_description
    "Agência: #{bank_account.agency_number} Conta: #{bank_account.account_number.insert(-2, '-')}"
  end

  private

  def age_over_18_years
    return unless birth_date && birth_date > 18.years.ago.to_date

    errors.add(:birth_date, :must_be_18_years)
  end

  def set_bank_account
    self.bank_account ||= BankAccount.create
  end
end
