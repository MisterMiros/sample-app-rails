require 'rails_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name" do
    describe "is not present" do
      before { @user.name = " " }
      it { should_not be_valid }
    end
    describe "is too long" do
      before { @user.name = 'a'*51 }
      it { should_not be_valid }
    end
  end

  describe "when email" do
    describe "is not present" do
      before { @user.email = ' ' }
      it { should_not be_valid }
    end
    describe "format is invalid" do
      it "should be invalid" do
        addresses = %w[user@-bar-.com user@foo,com user_at_foo.org example.user@foo. foor@bar_baz.com foo@bat+baz.com foo@bar..com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end
    describe "format is valid" do
      it "should  be valid" do
        addresses = %w[user@f.bar user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end
    describe "address is already taken" do
      before do
        user_with_same_email       = @user.dup
        user_with_same_email.email = @user.email.swapcase
        user_with_same_email.save
      end
      it { should_not be_valid }
    end
    describe "is saved to base" do
      let(:mixed_case_email) { "USER@example.com" }
      it "should be in lowercase" do
        @user.email = mixed_case_email
        @user.save
        expect(@user.reload.email).to eq mixed_case_email.downcase
      end
    end
  end

  describe "when password" do
    describe "is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end
    describe "doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end
    describe "is too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false }
    end
  end

  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      describe "feed" do
        it "should include newer micropost" do
          expect(@user.feed).to include(newer_micropost)
        end
        it "should include older_micropost" do
          expect(@user.feed).to include(older_micropost)
        end
        it "should not include unfollowed post" do
          expect(@user.feed).not_to include(unfollowed_post)
        end
      end
    end

  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    it "followed users should include other user" do
      expect(@user.followed_users).to include(other_user)
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      it "followed users should not include other user" do
        expect(@user.followed_users).not_to include(other_user)
      end
    end

  end
end
