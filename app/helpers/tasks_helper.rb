module TasksHelper
  # ステータスに応じた小アイコン（emojiで軽量）
  def status_icon(task)
    st = task.respond_to?(:status) ? task.status.to_s.downcase : ""
    case st
    when "done"  then "✅"
    when "doing" then "⏳"
    when "todo"  then "📝"
    else "🗂️"
    end
  end

  # 期限の相対表示とクラス
  # 戻り値: ["あと3日", "due-soon"] など
  def due_phrase_and_class(task)
    return [ nil, nil ] unless task.respond_to?(:due_at) && task.due_at.present?

    due = task.due_at
    now = Time.current

    # 距離文言
    phrase =
      if due.future?
        "あと #{distance_of_time_in_words(now, due)}"
      else
        "#{distance_of_time_in_words(due, now)}前"
      end

    # クラス判定（期限切れ／間近／安全）
    klass =
      if due.to_date < Date.current
        "due-late"
      elsif due <= 3.days.from_now
        "due-soon"
      else
        "due-safe"
      end

    [ phrase, klass ]
  end
end
