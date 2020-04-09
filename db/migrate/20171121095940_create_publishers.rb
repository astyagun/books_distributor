class CreatePublishers < ActiveRecord::Migration[5.1]
  def change
    create_table :publishers, &:timestamps
  end
end
