module ClientsHelper
  include AccountsHelper

  MANAGER_TYPE_NAMES = %w[UnspecifiedLoan PersonInCharge BankAccountPersonInCharge
                          BothLoanPersonInChargeAndBankAccountPersonInCharge]
  MANAGER_TYPE_NAMES_SHORT = %w[UnspecifiedLoanBankAccount Loan + Bank Account]

  private_constant :MANAGER_TYPE_NAMES, :MANAGER_TYPE_NAMES_SHORT

  def contact_fields
    ContactsHelper.fields
  end

  def contact_fields_with_name
    ContactsHelper.fields_with_name
  end

  def manager_type_name(manager_type)
    MANAGER_TYPE_NAMES[manager_type]
  rescue StandardError
    'Invalid value'
  end

  def manager_type_name_short(manager_type)
    MANAGER_TYPE_NAMES_SHORT[manager_type]
  rescue StandardError
    'Invalid value'
  end

  def manager_types_with_name
    MANAGER_TYPE_NAMES.each_with_index.to_a
  end
end
