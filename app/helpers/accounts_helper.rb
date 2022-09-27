module AccountsHelper
  def account_type_name(s)
    case s
    when 'DepositAccount'
      'Saving Account'
    when 'CheckAccount'
      'Checking Account'
    else
      'Invalid'
    end
  end
end
