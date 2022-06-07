class AddonsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:install, :uninstall]

  before_action :find_addon

  def install
    @addon.client_key = params[:client_key]
    @addon.shared_secret_key = params[:shared_secret_key]
    @addon.install!

    render json: { head: :ok }
  end

  def uninstall
    @addon.uninstall!

    render json: { head: :ok }
  end

  def descriptor
    render json: {
      key: @addon.key,
      title: @addon.title,
      base_url: Settings.host,
      installation_webhook_path: addon_install_path(@addon.key),
      uninstallation_webhook_path: addon_uninstall_path(@addon.key),
      new_report_path: new_report_path(@addon.key)
    }
  end

  private

  def find_addon
    @addon = Addon.find_by_key!(params[:id])
  end
end
