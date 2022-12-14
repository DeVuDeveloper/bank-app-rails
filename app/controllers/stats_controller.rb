class StatsController < ApplicationController
  before_action :set_form, only: %i[deposit loan]

  def home
    @cards = [Branch, Department, Staff, Client, Account, Loan].zip \
      %w[safe department manager user credit-card debt]
  end

  def about; end

  def index
    @branches_count = Branch.count
    @accounts_count, @accounts_amount = Account.pluck('COUNT(id)', 'SUM(balance)').first
    Account.group(:accountable_type).pluck('COUNT(id)', :accountable_type).each do |count, type|
      @deposit_accounts_count = count if type == 'DepositAccount'
      @check_accounts_count = count if type == 'CheckAccount'
    end
    @loans_count, @loans_amount = Loan.pluck('COUNT(id)', 'SUM(amount)').first
    loan_statuses = Loan.left_outer_joins(:issues).group(:id).select(:id, %[
        CASE
          WHEN COALESCE(SUM(issues.amount), 0) = 0 THEN 0
          WHEN SUM(issues.amount) = loans.amount THEN 2
          ELSE 1
        END AS status
      ].squish)
    Loan.from(loan_statuses, :statuses).group(:status).select('COUNT(id) AS count',
                                                              :status).each do |row|
      case row.status
      when 0
        @unissued = row.count
      when 2
        @issued = row.count
      else
        @issuing = row.count
      end
    end
    @issues_amount = Issue.sum(:amount)

    @deposit_card_content = ["Filiale Account", "Total Amount Savings Account", "Checking Account"].zip [
      @branches_count, @accounts_count, helpers.currency_value(@accounts_amount),
      (@deposit_accounts_count ||= 0), (@check_accounts_count ||= 0)
    ]
    @loan_card_content = %w[Sub-FilialeLoan TotalAmountPaid NotDisbursed InDisbursement Disbursed].zip [
      @branches_count, @loans_count,
      helpers.currency_value(@loans_amount), helpers.currency_value(@issues_amount),
      (@unissued ||= 0), (@issuing ||= 0), (@issued ||= 0)
    ]
  end

  def deposit
    @start_year = Account.order(open_date: :asc).select(:open_date).first&.open_date&.year || Date.today.year
    return unless @action

    wheres = {}
    selects = ['accounts.*',
               'COUNT(DISTINCT ownerships.client_id) AS clients_count',
               'SUM(balance) AS total_amount',
               'branches.name AS branch_name']
    groups = ['accounts.branch_id', 'accounts.id', 'branch_name']
    orders = {}

    wheres[:branch_id] = @branches unless @branches.empty?

    case @time_span
    when :year
      selects << 'YEAR(open_date) AS open_year'
      selects << 'YEAR(open_date) AS display_time'
      groups << 'open_year'
      orders = { open_year: :asc, branch_id: :asc }
    when :quarter
      selects << 'YEAR(open_date) AS open_year'
      selects << '((MONTH(open_date) + 2) DIV 3) AS open_quarter'
      selects << 'CONCAT(YEAR(open_date), " Q", (MONTH(open_date) + 2) DIV 3) AS display_time'
      groups << 'open_quarter'
      orders = { open_year: :asc, open_quarter: :asc, branch_id: :asc }
    when :month
      selects << 'YEAR(open_date) AS open_year'
      selects << 'MONTH(open_date) AS open_month'
      selects << 'CONCAT(YEAR(open_date), "-", LPAD(MONTH(open_date), 2, "0")) AS display_time'
      groups << 'open_month'
      orders = { open_year: :asc, open_month: :asc, branch_id: :asc }
    else
      selects << 'open_date'
      selects << 'open_date AS display_time'
      groups << 'open_date'
      orders = { open_date: :asc, branch_id: :asc }
    end

    @query = Account.select(selects).joins(:branch).where(wheres).group(groups).order(orders)
    @data_branches = @query.except(:select, :group, :order).select('DISTINCT branch_id',
                                                                   'branches.name AS branch_name').order(branch_id: :ASC)
    @query = @query.joins(:ownerships)
  end

  def loan
    @start_year = Issue.order(date: :asc).select(:date).first&.date&.year || Date.today.year
    return unless @action

    wheres = {}
    selects = ['loans.*', 'issues.date AS date',
               'COUNT(DISTINCT clients.id) AS client_count',
               'SUM(issues.amount) AS total_amount',
               'branches.name AS branch_name']
    groups = ['loans.branch_id', 'loans.id', 'issues.date', 'branches.name']
    orders = {}

    wheres[:branch_id] = @branches unless @branches.empty?

    case @time_span
    when :year
      selects << 'EXTRACT(YEAR FROM Date) AS year'
      selects << 'EXTRACT(YEAR FROM Date) AS display_time'
      groups << 'year'
      orders = { year: :asc, branch_id: :asc }
    when :quarter
      selects << 'EXTRACT(YEAR FROM Date) AS year'

      selects << 'CONCAT(YEAR(date), " Q", (MONTH(date) + 2) DIV 3) AS display_time'
      groups << 'quarter'
      orders = { year: :asc, quarter: :asc, branch_id: :asc }
    when :month
      selects << 'EXTRACT(YEAR FROM Date) AS year'
      selects << 'EXTRACT(MONTH FROM Date) AS month'
      # selects << 'CONCAT(EXTRACT(YEAR FROM Date), LPAD(EXTRACT(MONTH FROM DATE))) AS display_time'
      groups << 'month'
      orders = { year: :asc, month: :asc, branch_id: :asc }
    else
      selects << 'date'
      selects << 'date AS display_time'
      groups << 'date'
      orders = { date: :asc, branch_id: :asc }
    end

    @query = Loan.select(selects).joins(:branch).where(wheres).group(groups).order(orders)
    @data_branches = @query.except(:select, :group, :order).select('DISTINCT branch_id',
                                                                   'branches.name AS branch_name')
    @query = @query.joins(:clients, :issues)
  end

  private

  def search_params
    @url_params ||= request.GET
  end

  def set_form
    @action = search_params[:action]
    @branches = (search_params[:branch] || '').split(' ').map(&:to_i)
    @start_date = begin
      Date.parse search_params[:start_date]
    rescue StandardError
      Date.today.at_beginning_of_month
    end
    @end_date = begin
      Date.parse search_params[:end_date]
    rescue StandardError
      Date.today
    end
    @end_year = Date.today.year
    valid_time_spans = %i[none month quarter year]
    @time_spans = %w[None Month Quarter Year].zip valid_time_spans
    @time_span = (search_params[:time_span] || :none).to_sym
    @time_span = :none unless valid_time_spans.include? @time_span
  end
end
