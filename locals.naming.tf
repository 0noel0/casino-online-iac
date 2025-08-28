# --- Naming convention helper: nombreRecurso-proyecto-operacion-num-region ---
locals {
  name_prefix = "${var.project}-${var.operation}-${format("%02d", var.num)}-${var.region}"
}
