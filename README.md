# aws-security
This repository is used for hands-on cloud security training.

It is based on the Terraform example 2 tier application https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier

The configuration has been modified to use default variables appropriate for Windows, and is optimised for a classroom training situation.

Prerequisites:
* Git for Windows
* AWS CLI
* Terraform

To deploy from a Windows 10 environment as the admin user:

```
$ git clone https://github.com/Celidor/aws-security
PS C:\Users\admin> cd aws-security
PS C:\Users\admin\aws-security> terraform plan
PS C:\Users\admin\aws-security> terraform apply
```

To destroy the environment:

```
PS C:\Users\admin\aws-security> terraform destroy
```
