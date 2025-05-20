# HIPAA-Compliant Encryption Setup
# -------------------------------
# Creates a KMS vault and encryption key for patient data
# Free-tier eligible (VIRTUAL_PRIVATE vault type)

# Virtual vault for managing encryption keys
resource "oci_kms_vault" "clinic_vault" {
  compartment_id = var.compartment_ocid  # Target compartment OCID
  display_name   = "clinic-hipaa-vault" # Case-sensitive display name
  vault_type     = "VIRTUAL_PRIVATE"    # Free tier option (not DEFAULT)
}

# Master encryption key for patient data
resource "oci_kms_key" "patient_data_key" {
  compartment_id = var.compartment_ocid
  display_name   = "patient-data-key"   # Must be unique per compartment
  
  # 256-bit AES encryption (HIPAA minimum requirement)
  key_shape {
    algorithm = "AES"  
    length    = 256     # Key size in bits
  }

  # Vault connection (must exist before key creation)
  management_endpoint = oci_kms_vault.clinic_vault.management_endpoint

  # Automatic key rotation (HIPAA §164.312(a)(2)(iv))
  rotation_interval_in_days = 90 # Rotates every 3 months
}

# Output the key OCID for application integration
output "kms_key_ocid" {
  description = "OCID of the patient data encryption key"
  value       = oci_kms_key.patient_data_key.id
}