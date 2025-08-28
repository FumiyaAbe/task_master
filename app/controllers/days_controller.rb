# app/controllers/days_controller.rb
class DaysController < ApplicationController
  before_action :authenticate_user!

  def show
    @date = parse_date!(params[:date]) # Date オブジェクト
    day_range = @date.beginning_of_day..@date.end_of_day

    # 表示トグル（デフォルトは表示）
    @show_events = params.fetch(:show_events, "1") == "1"
    @show_tasks  = params.fetch(:show_tasks,  "1") == "1"

    # --- Events: 1日区間に「重なっている」イベントを抽出 ---
    # 条件: starts_at <= 当日末 & COALESCE(ends_at, starts_at) >= 当日初
    e = Event.arel_table
    coalesce_ends = Arel::Nodes::NamedFunction.new("COALESCE", [ e[:ends_at], e[:starts_at] ])
    @events = current_user.events
                          .where(e[:starts_at].lteq(day_range.end)
                            .and(coalesce_ends.gteq(day_range.begin)))
                          .order(:starts_at)

    # --- Tasks: 期限(due_at)が当日のものを抽出 ---
    # もし Task に due_at が無い場合は適宜フィールド名を調整してください
    if Task.column_names.include?("due_at")
      t = Task.arel_table
      @tasks = current_user.tasks
                           .where(t[:due_at].between(day_range))
                           .order(:due_at)
    else
      @tasks = Task.none
    end
  rescue ArgumentError
    redirect_to dashboard_path, alert: "不正な日付です。YYYY-MM-DD の形式で指定してください。"
  end

  private

  def parse_date!(str)
    # "YYYY-MM-DD" 想定。例外（ArgumentError）は上位で rescue
    Date.strptime(str.to_s, "%Y-%m-%d")
  end
end
