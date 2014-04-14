Sequel.migration do
  up do
    create_table(:user) do
      primary_key :id
      String :email, :null => false
      String :password, :null => false
    end
  end

  down do
    drop_table(:user)
  end
end
