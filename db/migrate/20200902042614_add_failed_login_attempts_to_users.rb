class AddFailedLoginAttemptsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :failed_login_attempts, :integer, default: 0
  end
end
