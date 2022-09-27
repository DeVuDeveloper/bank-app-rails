class OwnershipsController < ApplicationController
  before_action :set_account, only: %i[create destroy]
  before_action :set_ownership, only: [:destroy]

  def create
    owner = Ownership.new ownership_params

    if owner.save
      redirect_to account_owners_url(@account), success: 'Successfully added customer to account'
    else
      render 'accounts/owners'
    end
  end

  def destroy
    if @ownership.destroy
      redirect_to account_owners_url(@account), success: 'Customer has been removed from account'
    else
      redirect_to account_owners_url(@account), alert: @ownership.errors.full_messages.join("\n")
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def set_ownership
    @ownership = Ownership.find_by(account_id: params[:id], client_id: params[:client_id])
  end

  def ownership_params
    params.require(:ownerships).permit(:client_id).merge(account: @account,
                                                         accountable_type: @account.accountable_type, branch: @account.branch)
  end
end
