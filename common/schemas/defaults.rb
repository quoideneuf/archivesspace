accession_browse_column_enum = [
                      "identifier", "accession_date", "acquisition_type", "resource_type",
                      "restrictions_apply", "access_restrictions", "use_restrictions",
                      "publish", 'no_value'
                     ]
resource_browse_column_enum = [
                      "identifier", "resource_type", "level", "language", "restrictions",
                      "ead_id", "finding_aid_status", "publish", 'no_value'
                     ]
{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "properties" => {

      "show_suppressed" =>  {"type" => "boolean", "required" => false},
      "publish" =>  {"type" => "boolean", "required" => false},

      "accession_browse_column_1" => {
        "type" => "string",
        "enum" => accession_browse_column_enum,
        "required" => false
      },
      "accession_browse_column_2" => {
        "type" => "string",
        "enum" => accession_browse_column_enum,
        "required" => false
      },
      "accession_browse_column_3" => {
        "type" => "string",
        "enum" => accession_browse_column_enum,
        "required" => false
      },
      "accession_browse_column_4" => {
        "type" => "string",
        "enum" => accession_browse_column_enum,
        "required" => false
      },
      "accession_browse_column_5" => {
        "type" => "string",
        "enum" => accession_browse_column_enum,
        "required" => false
      },

      "resource_browse_column_1" => {
        "type" => "string",
        "enum" => resource_browse_column_enum,
        "required" => false
      },
      "resource_browse_column_2" => {
        "type" => "string",
        "enum" => resource_browse_column_enum,
        "required" => false
      },
      "resource_browse_column_3" => {
        "type" => "string",
        "enum" => resource_browse_column_enum,
        "required" => false
      },
      "resource_browse_column_4" => {
        "type" => "string",
        "enum" => resource_browse_column_enum,
        "required" => false
      },
      "resource_browse_column_5" => {
        "type" => "string",
        "enum" => resource_browse_column_enum,
        "required" => false
      },

    },
  },
}
