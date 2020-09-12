require 'base64'

class UsersController < ApplicationController
  before_action :check_user_is_admin, except: [:index, :show]

  def index
    render json: User.all.where(deleted: false)
  end

  def show
    find_record do |user|
      render json: user
    end
  end

  def create
    user = User.create permitted_params
    render json: user
  end

  def update
    find_record do |user|
      user.update permitted_params
      render json: user
    end
  end

  def destroy
    find_record do |user|
      user.deleted!
      render json: user
    end
  end

  def lock
    find_record do |user|
      user.locked!
      render json: user
    end
  end

  def unlock
    find_record do |user|
      user.unlocked!
      render json: user
    end
  end

  def import
    begin
      # assume only 1 file
      f = params[:files].first
      importer = @current_app.get(:user_importer).new(file: f)
      importer.import
      head 201
    rescue
      head 500
    end
  end

  def import_template
    data = @current_app.get(:user_importer).template
    f = File.open 'export/import-template.xls', 'rb'
    enc = Base64.encode64 f.read
    send_data enc, type: :xls, filename: 'user-import-template.xls'
  end

  def export_oos
    exporter = Exporters::OosExporter.new
    data = exporter.export
    f = File.open 'export/oos-export.xls', 'rb'
    enc = Base64.encode64 f.read
    send_data enc, type: :xls, filename: 'oos-export.xls'
  end

  def permitted_params
    return params.permit(:username, :name, :password, :importing_id)
  end

  def find_record
    user = User.find_by_id params[:id]
    if user.present?
      yield user
    else
      head 404
    end
  end

  def check_user_is_admin
    head 401 unless current_user.admin?
  end
end
