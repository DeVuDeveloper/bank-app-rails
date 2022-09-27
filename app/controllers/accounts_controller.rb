class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit owners update destroy]

  def index
    @accounts = Account.joins(:branch).order(:id).select('accounts.*',
                                                         'branches.name AS branch_name')
  end

  def show
    @owners = @account.ownerships.joins(:client).limit(3).select(:client_id,
                                                                 'clients.name AS client_name')
  end

  def new
    @account = Account.new
  end

  def edit; end

  def owners
    @ownership = Ownership.new
    @owners = @account.ownerships.joins(:client).select('ownerships.*',
                                                        'clients.name AS client_name')
    @available_clients = Client.where.not(id: Ownership.where(branch_id: @account.branch_id, accountable_type: @account.accountable_type).select(:client_id)).select(
      :id, :name
    )
  end

  def create
    params = account_params
    accountable_type = params[:accountable_type]
    @typed_account = accountable_type.safe_constantize.new(params[:accountable_attributes])
    params[:ownerships_attributes]&.each_value do |attr|
      attr.merge!(accountable_type:, branch_id: params[:branch_id])
    end
    @account = @typed_account.build_account(params)

    if @account.save
      redirect_to @account, success: 'Account created successfully'
    else
      render :new
    end
  end

  def update
    if update_params[:branch_id].to_i == @account.branch_id
      @account.update! update_params
    else
      client_ids = Ownership.where(account: @account).select(:client_id)
      target_client_ids = Ownership.where(branch_id: update_params[:branch_id],
                                          client_id: client_ids)
      unless target_client_ids.empty?
        target_client_ids.joins(:branch, :client).select('branches.name AS branch_name',
                                                         'clients.name AS client_name').each do |target|
          errors << "Client #{target.client_name} at the branch #{target.branch_name} have an account"
        end
        render :edit and return
      end

      Account.transaction do
        Ownership.where(account: @account).update_all(branch_id: update_params[:branch_id])
        @account.update! update_params
      end
    end
    redirect_to @account, success: 'Account updated successfully'
  rescue ActiveRecord::ActiveRecordError
    render :edit, alert: 'Account update failed'
  end

  def destroy
    @account.destroy
    redirect_to accounts_url, success: 'Account has been cancelled'
  end

  private

  def set_account
    @account = Account.joins(:branch, :ownerships).group(:id).select('accounts.*',
                                                                     'branches.name AS branch_name', 'COUNT(ownerships.client_id) AS owners_count').find(params[:id])
  end

  def account_params
    params.require(:account).permit(%i[id branch_id accountable_type balance open_date],
                                    accountable_attributes: %i[interest_rate currency withdraw_amount], ownerships_attributes: [:client_id])
  end

  def update_params
    account_params.except(:accountable_type, :ownerships_attributes)
  end

  def ownership_params
    params.require(:ownerships).permit(:client_id).merge(account: @account,
                                                         accountable_type: @account.accountable_type, branch: @account.branch)
  end
end
