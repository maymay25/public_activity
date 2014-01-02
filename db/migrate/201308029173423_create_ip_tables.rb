class CreateIpTables < ActiveRecord::Migration
  def change
    create_table :ip_tables do |t|
      t.column :start_at, 'BIGINT'
      t.column :end_at, 'BIGINT'
      t.string :province_name
      t.string :city_name
    end
  end
end
