### Important! ### 
# You must fill in the form at https://download.looker.com/validate to validate your license key and accept the EULA before running this script
variable "looker_license_key" {
  default = "" # your Looker license key
}

variable "technical_contact_email" {
  default = "" # your organization's technical contact for Looker
}

variable "aws_region" {
    default = "us-east-1"
}

variable "instances" {
    default = 2
}

variable "ec2_instance_type" {
    default = "t2.medium"
}

variable "ami_id" {
    default = "ami-07ebfd5b3428b6f4d" # Ubuntu 18.04 x86
}

variable "provisioning_script" {
    default = "setup.sh" # The setup script must match the AMI above!
}

variable "key" {
    default = "id_rsa"
}
