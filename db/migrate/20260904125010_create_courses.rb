class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :code
      t.string :title

      t.timestamps
    end
  end
end
