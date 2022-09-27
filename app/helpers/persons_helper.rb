module PersonsHelper
  FIELDS = %i[name person_id phone address].freeze
  NAMES = %w[Name ID Number Phone Address].freeze

  private_constant :FIELDS, :NAMES

  def fields
    FIELDS
  end

  def fields_with_name
    FIELDS.zip NAMES
  end
end
