require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "Creating a user should invite by email and flag as invited" do
    ActionMailer::Base.deliveries = []

    post :create, :user => {
      :username => "jill",
      :password => "jillspassword",
      :email    => "jill@teksol.info"}

    # Standard routing stuff
    assert_redirected_to root_url

    # User created in DB
    user = User.find_by_username("jill")
    assert_not_nil user
    assert_equal "jill", user.username
    assert_equal "invited", user.state

    # Email sent
    assert_equal 1, ActionMailer::Base.deliveries.length, "Invitation/Welcome email not sent"
  end

end
