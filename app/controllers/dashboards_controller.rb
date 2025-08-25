class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def home
    @month  = (params[:month] || Date.current.strftime("%Y-%m")).to_s # "YYYY-MM"
    year, mon = @month.split("-").map(&:to_i)
    @date     = Date.new(year, mon, 1)

    range_from = @date.beginning_of_month.beginning_of_week(:sunday)
    range_to   = @date.end_of_month.end_of_week(:sunday)

    @events_by_day = current_user.events
      .where(starts_at: range_from.beginning_of_day..range_to.end_of_day)
      .group_by { |e| e.starts_at.to_date }

    # Task の期日カラム名に合わせて調整してください:
    # - 例: due_at / due_on / deadline のどれか
    task_due_column = (Task.column_names & %w[due_at due_on deadline]).first
    @tasks_by_day =
      if task_due_column
        current_user.tasks
          .where(Task.arel_table[task_due_column].between(range_from.beginning_of_day..range_to.end_of_day))
          .group_by { |t| t.public_send(task_due_column).to_date }
      else
        {} # 期日カラムがなければ空（後で対応）
      end

    @calendar_days = (range_from..range_to).to_a.in_groups_of(7)
  end
end
