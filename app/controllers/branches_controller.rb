class BranchesController < ApplicationController
  before_action :set_branch, only: %i[show accounts loans staffs edit update destroy]
  before_action :set_staffs, only: %i[show staffs]
  before_action :set_accounts, only: %i[show accounts]
  before_action :set_loans, only: %i[show loans]

  def index
    @branches = Branch.order(:id)
  end

  def show; end

  def new
    @branch = Branch.new
  end

  def edit; end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to @branch, success: 'Branch successfully created'
    else
      render :new
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to @branch, success: 'Subbranch updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @branch.destroy
      redirect_to branches_url, success: 'Branch has been deleted'
    else
      redirect_back fallback_location: branches_url, alert: 'Branch deletion failed'
    end
  end

  private

  def set_branch
    @branch = Branch.find(params[:id])
  end

  def branch_params
    params.fetch(:branch, {}).permit(%i[name city assets])
  end

  def set_staffs
    @staffs = Staff.where(branch: @branch)
  end

  def set_accounts
    @accounts = Account.where(branch: @branch)
  end

  def set_loans
    @loans = Loan.where(branch: @branch)
  end
end
