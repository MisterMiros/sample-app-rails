include ApplicationHelper

def sign_in(user, options = {})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path unless options[:no_visit]
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def fill_with_valid_signup
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def fill_with_valid_edit(user, options = {})
  fill_in "Name", with: options[:name] || user.name
  fill_in "Email", with: options[:email] || user.email
  fill_in "Password", with: options[:password] || user.password
  fill_in "Confirmation", with: options[:password] || user.password
  click_button "Save changes"
end

def danger
  'div.alert.alert-danger'
end

def success
  'div.alert.alert-success'
end

RSpec::Matchers.define :have_error_message do |message| 
  match do |page|
    expect(page).to have_selector(danger, text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector(success, text: message)
  end
end