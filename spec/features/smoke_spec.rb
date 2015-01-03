require 'rails_helper'

describe "smoke test" do

  it "should work" do
    visit root_path
    click_link ('Login')
    click_link ('Sign up')

    fill_in('Email', :with => 'test@test.org')
    fill_in('Password', :with => 'testtesttest')
    fill_in('Password confirmation', :with => 'testtesttest')

    click_button('Sign up')

    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account')

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to eq ['test@test.org']
    expect(last_email.subject).to have_content 'Confirmation instructions'
    expect(last_email.body.to_s).to match 'http://localhost/users/confirmation'
  end

end