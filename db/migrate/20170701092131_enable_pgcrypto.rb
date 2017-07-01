class EnablePgcrypto < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL.squish
      CREATE EXTENSION "pgcrypto";
    SQL
  end

  def down
    execute <<-SQL.squish
      DROP EXTENSION "pgcrypto";
    SQL
  end
end
