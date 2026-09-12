class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  before_action :authorize_participant!, only: [:show]

  def index
    @conversations = current_user.conversations.includes(:users, :messages)
    render layout: false if turbo_frame_request?
  end

  def show
    @messages = @conversation.messages.includes(:user).order(:created_at)
    @message = Message.new
    render layout: false if turbo_frame_request?
  end

  def start_with_user
    other = User.find(params[:user_id])
    conversation = Conversation.between(current_user, other)

    if conversation.nil?
      conversation = Conversation.create!
      ConversationUser.create!(conversation: conversation, user: current_user)
      ConversationUser.create!(conversation: conversation, user: other)
    end

    redirect_to conversation_path(conversation, popup: true)
  end

  
  def start_with_group
    group = Group.find(params[:group_id])
    conversation = group.conversations.first

    if conversation.nil?
      conversation = group.conversations.create!
      group.users.each { |u| ConversationUser.create!(conversation: conversation, user: u) }
    end

    redirect_to conversation_path(conversation, popup: true)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def authorize_participant!
    redirect_to conversations_path, alert: "Δεν έχεις πρόσβαση" unless @conversation.users.include?(current_user)
  end
end