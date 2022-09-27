module PersonsHelper
  FIELDS = %i[name person_id phone address]
  NAMES = %w[Name ID Number Phone Address]

  private_constant :FIELDS, :NAMES

  def fields
    FIELDS
  end

  def fields_with_name
    FIELDS.zip NAMES
  end
end
