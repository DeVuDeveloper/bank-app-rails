module ContactsHelper
  extend self

  FIELDS = %i[name phone email relationship]
  NAMES = %w[Name Phone Email Relationship]

  private_constant :FIELDS, :NAMES

  def fields
    FIELDS
  end

  def fields_with_name
    FIELDS.zip NAMES
  end
end
