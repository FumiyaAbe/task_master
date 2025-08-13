class EventsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @events = current_user ? current_user.events.order(starts_at: :asc) : Event.none
  end

  def show
    @event = Event.find(params[:id])
  end

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

  private

  def event_params
    params.require(:event).permit(:title, :starts_at, :ends_at, :location, :notes)
  end
end
