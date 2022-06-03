require 'digest'
class AppsController < ApplicationController
  def index
    begin
      apps = App.all
      if !apps.any?
        return render status: :no_content
      end
      return render json: apps, status: :ok
    rescue Exception => e
      return render json: {error: e.message},status: :internal_server_error
    end
  end

  def show
    begin
    app = App.find_by(token: params[:id])
    if app == nil
      return head :not_found
    end
    return render json:app, status: :ok
    rescue Exception => e
      return render json: {error: e.message},status: :internal_server_error
    end
  end

  def destroy
    begin
    app = App.find_by(token: params[:id])
    if app == nil
      return head :not_found
    end
    app.delete()
    return head :no_content
    rescue Exception => e
      return render json: {error: e.message},status: :internal_server_error
    end
  end

  def create
    begin
    found_app = App.find_by(name: params[:name])
    if found_app != nil
    return render json:{message:"App with this name already exists !"}, status: :bad_request
    end
    app = App.new({name: params[:name], token: Digest::MD5.hexdigest(params[:name]) })
    if app.valid?
    Sender.push(ENV['APPS_MQ_NAME'],app.to_json(:except => [ :id, :created_at, :chats_count,:updated_at ]))
    return render json: app, status: :created
    else
      return render json: app.errors, status: :unprocessable_entity
    end
    rescue Exception => e
      return render json: {error: e.message},status: :internal_server_error
    end
  end

  def update
    begin 
      app = App.find_by(token: params[:id])
      if app == nil
        return head :not_found
      end
      app.update(name:params[:name])
      return render json: app, status: :ok
    rescue Exception => e
      return render json: {error: e.message},status: :internal_server_error
    end
  end
      

end
