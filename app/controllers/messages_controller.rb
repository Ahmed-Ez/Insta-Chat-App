require 'numbers_helper'
class MessagesController < ApplicationController
    def index
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chat = Chat.includes(:messages).where(app_id:app.id,number:params[:chat_id]).first
            if chat == nil
              return head :not_found
            end
            if !chat.messages.any?
                return head :no_content
            end
            return render json: chat.messages, status: :ok
          rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end

    def show
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chat = Chat.where(app_id:app.id,number:params[:chat_id]).first
            if chat == nil
              return head :not_found
            end
            message = Message.where(chat_id:chat.id,number:params[:id]).first
            if message == nil
                return head :not_found
            end
            return render json: message, status: :ok
          rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end

    def destroy
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chat = Chat.where(app_id:app.id,number:params[:chat_id]).first
            if chat == nil
              return head :not_found
            end
            message = Message.where(chat_id:chat.id,number:params[:id]).first
            if message == nil
                return head :not_found
            end
            message.delete
            return  head :no_content
          rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end

    def create
        begin
            found_app = App.find_by(token: params[:app_id])
            if found_app == nil
                return render json:{message:"invalid application token !"}, status: :bad_request
            end
            chat = Chat.where(app_id:found_app.id,number:params[:chat_id]).first
            if chat == nil
                return render json:{message:"invalid chat number !"}, status: :bad_request
            end
            message = Message.new({content:params[:content],number:NumbersHelper.get_number(chat.id),chat_id:chat.id})
            if message.valid?
                Sender.push(ENV['MESSAGES_MQ_NAME'],message.to_json(:except => [ :id, :created_at, :messages_count,:updated_at ]))
            return render json: message, status: :created
            else
              return render json: chat.errors, status: :unprocessable_entity
            end
            rescue Exception => e
              return render json: {error: e.message},status: :internal_server_error
        end
    end

    def update
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chat = Chat.where(app_id:app.id,number:params[:chat_id]).first
            if chat == nil
              return head :not_found
            end
            message = Message.where(chat_id:chat.id,number:params[:id]).first
            if message == nil
                return head :not_found
            end
            message.content = params[:content]
            Sender.push(ENV['MESSAGES_MQ_NAME'],message.to_json(:except => [ :id, :created_at, :messages_count,:updated_at ]))
            return  head :no_content
          rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end

    def search
        begin
            app = App.find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            chat = Chat.where(app_id:app.id,number:params[:chat_id]).first
            if chat == nil
              return head :not_found
            end
            response = Message.search(query:{match:{content:params[:content]}})
            response = response.results.select { |r| r.chat_id == chat.id }
            if !response.any?
                return head :no_content
            end
            return render json:response, status: :ok
        rescue Exception => e
            return render json: {error: e.message},status: :internal_server_error
        end
    end
end