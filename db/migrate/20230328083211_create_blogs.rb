# frozen_string_literal: true

class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.text :text
      t.timestamps
    end
  end
end
