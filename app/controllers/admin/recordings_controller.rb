# frozen_string_literal: true

class Admin::RecordingsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_appearance
  before_action :set_recording, only: %i[show edit update destroy]

  def index
    @recordings = @appearance.recordings.order(:title)
  end

  def show
  end

  def new
    @recording = @appearance.recordings.build
  end

  def edit
  end

  def create
    @recording = @appearance.recordings.build(recording_params)
    if @recording.save
      redirect_to admin_appearance_url(@appearance), notice: "Recording was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @recording.update(recording_params)
      redirect_to admin_appearance_url(@appearance), notice: "Recording was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @recording.destroy
    redirect_to admin_appearance_url(@appearance), notice: "Recording was successfully destroyed."
  end

  private

  def set_appearance
    @appearance = Appearance.friendly.find(params[:appearance_id])
  end

  def set_recording
    @recording = @appearance.recordings.friendly.find(params[:id])
  end

  def recording_params
    params.require(:recording).permit(
      :title, :url, :recorded_on, :notes, :embedded, :embed_host, :embed_code, :talk_id
    )
  end
end
