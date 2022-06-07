class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create_attachment
  before_action :find_addon

  def new
    @report_id = params[:report_id]

    if params[:update] == 'true'
      data = TestioApi.new(@addon).get_report(@report_id)

      if data['report']
        @report_attachments = data['report']['attachments']
        @report_data = data['report']['content'].to_json.html_safe
      end
    end

    payload = { iss: @addon.client_key, iat: Time.current.to_i }
    @jwt_token = JWT.encode payload, @addon.shared_secret_key, 'HS256'
    @attachment_path = "#{Settings.testio_base_url}/addon_api/reports/#{@report_id}/attachments"

    @fields = @addon.fields.order(position: :asc)
  end

  def create
    payload = ReportParamsBuilder.new(@addon.fields, report_params).call

    TestioApi.new(@addon).update_report(payload, params[:report_id])

    redirect_to params[:redirection_url], allow_other_host: true
  end

  private

  def find_addon
    @addon = Addon.find_by_key!(params[:id])
  end

  def report_params
    params.permit(@addon.fields.pluck(:key))
  end
end
