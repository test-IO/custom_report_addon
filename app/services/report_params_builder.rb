class ReportParamsBuilder
  attr_reader :addon_fields, :form_params

  def initialize(addon_fields, form_params)
    @addon_fields = addon_fields.where.not(data_type: :file)
    @form_params = form_params
  end

  def call
    {
      report: {
        title: 'REPORT TITLE!!!!!!',
        content: fields_data
      }
    }
  end

  private

  def fields_data
    {
      data: addon_fields.map do |field|
        {
          key: field.key,
          name: field.name,
          type: field.data_type,
          value: form_params[field.key],
          position: field.position
        }
      end
    }
  end
end
