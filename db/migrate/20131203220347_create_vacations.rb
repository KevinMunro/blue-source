class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.date :date_req
      t.date :start
      t.date :end
      t.string :type

      t.timestamps
    end
  end
end
