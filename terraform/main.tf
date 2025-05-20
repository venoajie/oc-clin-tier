
provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaapk5a76iob5ujd7byfio3cmfosyj363ogf4hjmti6zm5ojksexgzq"
  user_ocid        = "ocid1.user.oc1..aaaaaaaa2fx3phwcpu5uhmxxcvpkwciuoh5uqktu65kzqq7pte3xki6wjthq"
  fingerprint      = "47:09:4b:9e:3c:0a:fa:ab:33:d3:8f:e9:b3:d0:06:60"
  private_key_path = "/home/ubuntu/.oci/oci_api_key.pem"
  region           = "eu-frankfurt-1"
}

# Always Free Autonomous DB
resource "oci_database_autonomous_database" "clinic_db" {
  compartment_id   = "ocid1.tenancy.oc1..aaaaaaaapk5a76iob5ujd7byfio3cmfosyj363ogf4hjmti6zm5ojksexgzq"
  db_name         = "CLINICDB"
  cpu_core_count  = 1
  data_storage_size_in_tbs = 1  # 20GB max (free)
  is_free_tier    = true        # Critical for free tier
  db_workload     = "JSON"
}

# Free-tier eligible VM
resource "oci_core_instance" "app_server" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaapk5a76iob5ujd7byfio3cmfosyj363ogf4hjmti6zm5ojksexgzq"
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

resource "oci_budgets_budget" "free_guard" {
  compartment_id = var.tenancy_ocid
  amount         = 10  # USD threshold
  reset_period   = "MONTHLY"
}