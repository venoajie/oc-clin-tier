# HIPAA Encryption Module
# ======================
# Manages KMS vault and encryption keys for patient data
# Free-tier compatible (VIRTUAL_PRIVATE vault type)

# Key Vault Configuration
# ----------------------
resource "oci_kms_vault" "clinic_vault" {
  compartment_id = var.compartment_ocid  # Required: Target compartment OCID
  display_name   = "clinic-hipaa-vault-${var.env}"  # Environment-aware naming
  vault_type     = "VIRTUAL_PRIVATE"    # Free tier option (avoid "DEFAULT")

  lifecycle {
    prevent_destroy = true  # Critical: Prevents accidental deletion
  }
}

# Master Encryption Key
# --------------------
resource "oci_kms_key" "patient_data_key" {
  compartment_id = var.compartment_ocid
  display_name   = "patient-data-key-${var.env}"  # Unique per environment

  # 256-bit AES-CBC (HIPAA Minimum Standard)
  key_shape {
    algorithm = "AES"
    length    = 256  # Bits
  }

  # Vault association (implicit dependency)
  management_endpoint = oci_kms_vault.clinic_vault.management_endpoint

  # Automatic rotation (HIPAA §164.312(a)(2)(iv))
  rotation_interval_in_days = 90  # Quarterly rotation

  lifecycle {
    ignore_changes = [rotation_interval_in_days]  # Allow manual rotations
  }
}

# Outputs for Integration
# ----------------------
output "kms_vault_ocid" {
  description = "OCID of the HIPAA-compliant vault"
  value       = oci_kms_vault.clinic_vault.id
}

output "data_key_ocid" {
  description = "OCID of the patient data encryption key"
  value       = oci_kms_key.patient_data_key.id
  sensitive   = true  # Marks output as sensitive in logs
}