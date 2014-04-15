require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  scenario 'User can register' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'bob@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Register'
    expect(page).to have_content 'Welcome, bob@example.com'
  end

end
