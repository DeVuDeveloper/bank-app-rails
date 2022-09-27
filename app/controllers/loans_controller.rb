class LoansController < ApplicationController
  include LoansHelper

  before_action :set_loan,
                only: %i[show issues clients add_client destroy_client destroy]
  before_action :set_issues, only: [:issues]

  def index
    @loans = Loan.left_outer_joins(:branch, :issues).group(:id).order(:id).select('loans.*',
                                                                                  'COALESCE(SUM(issues.amount), 0)
                                                                                   AS amount_issued')
  end

  def show
    @clients = Client.joins(:loans).where('clients_loans.loan_id = ?', @loan.id)
  end

  def issues
    @issue = Issue.new
  end

  def clients; end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)

    if @loan.save
      redirect_to @loan, success: 'Loan successfully created'
    else
      render :new
    end
  end

  def destroy
    @loan.destroy
    redirect_to loans_url, success: 'Loan deleted successfully'
  end

  private

  def set_loan
    id = params[:id]
    @loan = Loan.left_outer_joins(:branch, :issues).group(:id).select('loans.*',
                                                                      'COALESCE(SUM(issues.amount), 0.0) AS amount_issued', 'loans.amount -COALESCE(SUM(issues.amount), 0.0) AS remaining').find(id)
    @clients = Loan.left_outer_joins(:clients).where('loans.id = ?', id)
    @status = status_of @loan
  end

  def set_issues
    @issues = @loan.issues.order(date: :asc, id: :asc)
  end

  def loan_params
    params.require(:loan).permit(%i[branch_id amount], client_ids: [])
  end
end
