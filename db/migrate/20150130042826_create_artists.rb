class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.boolean :union_member, default: true
      t.datetime :dob

      t.timestamps null: false
    end
  end
end
