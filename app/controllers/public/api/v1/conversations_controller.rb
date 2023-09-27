class Public::Api::V1::ConversationsController < PublicController

  def fetch_by_protocolo
    protocolo = params[:protocolo]
    @conversation = Conversation.where("TRIM(additional_attributes->>'protocolo') = ?", protocolo).first

    if @conversation.nil?
      render json: { error: 'Conversation not found for the given protocolo' }, status: :not_found
    else
      @messages = @conversation.messages.outgoing.order(created_at: :desc).first
      render json: { conversation: @conversation, messages: @messages }
    end
  end

end
