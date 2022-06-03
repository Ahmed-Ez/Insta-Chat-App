require 'digest'
class AppsController < ApplicationController
  def index
    @apps = App.all

    if !@apps.any?
      return render status: :no_content
    end
    return render json: @apps, status: :ok
  end

  def show
    @app = App.find_by(token: params[:id])
    if @app == nil
      return head status: :not_found
    end
    return render json:@app, status: :ok
  end

  def destroy
    @app = App.find_by(token: params[:id])
    if @app == nil
      return head :not_found
    end
    @app.delete()
    return head :no_content
  end

  def create
    app = App.new({name: params[:name], token: Digest::MD5.hexdigest(params[:name]) })

    if app.save
      Sender.push(app.to_json())
      return render json: app, status: :created
    else
      return render json: app.errors, status: :unprocessable_entity
    end
  end

end
