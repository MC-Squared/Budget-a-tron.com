require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creation" do
    it "can be created if valid" do
      user = User.create(
        email: 'test@user.com',
        password: '12345678',
      )
      expect(user).to be_valid
    end
  end
end
