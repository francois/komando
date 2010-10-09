require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "Creating a user should invite by email and flag as invited" do

    post :create, :user => {
      :username => "jill",
      :password => "jillspassword",
      :email    => "jill@teksol.info"}

  end

end
