# AWS Terraform
This project show cases how we use terraform to manage aws resources like ec2 instances, routes, vpc and subnets.
In a similar way we can set up gateways, security groups and much more.

## Requirements
* You must have Terraform installed on your computer.
* You must have an AWS (Amazon Web Services) account.
* It uses the Terraform AWS Provider that interacts with the many resources supported by AWS through its APIs.
  
## Using the code
* [Refer this page](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html)
* Configure your AWS access keys.
  
  Important: For security, it is strongly recommend that you use IAM users instead of the root account for AWS access.
  - Set up your credentials and providers
    
    Setting your credentials for use by Terraform can be done in a number of ways, but here are the recommended approaches:

  - The default credentials file

    Set credentials in the AWS credentials profile file on your local system, located at:

    `~/.aws/credentials` on Linux, macOS, or Unix

    `C:\Users\USERNAME\.aws\credentials` on Windows

    This file should contain lines in the following format:
    ```tf
       [default]
       aws_access_key_id = <your_access_key_id>
       aws_secret_access_key = <your_secret_access_key>
    ```

    Substitute your own AWS credentials values for the values `<your_access_key_id>` and `<your_secret_access_key>` or configure it in the providers.tf file.

* Environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

    Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

    To set these variables on Linux, macOS, or Unix, use `export`:
    ```ubuntu
    export AWS_ACCESS_KEY_ID=<your_access_key_id>
    export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    ```
    To set these variables on Windows, use set:
    ```cmd
    set AWS_ACCESS_KEY_ID=<your_access_key_id>
    set AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    ```
* Initialize working directory.
  To start working on your project right away, please set up the access key and secret key in providers.tf file and follow these commands.

  From your command line:
  ```bash
  # Clone this repository
  git clone https://github.com/HimanthReddyGurram/Terraform_AWS.git
  
  # Go into the repository
  $ cd Terraform_AWS.git
  ```

    The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.
    ```
    terraform init
    ```
* Validate the changes.
    
    Run command:
    ```
    terraform plan
    ```
* Deploy the changes.
    
    Run command:
    ```
    terraform apply
    ```
* Test the deploy.

    When the `terraform apply` command completes, use the AWS console, you should see the new resources created.

* Clean up the resources created.

    When you have finished, run command:
    ```
    terraform destroy
    ```

## Other commands
```
# just prints the output parameters
terraform output

# just refreshes the state and print output values if any
terraform refresh

# only deletes a specific resource (ex: terraform destroy -target aws_instance.him_instance)
terraform destroy -target <instance_name>.<given_name>

# only creates a specific resource
terraform apply -target <instance_name>.<given_name>

# show all the resources
terraform state list

# show details about a specific resource
terraform state show <resource>
```

## Error Reference
* If you have any errors while using this repository
  - Please know that ami instances can change and so does related values and you can change that in datasources.tf file or can update id accordingly and same goes for other resources/attributes.
  - If you cannot reference variables, just declare them directly as they are only provided for learning purposes and can the repository will work fine without referencing.
  - Uncomment the comment blocks in the code only when you have a grip on terraform as un-commenting blocks require commenting other blocks of code for the repository to work properly.
* If you cannot see the output by using public ip address, use 'http' instead of 'https'.
* Please check security groups if you cannot ssh into your instance.
