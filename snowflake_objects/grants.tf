resource "snowflake_grant_privileges_to_role" "database_grant" {
provider   = snowflake.security_admin
privileges = ["USAGE"]
role_name  = snowflake_role.role.name
on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.simple.name
}
}

resource "snowflake_grant_privileges_to_role" "schema_grant" {
provider   = snowflake.security_admin
privileges = ["USAGE"]
role_name  = snowflake_role.role.name
on_schema {
    schema_name = "\"${snowflake_database.simple.name}\".\"${snowflake_schema.schema.name}\""
}
}

resource "snowflake_grant_privileges_to_role" "warehouse_grant" {
provider   = snowflake.security_admin
privileges = ["USAGE"]
role_name  = snowflake_role.role.name
on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.etl.name
}
}

resource "snowflake_grant_privileges_to_role" "user_grant" {
provider   = snowflake.security_admin
privileges = ["MONITOR"]
role_name  = snowflake_role.role.name
on_account_object {
    object_type = "USER"
    object_name = snowflake_user.user.name
}
}

resource "snowflake_role_grants" "grants" {
provider  = snowflake.security_admin
role_name = snowflake_role.role.name
users     = [snowflake_user.user.name]
}