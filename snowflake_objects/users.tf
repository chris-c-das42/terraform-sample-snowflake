resource "tls_private_key" "svc_key" {
algorithm = "RSA"
rsa_bits  = 2048
}

resource "snowflake_user" "user" {
    provider          = snowflake.security_admin
    name              = "tf_demo_user"
    default_warehouse = snowflake_warehouse.etl.name
    default_role      = snowflake_role.role.name
    default_namespace = "${snowflake_database.simple.name}.${snowflake_schema.schema.name}"
    rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}