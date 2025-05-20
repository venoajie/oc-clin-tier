#!/bin/bash
# Stops non-critical dev resources nightly

INSTANCE_OCID=$(terraform -chdir=terraform output -raw instance_ocid)

oci compute instance action \
  --instance-id $INSTANCE_OCID \
  --action SOFTRESET  # Preserves boot volume