module LoansHelper
  def status_of(loan)
    case loan.amount_issued
    when 0
      :unissued
    when loan.amount
      :issued
    else
      :issuing
    end
  end

  def status_s(status)
    { unissued: 'Not issued', issuing: 'Issuing', issued: 'Issued' }.fetch status, 'Error'
  end
end
