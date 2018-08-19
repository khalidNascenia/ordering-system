require 'rails_helper'

feature "User registers" do

  scenario "with valid details" do

    visit new_user_registration_path

    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    fill_in "Password confirmation", with: "test-password"
    find('input[name="commit"]').click

    expect(current_path).to eq "/"
    expect(page).to have_content(
      "Welcome! You have signed up successfully."
    )
  end


  context "with invalid details" do

    before do
      visit new_user_registration_path
    end

    scenario "blank fields" do
      expect_fields_to_be_blank
      find('input[name="commit"]').click

      expect(page).to have_content "Email can't be blank",
        "Password can't be blank"
    end

    scenario "incorrect password confirmation" do

      fill_in "Email", with: "tester@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "not-test-password"
      find('input[name="commit"]').click

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario "already registered email" do

      create(:user, email: "dave@example.tld", password: 'password')

      fill_in "Email", with: "dave@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      find('input[name="commit"]').click

      expect(page).to have_content "Email has already been taken"
    end

    scenario "invalid email" do

      fill_in "Email", with: "invalid-email-for-testing"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      find('input[name="commit"]').click

      expect(page).to have_content "Email is invalid"
    end
  end

  private

  def expect_fields_to_be_blank
    expect(page).to have_field("Email", with: "", type: "email")
    # These password fields don't have value attributes in the generated HTML,
    # so with: syntax doesn't work.
    expect(find_field("Password", type: "password").value).to be_nil
    expect(find_field("Password confirmation", type: "password").value).to be_nil
  end

end