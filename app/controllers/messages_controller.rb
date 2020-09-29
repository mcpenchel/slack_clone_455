class MessagesController < ApplicationController

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message  = Message.new(message_params)

    @message.user     = current_user
    @message.chatroom = @chatroom

    # Sem validação no modelo Mensagem, não tem como não
    # salvar ela.. Desde que tenhamos um current_user e que
    # tenhamos um chatroom (que sempre vamos ter se a requisição
    # veio do formulário).
    if @message.save

      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: { message: @message })
      )


      redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
    else
      render 'chatrooms/show'
    end
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end

end
