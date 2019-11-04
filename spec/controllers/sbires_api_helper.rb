def create_authenticated_user(username:, email:, auth_id:)
  user = User.create!(username: username, email: email, auth_id: auth_id)
  allow_any_instance_of(FindOrCreateUser).to receive(:call).and_return(user)
  user
end