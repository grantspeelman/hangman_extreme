class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedback do |t|
      t.belongs_to :user_account, index: true
      t.string :subject
      t.text :message
      t.string :support_type, default: 'suggestion'
      t.timestamps
    end
  end
end
