require 'spec_helper'

describe "Issue 1973" do

  class Match
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user1, :class_name => "User", :inverse_of => 'hosted_matches'
    belongs_to :user2, :class_name => "User", :inverse_of => 'invited_matches'
  end

  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :hosted_matches, :class_name => "Match", :foreign_key => "user1_id", :inverse_of => 'user1'
    has_many :invited_matches, :class_name => "Match", :foreign_key => "user2_id", :inverse_of => 'user2'
  end

  it 'should not link same user' do
    @user1 = User.create
    @user2 = User.create
    @match = Match.new

    @match.user1 = @user1
    @match.user2 = @user2
    @match.save!
    @match.reload
    @match.user1.should_not eq(@match.user2)
  end

end
