# This project installed confluence 9.2 on aws
Prerequisites:
 1. ec2 instances should be Amazon Linux 2023 AMI
 2. During installation, you need to disable load balancer health checks and make sure you don’t open multiple tabs that point to the same Confluence URL.
 issue: https://jira.atlassian.com/browse/CONFSERVER-61189
 3. This project is base on following link
https://confluence.atlassian.com/doc/installing-confluence-on-linux-from-archive-file-255362363.html
 4. Create ec2 ssh key in aws called devops-key
 5. Create a KMS key and replace with db_pass in terraform variable file
 and i db.pwd in ansible variable file
 6. update ansible inventory file as per your environment
 7. Following command to create DynamoDB table for terraform state lock
 
> aws dynamodb create-table \
     --table-name terraform-lock-table \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
8. Make a connection to the load balancer after completion of ansible playbook
9. Once you filled all the required forms and then wait to confluence to initialize. Use confluencedb as database name when setting up your database 
10. Copy confluence.cfg.xml from primary to secondary server (make sure user and group of confluence.cf.xml must be confluence on secondary)

 
 
 