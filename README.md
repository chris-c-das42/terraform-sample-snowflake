# Terraform Sample -- Snowflake

This project is meant to be a sample of how one can use Terraform to create, update, and delete resources and necessary in a Snowflake environment.

### What a new user needs to do:
1. Install Terraform
2. Create a GitHub repository
3. Create a Snowflake account, or have an account with ACCOUNTADMIN role
4. Create a Service User in your Snowflake account; necessary for Terraform to interact with Snowflake.  Directions here:
https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
5. Grab Snowflake account, region information loosely like they do here:
https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3
6. Be sure to update the main.auto.tfvars file as necessary with your account, region information

### Chris' to do:
1. ASK PCs, TL for direction on best practices.  That might take them some time.
2. move this to a new repo where I can start mixing in our best practices that I already know.  E.g. 3x DB for raw, transform, reporting.  2x DB.
