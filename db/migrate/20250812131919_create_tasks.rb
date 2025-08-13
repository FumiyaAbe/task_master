class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string     :title,    null: false
      t.text       :body
      t.datetime   :due_at
      t.integer    :status,   null: false, default: 0   # enum: todo(0)/doing(1)/done(2)
      t.integer    :priority, null: false, default: 1   # enum: low(0)/medium(1)/high(2)
      t.references :user,     null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks, :due_at
    add_index :tasks, :status
    add_index :tasks, :priority
  end
end
