
variable "compartment_ocid" {
  description = "OCI compartment for HIPAA resources"
  type        = string
  validation {
    condition     = length(var.compartment_ocid) > 4 && substr(var.compartment_ocid, 0, 6) == "ocid1."
    error_message = "Invalid compartment OCID format."
  }
}
