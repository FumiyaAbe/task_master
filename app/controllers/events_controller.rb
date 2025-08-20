class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = current_user.events.order(Arel.sql("starts_at NULLS LAST"))
  end

  def show; end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "イベントを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "イベントを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "イベントを削除しました。"
  end

  private

  def set_event
    # 認証前に弾かれるので current_user は必ず存在
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :starts_at, :ends_at, :location, :all_day, :notes)
  end
end
