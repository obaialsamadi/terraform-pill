# Terraform Pill

In a nutshell, my job involves a lot of testing and experimentation, and spinning instances up and down manually is a literal nightmare (when you need to spin them 
up or down). 

My workplace also deals with GCP, so this is a simple Terraform module that makes spinning them up and down very easy and can be intergrated into Ansible
or any other workflow easily. It is my terraform pill for my headaches.

**NOTES**:
- in `main.tf`, add your json creds
- in `variable.tf`, add your user name, playground name, and add the path to your ssh keys

The beauty of this is that's literally all you have to do, my files will take care of everything else, just `terraform init,apply, and destroy` as you please.
