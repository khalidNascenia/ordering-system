require 'spec_helper'
require 'rails_helper'

feature "User logs in and logs out" do
  scenario "with correct details" do
    create(:user, email: "someone@example.tld", password: "somepassword")
    visit new_user_session_path
    find('input[name="commit"]').click
    expect(page).to have_css("h2", text: "Log in")

    login "someone@example.tld", "somepassword"

    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully"

    find('.logout a').click

    expect(current_path).to eq "/"
    expect(page).to have_content "Signed out successfully"
    expect(page).not_to have_content "someone@example.tld"

  end

  private

  def login(email, password)
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

end