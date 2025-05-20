# Enable OCI Vault for encryption keys
resource "oci_kms_vault" "clinic_vault" {
  compartment_id = var.compartment_ocid
  display_name  = "clinic-hipaa-vault"
  vault_type    = "VIRTUAL_PRIVATE"  # Free tier eligible
}

# Create master encryption key
resource "oci_kms_key" "patient_data_key" {
  compartment_id = var.compartment_ocid
  display_name  = "patient-data-key"
  key_shape {
    algorithm = "AES"
    length    = 256  # HIPAA minimum requirement
  }
  management_endpoint = oci_kms_vault.clinic_vault.management_endpoint

  # Auto-rotate every 90 days (HIPAA recommendation)
  rotation_interval_in_days = 90
}

# Encrypt Autonomous Database
resource "oci_database_autonomous_database_keystore" "db_encryption" {
  autonomous_database_id = oci_database_autonomous_database.clinic_db.id
  key_store_id          = oci_kms_vault.clinic_vault.id
}

resource "oci_kms_vault" "clinic_vault" {
  compartment_id = var.compartment_ocid
  display_name  = "clinic-hipaa-vault"
  vault_type    = "VIRTUAL_PRIVATE"
}

# Add to bottom of encryption.tf
output "key_ocid" {
  value = oci_kms_key.patient_data_key.id
}