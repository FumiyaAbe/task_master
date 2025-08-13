class TasksController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @tasks = current_user ? current_user.tasks.order(due_at: :asc, created_at: :desc) : Task.none
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = current_user.tasks.build(status: :todo, priority: :medium)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "タスクを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :body, :due_at, :status, :priority)
  end
end
