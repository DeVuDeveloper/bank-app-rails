class IssuesController < ApplicationController
  before_action :set_loan, only: %i[create]

  def create
    @issue = Issue.new issue_params

    if @issue.save
      redirect_to loan_issues_url(@loan), success: 'Payment added successfully'
    else
      redirect_to loan_issues_url(@loan), alert: @issue.errors.full_messages.first
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def issue_params
    params.require(:issues).permit(%i[date amount]).merge(loan: @loan)
  end
end
