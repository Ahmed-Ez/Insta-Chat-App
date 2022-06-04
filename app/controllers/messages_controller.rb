require 'numbers_helper'
class MessagesController < ApplicationController
    def index
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chats = Chat.includes(:messages).where(app_id:app.token,number:params[:chat_id])
            if !chats.any?
              return head :no_content
            end
            return render json: chats.messages, status: :ok
          rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end

end