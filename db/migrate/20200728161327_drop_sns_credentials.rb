class DropSnsCredentials < ActiveRecord::Migration[6.0]
  def up
    SnsCredential.reset_column_information
    User.reset_column_information

    SnsCredential.find_each do |s|
      user = User.find(s.user_id)
      user.provider = s.provider
      user.save!
    end

    drop_table :sns_credentials
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
