/*
In main.tf we set up the provider and define the configuration 
for the database and the warehouse that we want Terraform to create.
*/
# list the required providers below

terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.68"
    }
  }
}


# next, before we can create resources, we need to declare our variables for this module
variable "SNOWFLAKE_USER"{
    type = string
}

variable "SNOWFLAKE_PRIVATE_KEY_PATH"{
    type = string
}

variable "SNOWFLAKE_ACCOUNT"{
    type = string
}


# first, execute operations as the SYSADMIN
#   ie, create objects (db, wh, schemas, tables, etc)
provider "snowflake" {
    account = var.SNOWFLAKE_ACCOUNT
    username = var.SNOWFLAKE_USER
    private_key_path=var.SNOWFLAKE_PRIVATE_KEY_PATH
    role = "SYSADMIN"
}

resource "snowflake_database" "simple" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "small"
  auto_suspend   = 60
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.simple.name
  name       = "TF_DEMO"
  is_managed = false
}


# second, execute operations as the SECURITYADMIN
#   eg:
#       grant privileges to roles
#       create users
#       grant roles to users

provider "snowflake" {
    account = var.SNOWFLAKE_ACCOUNT
    username = var.SNOWFLAKE_USER
    private_key_path = var.SNOWFLAKE_PRIVATE_KEY_PATH
    alias = "security_admin"
    role  = "SECURITYADMIN"
}

    resource "snowflake_role" "role" {
    provider = snowflake.security_admin
    name     = "TF_DEMO_SVC_ROLE"
    }

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
            object_name = snowflake_warehouse.warehouse.name
        }
        }

    resource "tls_private_key" "svc_key" {
    algorithm = "RSA"
    rsa_bits  = 2048
    }

    resource "snowflake_user" "user" {
        provider          = snowflake.security_admin
        name              = "tf_demo_user"
        default_warehouse = snowflake_warehouse.warehouse.name
        default_role      = snowflake_role.role.name
        default_namespace = "${snowflake_database.simple.name}.${snowflake_schema.schema.name}"
        rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
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