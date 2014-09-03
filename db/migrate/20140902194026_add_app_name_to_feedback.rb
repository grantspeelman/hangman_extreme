class AddAppNameToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :app_name, :string
  end
end
