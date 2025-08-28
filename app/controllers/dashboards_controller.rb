class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def home
    @month  = (params[:month] || Date.current.strftime("%Y-%m")).to_s # "YYYY-MM"
    year, mon = @month.split("-").map(&:to_i)
    @date     = Date.new(year, mon, 1)

    # 表示/非表示トグル（文字列キーで判定）
    @show_events =
      if params.key?("show_events")
        params[:show_events].to_s == "1"
      else
        true
      end

    @show_tasks  =
      if params.key?("show_tasks")
        params[:show_tasks].to_s == "1"
      else
        true
      end

    range_from = @date.beginning_of_month.beginning_of_week(:sunday)
    range_to   = @date.end_of_month.end_of_week(:sunday)

    # Events
    if @show_events
      events_scope   = current_user.events.where(starts_at: range_from.beginning_of_day..range_to.end_of_day)
      @events_by_day = events_scope.group_by { |e| e.starts_at.to_date }
    else
      @events_by_day = {}
    end

    # Tasks（期日カラムに合わせて自動検出）
    if @show_tasks
      task_due_column = (Task.column_names & %w[due_at due_on deadline]).first
      @tasks_by_day =
        if task_due_column
          col = Task.arel_table[task_due_column]
          current_user.tasks
            .where(col.between(range_from.beginning_of_day..range_to.end_of_day))
            .group_by { |t| t.public_send(task_due_column).to_date }
        else
          {}
        end
    else
      @tasks_by_day = {}
    end

    @calendar_days = (range_from..range_to).to_a.in_groups_of(7)
  end
end
