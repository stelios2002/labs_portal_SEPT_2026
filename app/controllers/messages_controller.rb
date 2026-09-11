class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authorize_participant!

  def create
    @message = @conversation.messages.build(message_params.merge(user: current_user))
    @message.save
    # broadcast γίνεται αυτόματα μέσω after_create_commit στο μοντέλο (Part 11)
    redirect_to @conversation
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def authorize_participant!
    redirect_to conversations_path, alert: "Δεν έχεις πρόσβαση" unless @conversation.users.include?(current_user)
  end

  def message_params
    params.require(:message).permit(:body)
  end
end