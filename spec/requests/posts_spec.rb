require "rails_helper"

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "GET /posts" do
    it "επιστρέφει 200 για συνδεδεμένο χρήστη" do
      get posts_path
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /posts/:id" do
    it "δεν επιτρέπει διαγραφή post άλλου χρήστη" do
      post_of_other = create(:post, user: other_user)
      expect {
        delete post_path(post_of_other)
      }.not_to change(Post, :count)
    end

    it "επιτρέπει διαγραφή δικού του post" do
      own_post = create(:post, user: user)
      expect {
        delete post_path(own_post)
      }.to change(Post, :count).by(-1)
    end
  end
end