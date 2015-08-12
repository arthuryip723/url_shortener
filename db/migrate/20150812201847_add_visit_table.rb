class AddVisitTable < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :shortened_url_id
      t.timestamps

    end

    change_column :shortened_urls, :submitter_id,  'integer USING CAST(submitter_id AS integer)'
  end
end
