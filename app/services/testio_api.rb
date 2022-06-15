class TestioApi
  include HTTParty

  base_uri Settings.testio_base_url

  raise_on [500, 422, 404, 403, 400, 401]

  def initialize(addon)
    payload = { iss: addon.client_key, iat: Time.current.to_i }
    jwt_token = JWT.encode payload, addon.shared_secret_key, 'HS256'
    @options = { headers: { 'Authorization' => "JWT #{jwt_token}" } }
  end

  def update_report(payload, report_id)
    self.class.put("/addon_api/reports/#{report_id}", @options.merge(body: payload))
  end

  def get_report(report_id)
    self.class.get("/addon_api/reports/#{report_id}", @options)
  end

  def create_attachment(report_id, payload)
    self.class.post("/addon_api/reports/#{report_id}/attachments", @options.merge(body: payload))
  end
end
