require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  before do
    DB[:users].delete
  end
  scenario 'User can register' do
    visit '/'
    click_on 'Register'
    fill_in 'email', with: 'bob@example.com'
    fill_in 'password', with: 'password'
    click_on 'Register'
    expect(page).to have_content 'Welcome, bob@example.com'
  end

  scenario 'User can logout' do
    email_address = 'chris@example.com'
    welcome_message = "Welcome, #{email_address}"
    visit '/'
    click_on 'Register'
    fill_in 'email', with: email_address
    fill_in 'password', with: '123456'
    click_on 'Register'
    expect(page).to have_content(welcome_message)
    click_on 'Logout'
    expect(page).to have_content('You are not logged in.')

  end

  scenario "User can login with registered email and password" do
    email_address = 'chris@example.com'
    password = '123456'
    welcome_message = "Welcome, #{email_address}"
    visit '/'
    click_on 'Register'
    fill_in 'email', with: email_address
    fill_in 'password', with: password
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'email', with: email_address
    fill_in 'password', with: password
    click_on 'Login'
    expect(page).to have_content(welcome_message)

  end

  scenario "User cannot login if their email address does not exist" do
    email_address = 'chris@example.com'
    password = '123456'
    visit '/'
    click_on 'Login'
    fill_in 'email', with: email_address
    fill_in 'password', with: password
    click_on 'Login'
    expect(page).to have_content "Email / password is invalid"
  end

  scenario "User cannot sign in with an invalid email and/or password" do
    email_address = 'chris@example.com'
    password = '123456'
    visit '/'
    click_on 'Register'
    fill_in 'email', with: email_address
    fill_in 'password', with: password
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'email', with: email_address
    fill_in 'password', with: "password"
    click_on 'Login'
    expect(page).to have_content "Email / password is invalid"
  end

  scenario "A user can be marked as an administrator" do
    email_address = 'chris@example.com'
    password = '123456'
    admin = 'View all users'
    visit '/'
    click_on 'Register'
    fill_in 'email', with: email_address
    fill_in 'password', with: password
    click_on 'Register'
    expect(page).to have_no_content(admin)
    DB[:users].where(:email => email_address).update(:admin => true)
    visit '/'
    expect(page).to have_content(admin)

  end
end
