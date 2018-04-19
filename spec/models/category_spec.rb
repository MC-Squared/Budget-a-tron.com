require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "creation" do
    it "can be created if valid" do
      user = FactoryBot.create(:user)
      category = Category.create(
        user: user,
        name: 'category',
      )
      expect(category).to be_valid
    end

    it "must have a unique name for this user" do
      user = FactoryBot.create(:user)
      category = Category.create(
        user: user,
        name: 'category',
      )
      expect(category).to be_valid

      category2 = Category.create(
        user: user,
        name: 'category',
      )

      expect(category2).to_not be_valid
    end
  end
end
