def sign_up user
  fill_in :username, with: user.username
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  fill_in :password_confirmation, with: user.password_confirmation
  click_button 'Sign up'
end
