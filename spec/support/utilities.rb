include ApplicationHelper

def fill_with_valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def fill_with_valid_signup
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
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