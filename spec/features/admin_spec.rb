require 'rails_helper'

# Capybara docs: http://rubydoc.info/github/jnicklas/capybara/master

describe "rails_admin", :type => :feature do
  context "as visitor" do
    it "redirects to login page" do
      visit rails_admin.dashboard_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content(I18n.t 'devise.failure.unauthenticated')
    end
  end
  context "as user" do
    it "redirects to user home page" do
      as_user do
        visit rails_admin.dashboard_path
        expect(current_path).to eq(user_home_path)
        expect(page).to have_content(I18n.t 'unauthorized.default')
      end
    end
  end
  context "as admin" do
    it "displays admin dashbaord" do
      as_admin do
        visit rails_admin.dashboard_path
        expect(current_path).to eq(rails_admin.dashboard_path)
        expect(page).to have_content('Site Administration')
      end
    end
  end
end

describe "sidekiq", :type => :feature do
  context "as visitor" do
    it "redirects to login page" do
      visit sidekiq_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content(I18n.t 'devise.failure.unauthenticated')
    end
  end
  context "as user" do
    it "redirects to user home page" do
      as_user do
        visit sidekiq_path
        expect(current_path).to eq(user_home_path)
        expect(page).to have_content(I18n.t 'unauthorized.default')
      end
    end
  end
  context "as admin" do
    it "displays admin dashbaord" do
      as_admin do
        visit sidekiq_path
        expect(current_path).to eq(sidekiq_path)
        expect(page).to have_content('Sidekiq')
      end
    end
  end
end
