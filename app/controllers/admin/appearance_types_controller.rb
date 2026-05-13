# frozen_string_literal: true

class Admin::AppearanceTypesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_appearance_type, only: %i[edit update destroy]

  def index
    @appearance_types = AppearanceType.order(:title)
  end

  def new
    @appearance_type = AppearanceType.new
  end

  def edit
  end

  def create
    @appearance_type = AppearanceType.new(appearance_type_params)
    if @appearance_type.save
      redirect_to admin_appearance_types_url, notice: "Appearance type was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @appearance_type.update(appearance_type_params)
      redirect_to admin_appearance_types_url, notice: "Appearance type was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    count = @appearance_type.appearances.size
    if count.positive?
      label = count == 1 ? "1 appearance" : "#{count} appearances"
      redirect_to admin_appearance_types_url,
                  alert: "Cannot delete — #{label} still use this type."
    else
      @appearance_type.destroy
      redirect_to admin_appearance_types_url, notice: "Appearance type was successfully destroyed."
    end
  end

  private

  def set_appearance_type
    @appearance_type = AppearanceType.friendly.find(params[:id])
  end

  def appearance_type_params
    params.require(:appearance_type).permit(:title, :slug)
  end
end
