# テーブル設計（TaskMaster）

**凡例**  
- ✅ 実装済み（テーブル作成済み）  
- 🧭 予定（設計のみ・未作成）

> psql 確認結果（作成済み）：`users`, `tasks`, `events`

---

## users テーブル（✅ 実装済み）

| Column             | Type   | Options                          |
|--------------------|--------|----------------------------------|
| name               | string | null: false                      |
| email              | string | null: false, unique: true        |
| encrypted_password | string | null: false                      |
| accent_color       | string |                                  |
| task_color_scheme  | string |                                  |

### Association
- has_many :tasks
- has_many :events
- has_many :statuses
- has_many :priority_levels
- has_many :notification_settings
- has_many :contacts
- has_many :group_memberships
- has_many :groups, through: :group_memberships
- has_many :owned_groups, class_name: "Group"

---

## statuses テーブル（🧭 予定）

| Column  | Type       | Options                         |
|---------|------------|----------------------------------|
| name    | string     | null: false                     |
| user    | references | null: false, foreign_key: true  |

### Association
- belongs_to :user
- has_many :tasks

---

## priority_levels テーブル（🧭 予定）

| Column | Type       | Options                         |
|--------|------------|----------------------------------|
| name   | string     | null: false                     |
| user   | references | null: false, foreign_key: true  |

### Association
- belongs_to :user
- has_many :tasks

---

## tasks テーブル（✅ 実装済み）

| Column          | Type       | Options                         |
|-----------------|------------|----------------------------------|
| title           | string     | null: false                     |
| due_date        | date       |                                  |
| notify          | boolean    | null: false, default: false     |
| visible         | boolean    | null: false, default: true      |
| user            | references | null: false, foreign_key: true  |
| status          | references |                                  |
| priority_level  | references |                                  |

### Association
- belongs_to :user
- belongs_to :status, optional: true
- belongs_to :priority_level, optional: true

---

## events テーブル（✅ 実装済み）

| Column     | Type       | Options                         |
|------------|------------|----------------------------------|
| title      | string     | null: false                     |
| start_time | datetime   |                                  |
| end_time   | datetime   |                                  |
| notify     | boolean    | null: false, default: false     |
| visible    | boolean    | null: false, default: true      |
| user       | references | null: false, foreign_key: true  |

### Association
- belongs_to :user

---

## notification_settings テーブル（🧭 予定）

| Column      | Type       | Options                         |
|-------------|------------|----------------------------------|
| method      | string     |                                  |
| notify_time | time       |                                  |
| user        | references | null: false, foreign_key: true  |

### Association
- belongs_to :user

---

## contacts テーブル（🧭 予定）

| Column    | Type       | Options                         |
|-----------|------------|----------------------------------|
| name      | string     | null: false                     |
| email     | string     |                                  |
| relation  | string     |                                  |
| user      | references | null: false, foreign_key: true  |

### Association
- belongs_to :user

---

## groups テーブル（🧭 予定）

| Column | Type       | Options                         |
|--------|------------|----------------------------------|
| name   | string     | null: false                     |
| user   | references | null: false, foreign_key: true  | <!-- owner -->

### Association
- belongs_to :user  # owner
- has_many :group_memberships
- has_many :users, through: :group_memberships

---

## group_memberships テーブル（🧭 予定）

| Column | Type       | Options                         |
|--------|------------|----------------------------------|
| group  | references | null: false, foreign_key: true  |
| user   | references | null: false, foreign_key: true  |

### Association
- belongs_to :group
- belongs_to :user
