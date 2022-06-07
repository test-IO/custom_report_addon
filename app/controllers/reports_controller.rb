class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create_attachment
  before_action :find_addon

  def new
    if params[:update] == 'true'
      data = TestioApi.new(@addon).get_report(params[:report_id])
      @report_data = data['report']['content'].to_json.html_safe if data['report']
    end
    @attachment_path = create_attachment_path(@addon.key)

    @fields = @addon.fields.order(position: :asc)
  end

  def create
    payload = ReportParamsBuilder.new(@addon.fields, report_params).call

    TestioApi.new(@addon).update_report(payload, params[:report_id])

    redirect_to params[:redirection_url], allow_other_host: true
  end

  def create_attachment
    binding.pry
    payload = {}

    TestioApi.new(@addon).create_attachment(params[:report_id], payload)
  end

  private

  def find_addon
    @addon = Addon.find_by_key!(params[:id])
  end

  def report_params
    params.permit(@addon.fields.pluck(:key))
  end
end
