# Intentionally empty.
#
# `required_version` and `required_providers` live in provider.tf as the single
# source of truth. Terraform only allows one `required_providers` block per
# module — declaring it here as well caused:
#   Error: Duplicate required providers configuration
#
# The S3 backend is configured in backend.tf.
