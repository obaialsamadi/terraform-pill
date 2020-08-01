output "external-ips" {
  value = tolist(google_compute_instance.gcp_instance.*.network_interface.0.access_config.0.nat_ip)
//   value = google_compute_instance.master_test.*.network_interface.0.access_config.0.nat_ip
}