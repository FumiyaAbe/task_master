class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = current_user.tasks

    # --- 検索（タイトル） ---
    if params[:q].present?
      q = "%#{params[:q].to_s.strip}%"
      @tasks = @tasks.where("title ILIKE ?", q) # PostgreSQL: ILIKE
    end

    # --- 状態・優先度フィルタ ---
    if params[:status].present? && Task.column_names.include?("status")
      @tasks = @tasks.where(status: params[:status])
    end
    if params[:priority].present? && Task.column_names.include?("priority")
      @tasks = @tasks.where(priority: params[:priority])
    end

    # --- 並び替え（ホワイトリスト） ---
    sort_sql =
      case params[:sort].to_s
      when "due_at_asc"   then "due_at ASC NULLS LAST"
      when "due_at_desc"  then "due_at DESC NULLS LAST"
      when "created_asc"  then "created_at ASC"
      when "created_desc" then "created_at DESC"
      else                      "due_at NULLS LAST, created_at DESC"
      end
    @tasks = @tasks.order(Arel.sql(sort_sql))

    # --- ページネーション ---
    @tasks = @tasks.page(params[:page]).per(20)
  end

  def show; end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "タスクを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "タスクを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました。"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # ==== ここを更新（due_on + due_time を due_at に結合） ====
  def task_params
    base = params.require(:task).permit(:title, :status, :priority, :body)
    date = params.dig(:task, :due_on).presence
    time = params.dig(:task, :due_time).presence

    if date && time
      # ブラウザ入力をアプリのタイムゾーンで解釈して due_at に保存
      base[:due_at] = Time.zone.parse("#{date}T#{time}")
    else
      if action_name == "create"
        # 新規作成時は未入力なら明示的に nil（DBのデフォルトに依存しない）
        base[:due_at] = nil
      else
        # 更新時は未入力なら既存の due_at を保持（キーを設定しない）
        # 何もしない（base に :due_at を入れない）
      end
    end

    base
  end
end
