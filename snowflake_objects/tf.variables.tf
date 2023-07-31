/*
######## Information for CLI Use ################
If you need to run these individually in the command line, prefix with "export", e.g.:
      export SNOWFLAKE_USER="tf-snow"

######## .tfvars vs .tf -- A Choice ################
With variables we have a choice: declare variables in a variables file, eg:
   <name>.auto.tfvars or <name>.tfvars
OR, set variables in a <name>.tf file.
I went with the <name>.tf file format, because with this format we can set the value once and not update it...
   ie tfvars files do not support default values, setting descriptions in the tfvars file, etc.  You only set the value.  Then in your module .tf files (eg databases.tf) you have to declare the variables you'll use.  For some of the variables, this would be tedious.

######## Variable Files Reference ################
Important reference for Variables Files (tf.vars files):
  https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files

######## Variable Block Use ################
Note: Input variables are created by a variable block, but you reference them as attributes on an object named var.
Source: https://developer.hashicorp.com/terraform/language/values/variables#using-input-variable-values
*/

# list the required providers below (synonomous with importing required packages)
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.68"
    }
  }
}

# list the providers you use below
provider "snowflake" {
    account = var.SNOWFLAKE_ACCOUNT
    username = var.SNOWFLAKE_USER
    private_key_path = var.SNOWFLAKE_PRIVATE_KEY_PATH
    role  = "SECURITYADMIN"
    alias = "security_admin"
}

provider "snowflake" {
    account = var.SNOWFLAKE_ACCOUNT
    username = var.SNOWFLAKE_USER
    private_key_path=var.SNOWFLAKE_PRIVATE_KEY_PATH
    role = "SYSADMIN"
    alias = "sysadmin"
}

# list the input variables for this module below
variable "SNOWFLAKE_USER" {
  default = "TF-SNOW"
  description = "The user under which you want Terraform to access Snowflake.  Best practice is to create a service user, which is what we did here.  Ie this is 'tf-snow' unless changed."
  type = string
}

variable "SNOWFLAKE_PRIVATE_KEY_PATH" {
    default = "~/.ssh/snowflake_tf_snow_key.p8"
    description = "Where you saved the private key you want Terraform to use to access Snowflake."
    type = string
}

variable "SNOWFLAKE_ACCOUNT" {
    default = "MH41780.us-central1.gcp"
    description = "This is the Account_Locator, which is the account plus region information (for most regions).  For more information, see the README file."
    type = string
}