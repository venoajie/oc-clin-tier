resource "oci_core_security_list" "app_ports" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main_vcn.id

  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    tcp_options { min = 8501 max = 8501 }
  }
}