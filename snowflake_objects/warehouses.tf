resource "snowflake_warehouse" "etl" {
  name           = "ETL"
  warehouse_size = "x-small"
  provider       = snowflake.sysadmin
  auto_suspend   = 60
}

resource "snowflake_warehouse" "analysts" {
  name           = "BI_analysts"
  warehouse_size = "small"
  provider       = snowflake.sysadmin
  auto_suspend   = 60
}