resource "aws_iam_group" "admin_group" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "admin_group_admin_access" {
  group      = "admin"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "admin" {
  force_destroy        = null
  name                 = "admin"
  path                 = "/"
  permissions_boundary = null
  tags = {
    AKIARKTULDDITPCMJFSF = "CLI"
  }
  tags_all = {
    AKIARKTULDDITPCMJFSF = "CLI"
  }
}

resource "aws_iam_user_group_membership" "admin_membership" {
  groups = ["admin"]
  user   = "admin"
}
