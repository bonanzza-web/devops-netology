locals {
  vm_web = "${ var.vm_env }-${ var.web_role }"
  vm_db= "${ var.vm_env }-${ var.db_role }"
}
