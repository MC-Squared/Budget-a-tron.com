require 'rails_helper'

RSpec.describe CategoryRule, type: :model do
  describe "creation" do
    it "can be created if valid" do
      category = FactoryBot.create(:category)
      rule = CategoryRule.create(category: category)
      expect(rule).to be_valid
    end
  end
end
