require 'rails_helper'

feature "Robots" do
  context "canonical host" do
    scenario "allow robots to index the site" do
      Rails.env = 'production'
      expect(Rails.env.production?).to be_truthy
      Capybara.app_host = "http://#{ENV['CANONICAL_HOST']}"
      visit '/robots.txt'
      expect(page).to have_content('User-agent: *')
      expect(page).to have_content('Disallow:')
      expect(page).to have_no_content('Disallow: /')
    end
  end

  context "non-canonical host" do
    scenario "deny robots to index the site" do
      Rails.env = 'test'
      expect(Rails.env.production?).to be_falsey
      Capybara.app_host = nil
      visit '/robots.txt'
      expect(page).to have_content('User-agent: *')
      expect(page).to have_content('Disallow: /')
    end
  end
end

# This would be the resulting docs
# Robots
#   canonical host
#      allow robots to index the site
#   non-canonical host
#      deny robots to index the site
