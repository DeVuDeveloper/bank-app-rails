class Account < ApplicationRecord
  belongs_to :branch
  belongs_to :accountable, polymorphic: true
  has_many :ownerships, dependent: :destroy

  accepts_nested_attributes_for :accountable, :ownerships, update_only: true

  validate :check_balance
  validate :validate_owners

  # Credits: https://stackoverflow.com/a/32915379/5958455
  def build_accountable(params)
    self.accountable = accountable_type.safe_constantize.new params
  end

  def validate_owners
    errors.add :base, 'There is at least one associated customer' if ownerships.empty?
  end

  def check_balance
    case accountable_type
    when 'DepositAccount'
      errors.add :base, 'Savings accounts do not allow arrears' if balance < 0.0
    when 'CheckAccount'
      if balance + accountable.withdraw_amount < 0.0
        errors.add :base, '
          Checking account arrears are not allowed to exceed the overdraft limit'
      end
    end
  end
end
