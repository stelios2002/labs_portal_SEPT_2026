require "rails_helper"

RSpec.describe Conversation, type: :model do
  it { should belong_to(:group).optional }
  it { should have_many(:users).through(:conversation_users) }
  it { should have_many(:messages).dependent(:destroy) }

  describe ".between" do
    it "βρίσκει υπάρχουσα 1-προς-1 συνομιλία μεταξύ δύο χρηστών" do
      a = create(:user)
      b = create(:user)
      convo = Conversation.create!
      ConversationUser.create!(conversation: convo, user: a)
      ConversationUser.create!(conversation: convo, user: b)

      expect(Conversation.between(a, b)).to eq(convo)
    end
  end
end