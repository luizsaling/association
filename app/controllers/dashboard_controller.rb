require Rails.root.join('app/services/dashboard_service')

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @dashboard_data = DashboardService.new(current_user).dashboard_data
  end
end
