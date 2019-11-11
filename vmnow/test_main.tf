module "vm1" {
  source  = "./modules/vmnow"
  virtual_machine = var.vm1
}

# module "tfs" {
#   source  = "./modules/vmnow2"
#   vmset   = var.tfs
# }