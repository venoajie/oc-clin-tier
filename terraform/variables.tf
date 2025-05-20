
variable "compartment_ocid" {
  description = "Target compartment OCID for encryption resources"
  type        = string
  validation {
    condition     = length(var.compartment_ocid) > 4 && substr(var.compartment_ocid, 0, 6) == "ocid1."
    error_message = "Invalid compartment OCID format."
  }
}


variable "env" {
  type        = string
  description = "Deployment environment (dev/stage/prod)"
  default     = "dev"
}