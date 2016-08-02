require 'test_helper'

class AboutPageTest < FeatureTest
  test 'user can see About Page on about page' do
    visit root_path

    assert_content 'Hello World'

    click_link 'About Page'

    assert_content 'About Page'
  end
end
