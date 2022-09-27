class StaffsController < ApplicationController
  before_action :set_staff, only: %i[show clients edit update destroy]
  before_action :set_clients, only: %i[show clients]

  def index
    @staffs = staffs.order(:id)
  end

  def show; end

  def new
    @staff = Staff.new
  end

  def edit; end

  def create
    @staff = Staff.new(staff_params)

    if @staff.save
      redirect_to @staff, success: 'Successfully created'
    else
      render :new
    end
  end

  def update
    if @staff.update(staff_params)
      redirect_to @staff, success: 'Employee successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if @staff.destroy
      redirect_to staffs_url, success: 'Employee deleted'
    else
      redirect_back fallback_location: departments_url, alert: 'Employee deletion failed'
    end
  end

  private

  def staffs
    @staffs ||= Staff.joins(:branch, :department).select('staffs.*',
                                                         'branches.name AS branch_name', 'departments.name AS department_name')
  end

  def set_staff
    @staff = staffs.find(params[:id])
  end

  def set_clients
    @clients = Client.joins(:manager).where(manager: @staff)
  end
  
  def staff_params
    params.require(:staff).permit(:person_id, :name, :phone, :address, :start_date, :manager,
                                  :branch_id, :department_id)
  end
end
