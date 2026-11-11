class BackfillDefaultTemplates < ActiveRecord::Migration[8.1]
  DEFAULTS = [
    { name: "Short", body: "I'm open: {open_dates}. Want me to hold one?", position: 0 },
    { name: "Full List", body: "Available:\n{open_dates_list}\n\nOn hold:\n{hold_dates_list}", position: 1 },
    { name: "By Weekday", body: "{open_dates_grouped}", position: 2 }
  ].freeze

  class MigrationTemplate < ActiveRecord::Base
    self.table_name = "templates"
  end

  def up
    user_ids = select_values(<<~SQL)
      SELECT users.id FROM users
      WHERE NOT EXISTS (SELECT 1 FROM templates WHERE templates.user_id = users.id)
    SQL
    now = Time.current
    rows = user_ids.product(DEFAULTS).map do |user_id, attrs|
      attrs.merge(user_id: user_id, created_at: now, updated_at: now)
    end
    MigrationTemplate.insert_all(rows) if rows.any?
  end

  def down
  end
end
