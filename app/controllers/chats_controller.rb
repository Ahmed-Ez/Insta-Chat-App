require 'numbers_helper'
class ChatsController < ApplicationController
    def index
        begin
            app = App.includes(:chats).find_by(token:params[:app_id])
            if app == nil
                return head :not_found
            end
            if !app.chats.any?
                return head :no_content
            end
            return render json: app.chats, status: :ok
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
            chat = Chat.where(app_id:app.id,number:params[:id]).first
            if chat == nil
            return head :not_found
            end
            return render json:chat, status: :ok
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
            chat = Chat.where(app_id:app.id,number:params[:id]).first
            if chat == nil
            return head :not_found
            end
            NumbersHelper.delete_key(chat.number)
            chat.delete
            return head :no_content
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
            chat = Chat.where(app_id:found_app.id,name:params[:name]).first
            if chat != nil
                return render json:{message:"chat with this name already exists !"}, status: :bad_request
            end
            chat = Chat.new({name:params[:name],number:NumbersHelper.get_number(params[:app_id]),app_id:found_app.id})
            if chat.valid?
                Sender.push(ENV['CHATS_MQ_NAME'],chat.to_json(:except => [ :id, :created_at, :messages_count,:updated_at ]))
            return render json: chat, status: :created
            else
              return render json: chat.errors, status: :unprocessable_entity
            end
            rescue Exception => e
              return render json: {error: e.message},status: :internal_server_error
        end
    end

    def update
        begin 
            found_app = App.find_by(token: params[:app_id])
            if found_app == nil
                return render json:{message:"invalid application token !"}, status: :bad_request
            end
            chat = Chat.where(app_id:found_app.id,number:params[:id]).first
            if chat == nil
                return head :not_found
            end
            chat.name = params[:name]
            Sender.push(ENV['CHATS_MQ_NAME'],chat.to_json(:except => [ :id, :created_at, :chats_count,:updated_at ]))
            return head :ok
        rescue Exception => e
          return render json: {error: e.message},status: :internal_server_error
        end
    end
end
