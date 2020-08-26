class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.datetime :deadline
      t.string :screenshot
      t.string :bug_type
      t.string :status

      t.timestamps
    end
  end
end
