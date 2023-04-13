class ErrorSerializer
  def self.invalid_id(resource)
    {
      "error": {
        "code": 400,
        "message": "Invalid request, #{resource}_id is invalid"
      }
    }
  end

  def self.missing_parameter(param)
    {
      "error": {
        "code": 400,
        "message": "Invalid request, #{param} is a required parameter"
      }
    }
  end
end