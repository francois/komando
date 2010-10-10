require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "#invite! creates record with state == :invited" do
    user = User.invite!(:username => "jill",
                        :password => "jillspassword",
                        :email => "jill@teksol.info")

    assert !user.new_record?
    assert_equal "invited", user.state
  end

end
