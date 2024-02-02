data "aws_secretsmanager_secret" "db_credentials" {
  name = "nebula_db_credentials"
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

data "aws_secretsmanager_secret" "secret_key" {
  name = "SECRET_KEY"
}

data "aws_secretsmanager_secret_version" "secret_key" {
  secret_id = data.aws_secretsmanager_secret.secret_key.id
}