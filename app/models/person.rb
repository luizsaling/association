class Person < ApplicationRecord
  belongs_to :user, optional: true
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, :national_id, presence: true
  validates :national_id, uniqueness: true
  validate :cpf_or_cnpj

  def balance
    total_debts - total_payments
  end

  def total_debts
    debts.sum(:amount)
  end

  def total_payments
    payments.sum(:amount)
  end

  private

  def cpf_or_cnpj
    unless CPF.valid?(national_id) || CNPJ.valid?(national_id)
      errors.add(:national_id, :invalid)
    end
  end
end
