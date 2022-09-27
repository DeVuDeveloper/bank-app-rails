class ClientsController < ApplicationController
  include AccountsHelper

  before_action :set_client, only: %i[edit update destroy accounts loans]

  def index
    @clients = Client.joins(:contact, :manager).order(:id).select('clients.*',
                                                                  'contacts.name AS contact_name', 'staffs.name AS manager_name')
  end

  def show
    @client = Client.joins(:contact, :manager).select('clients.*', 'contacts.name AS contact_name',
                                                      'staffs.name AS manager_name').find(params[:id])
  end

  def contact
    @contact = Contact.joins(:client).select('contacts.*',
                                             'clients.name AS client_name').find_by(client_id: params[:id])
  end

  def accounts
    @accounts = Ownership.joins(:account, :branch).where(client: @client).select('ownerships.*',
                                                                                 'accounts.balance AS balance', 'branches.name AS branch_name')
  end

  def loans
    @loans = Loan.joins(:clients, :branch).where('clients.id = ?', @client.id).select('loans.*',
                                                                                      'branches.name AS branch_name')
  end

  def new
    @client = Client.new
    @client.build_contact
  end

  def edit; end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, success: 'Successfully created customer'
    else
      render :new
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, success: 'Successfully updated customer'
    else
      render :edit
    end
  end

  def destroy
    if @client.destroy
      redirect_to clients_url, success: 'Customer deleted'
    else
      redirect_back fallback_location: clients_url, alert: 'Customer deletion failed'
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.fetch(:client, {}).permit(helpers.fields, %i[manager_id manager_type],
                                     contact_attributes: helpers.contact_fields)
  end
end
