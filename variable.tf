variable "cluster_size" {
  type        = number
  description = "how many instances to create"
  default     = 5
}

variable "gcp_region" {
  description = "Region in which instance is created."
  default     = "us-central1"
}
variable "network_project_id" {
  description = <<EOF
  The name of the GCP Project where the network is located. 
  Useful when using networks shared between projects. 
  If empty, var.gcp_project_id will be used."
  EOF
  type        = string
  default     = null
}
variable "network_name" {
  type    = string
  default = "default"
}
variable "subnetwork_name" {
  type    = string
  default = null
}
variable "instance_name" {
  description = "The name given to the instances created that show up on GCP"
  default = "instance"
}
variable "gcp_project_id" {
  type    = string
  default = "<playground-name>"
}

variable "gcp_machine_type" {
  default     = "n1-standard-2"
  description = "Instance machine type"
}

variable "gcp_zone" {
  default     = "us-central1-a"
  description = "Google Compute Engine zone to launch instances in"
}

variable "disk_image" {
  default     = "debian-cloud/debian-10"
  description = "Disk image type."
}
variable "disk_size" {
  default     = "150"
  description = "Instance disk size"
}
variable "disk_type" {
  default     = "pd-ssd"
  description = "Instance disk type. Can be pd-standard or pd-ssd"
}

variable "ssh_keys" {
  type = list(object({
    user        = string
    public_key  = string
    private_key = string
  }))
  default = [
    {
      user        = "bot"
      public_key  = "/home/obai/.ssh/id_rsa.pub"
      private_key = "/home/obai/.ssh/id_rsa"
    }
  ]
}
variable "ssh_key_private" {
  default = "/home/obai/.ssh/id_rsa"
}
variable "firewall_tag" {
  type = list(string)
  description = "keywords from GCP firewall rules. They open ports 80 and 443."
  default     = ["http-server", "https-server"]
}
variable "upstream_port" {
  default = 8080
}
