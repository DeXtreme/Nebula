data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_ecr_repository" "repo" {
  name         = local.ecr_repo_name
  force_delete = true

  tags = {
    Terraform = true
  }
}

resource "docker_image" "image" {
  name = aws_ecr_repository.repo.repository_url
  build {
    context = "../api/"
    dockerfile = "dockerfile"
    labels = {
      author = "Emmanuel"
    }
  }

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "../api/*") : filesha1(f)]))
  }
}

resource "docker_registry_image" "image" {
  name = docker_image.image.name

  lifecycle {
    replace_triggered_by = [ docker_image.image.image_id ]
  }
}
