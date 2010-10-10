require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "#invite! creates record with state == :invited" do
    user = User.invite!(:email => "jill@teksol.info")

    assert !user.new_record?
    assert_equal "jill@teksol.info", user.email
    assert_equal "invited", user.state
    assert_not_nil user.token
  end

end
