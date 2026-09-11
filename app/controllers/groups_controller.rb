class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :join, :leave]

  def index
    @groups = Group.all.includes(:owner, :users)
  end

  def show
    @is_member = @group.users.include?(current_user)
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      @group.memberships.create!(user: current_user, role: "owner")
      redirect_to @group, notice: "Η ομάδα δημιουργήθηκε"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    @group.memberships.find_or_create_by!(user: current_user) { |m| m.role = "member" }

    conversation = @group.conversations.first
    if conversation && !conversation.users.include?(current_user)
      ConversationUser.create!(conversation: conversation, user: current_user)
    end

    redirect_to @group, notice: "Έγινες μέλος"
  end

  def leave
    @group.memberships.find_by(user: current_user)&.destroy
    redirect_to groups_path, notice: "Αποχώρησες από την ομάδα"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
