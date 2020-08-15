class HealthController < ApplicationController
  def health
    render plain: 'ok'
  end
end
