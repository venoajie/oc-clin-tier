# Always Free Autonomous DB
resource "oci_database_autonomous_database" "clinic_db" {
  compartment_id   = var.compartment_ocid
  db_name         = "CLINICDB"
  cpu_core_count  = 1
  data_storage_size_in_tbs = 1  # 20GB max (free)
  is_free_tier    = true        # Critical for free tier
  db_workload     = "JSON"
}

# Free-tier eligible VM
resource "oci_core_instance" "app_server" {
  compartment_id = var.compartment_ocid
  shape          = "VM.Standard.E2.1"  # Free shape
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  shape_config {
    ocpus         = 1  # Free tier allows 1 OCPU
    memory_in_gbs = 8  # Must be ≤8GB for free
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }
}