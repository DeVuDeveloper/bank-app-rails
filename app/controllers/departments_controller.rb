class DepartmentsController < ApplicationController
  before_action :set_department, only: %i[show staffs edit update destroy]
  before_action :set_staffs, only: %i[show staffs]

  def index
    @departments = Department.order(:id)
  end

  def show; end

  def new
    @department = Department.new
  end

  def edit; end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, success: 'Department successfully created'
    else
      render :new
    end
  end

  def update
    if @department.update(department_params)
      redirect_to @department, success: 'Successfully updated department'
    else
      render :edit
    end
  end

  def destroy
    if @department.destroy
      redirect_to departments_url, success: 'Department deleted'
    else
      redirect_back fallback_location: departments_url, alert: 'Department deletion failed'
    end
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end


  def department_params
    params.require(:department).permit(%i[name kind])
  end

  def set_staffs
    @staffs = Staff.where(department: @department)
  end
end
