resource "snowflake_role" "role" {
provider = snowflake.security_admin
name     = "TF_DEMO_SVC_ROLE"
}