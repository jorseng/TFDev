# DATA
data "terraform_remote_state" "Hub-Ref" {
  backend = "local"
  config = {
    path = "../hub/terraform.tfstate"
  }
}
