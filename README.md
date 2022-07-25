## Dev Environment With Terraform and AWS = Work In Progress

## Prerequsities 

1. AWS Account and cli installed
2. Install Terraform
3. Edit availiability zone to yours 
4. Edit "IP address" on internet gatway resource section in main.tf
5. Check datasource.tf and edit "owner" and "tag details" to yours

## Usage

1. Configure AWS credentials and make default
2. Check providers.tf and set to AWS region of choice
3. Generate keypair to work with EC2. Run ``` ssh-keygen -t ed25519 ```
4. Copy path in bracket and leave id_ed25519 out. "i.e (foo/bar/fineboy/id_ed25519), copy only foo/bar/fineboy"
5. Paste foo/bar/fineboy/<desired_name> and press Enter.
6. Search ssh in providers.tf and edit public key path
7. Run ``` ls ~/.ssh ``` to view created keygen
8. Run ``` terraform init ```
9. Run ``` terraform plan ```
10. Run ``` terraform apply -auto-approve ``` the auto-approve tag remove the "yes" section.
 
