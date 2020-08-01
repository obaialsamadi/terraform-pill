resource "google_compute_project_metadata" "ssh_injector" {
  metadata = merge(
    {
      ssh-keys = join("\n", [for k, v in var.ssh_keys : "${var.ssh_keys[k].user}:${file("${var.ssh_keys[k].public_key}")}"])
    }
  )
}

provider "google" {
  version = "3.22.0"
  # use your credentials here
  credentials = file("<path-to-cred-file>")

  project = "${var.gcp_project_id}"
  region  = "${var.gcp_region}"
  zone    = "${var.gcp_zone}"
}
resource "google_compute_instance" "gcp_instance" {

  depends_on   = [google_compute_project_metadata.ssh_injector]
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.gcp_machine_type}"
  count        = "${var.cluster_size}"
  zone         = "${var.gcp_zone}"
  tags         = "${var.firewall_tag}"
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.disk_size}"
      type  = "${var.disk_type}"
    }
  }
  network_interface {
    network            = var.subnetwork_name != null ? null : var.network_name
    subnetwork         = var.subnetwork_name != null ? var.subnetwork_name : null
    subnetwork_project = var.network_project_id != null ? var.network_project_id : var.gcp_project_id
    access_config {
      nat_ip = ""
    }
  }
  metadata = merge(

    {
      ssh-keys = "${var.ssh_keys[0].user}:${file("${var.ssh_keys[0].public_key}")}"
    }
  )
}
// resource "google_compute_address" "static" {
//  name = "ipv4-address"
// } 
resource "google_compute_firewall" "default" {
 name    = "tak-firewall"
 network = "default"

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["80", "22", "443","8080"]
 }
 source_ranges = ["0.0.0.0/0"]
}

resource "null_resource" "extract_ip" {
triggers = {
foo = "buzz"
}
count = "${var.cluster_size}"

provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]
    connection {
        host        = google_compute_instance.gcp_instance[count.index].network_interface[0].access_config[0].nat_ip
        type        = "ssh"
        user        = var.ssh_keys[0].user
        private_key = "${file(var.ssh_key_private)}"
        timeout     = "2m"
    }
}

//   // provisioner "local-exec" {
//   //   command = "echo ${google_compute_instance.gcp_instance.*.network_interface.0.access_config.0.nat_ip} >> /home/obai/Documents/tak/ansible/alternative/inventories/staging/hosts"
//   // }
//   provisioner "local-exec" {
//     command = "echo $(terraform output external-ips) | grep -Eo '([0-9]{1,3}\\.){3}[0-9]{1,3}'| sort | uniq >> /home/obai/Documents/KAT/ansible/inventories/staging/hosts"
//   }  

}
