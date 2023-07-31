resource "snowflake_database" "simple" {
  name      = "TF_DEMO"
  provider  = snowflake.sysadmin
}