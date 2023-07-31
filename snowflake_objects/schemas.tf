resource "snowflake_schema" "schema" {
  database   = snowflake_database.simple.name
  name       = "TF_DEMO"
  provider   = snowflake.sysadmin
  is_managed = false
}