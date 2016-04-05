require 'rails_helper'
require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    it "follower should be equal to follower user" do
      expect(relationship.follower).to eq follower
    end
    it "followed should be equal to followed user" do
      expect(relationship.followed).to eq followed
    end
  end
end
