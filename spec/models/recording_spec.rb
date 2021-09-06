require 'rails_helper'

RSpec.describe Recording, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:recording)).to be_valid
  end

  # it "is invalid without a title"
  it { should validate_presence_of(:title) }

  # it "is invalid without a url"
  it { should validate_presence_of(:url) }

  it "is invalid if the URL is not formatted properly"
end
