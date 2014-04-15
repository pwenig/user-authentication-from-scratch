require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  scenario 'User can register' do
    visit '/'
    click_on 'Register'
    fill_in 'email', with: 'bob@example.com'
    fill_in 'password', with: 'password'
    click_on 'Register'
    expect(page).to have_content 'Welcome, bob@example.com'
  end

end
