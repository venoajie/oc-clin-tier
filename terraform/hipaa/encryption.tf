# =============================================
# HIPAA-COMPLIANT ENCRYPTION FOR PATIENT DATA
# =============================================
# This file creates:
# 1. A secure vault to manage encryption keys
# 2. A master key for encrypting patient records
# All resources are Oracle Cloud Free Tier eligible

# --------------------------
# STEP 1: CREATE THE VAULT
# --------------------------
resource "oci_kms_vault" "clinic_vault" {
  # Where to create the vault (replace with your compartment OCID)
  compartment_id = var.compartment_ocid  
  
  # Name it something recognizable
  display_name   = "clinic-hipaa-vault" 
  
  # MUST be "VIRTUAL_PRIVATE" for free tier
  vault_type     = "VIRTUAL_PRIVATE"    

  # Safety lock - prevents accidental deletion
  lifecycle {
    prevent_destroy = true  
  }
}

# --------------------------
# STEP 2: CREATE ENCRYPTION KEY 
# --------------------------
resource "oci_kms_key" "patient_data_key" {
  # Same compartment as the vault
  compartment_id = var.compartment_ocid
  
  # Clearly name the key
  display_name   = "patient-data-key"   

  # Encryption settings (HIPAA requires 256-bit AES)
  key_shape {
    algorithm = "AES"  # Advanced Encryption Standard
    length    = 256     # Key size in bits (stronger than 128)
  }

  # Connect this key to our vault
  management_endpoint = oci_kms_vault.clinic_vault.management_endpoint

  # Rotate key every 90 days (HIPAA best practice)
  rotation_interval_in_days = 90  
}

# --------------------------
# STEP 3: OUTPUT IMPORTANT INFO
# --------------------------
output "vault_id" {
  description = "ID of the encryption vault (needed for database setup)"
  value       = oci_kms_vault.clinic_vault.id
}

output "key_id" {
  description = "ID of the patient data encryption key (keep secret!)"
  value       = oci_kms_key.patient_data_key.id
  sensitive   = true  # Hides this from logs
}