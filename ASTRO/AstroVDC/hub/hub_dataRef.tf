# DATA
data "terraform_remote_state" "Prod-Ref" {
  backend = "local"
  config = {
    path = "../prod/terraform.tfstate"
  }
}
