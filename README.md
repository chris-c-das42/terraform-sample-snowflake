# Terraform Sample -- Snowflake
This project is meant to be a sample of how one can use Terraform to create, update, and delete resources and necessary in a Snowflake environment.

### New user setup
1. [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
2. Clone this repository, and work with it locally, or copy it to a new GitHub repository
3. Create a Snowflake account, or otherwise make sure you have a Snowflake account with ACCOUNTADMIN role
    - Ie an account you're certain you can freely manage (create, alter, drop) all resources
4. Create a Service User in your Snowflake account; necessary for Terraform to interact with Snowflake.  Directions here:
https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
5. Grab Snowflake account, region information (outlined below in Account Locator Information)
6. Be sure to update the [variables file](snowflake_objects/variables.tf) file as necessary with your account, region information

### Account Locator information
The Snowflake_Account variable is the Account Locator, which is more than just your account.  Here is how to find it:
Run the following query in a Snowflake worksheet to get the information you will need:
        SELECT 
            current_account() as YOUR_ACCOUNT_LOCATOR
            , current_region() as YOUR_SNOWFLAKE_REGION_ID
        ;
    Format your results from the query above according to this Snowflake documentation:
        https://docs.snowflake.com/en/user-guide/admin-account-identifier#non-vps-account-locator-formats-by-cloud-platform-and-region

### Common Terraform commands
Once you've successfully run through "New User Setup" (above), here are some helpful commands for initializing, planning, etc. with Terraform
- terraform init
- terraform validate
- terraform plan
- terraform apply 
- terraform apply -var-file="variables.tfvars" 
    - optional argument if one replaces the variables.tf with <name>.tfvars files but does not use <name>.auto.tfvars then this is required to specify you want the file used
- terraform init -upgrade
    - used when the dependencies in the lock file are no longer sufficient because of a change to the objects you're using from the package provider
    - eg happened when I added requirement to create TLS private key for the new user

### A note on structure of this project
In typical Terraform structure the root module (main.tf in the root folder of the project) contains either the resources to generate, or calls to subordinate child modules.

For this project, the root module only calls one child module (snowflake_objects) where the module was disaggregated into an object-oriented file structure (databases, schemas, tables, warehouses, users, roles, grants).
