resource "template_file" "userdataweb" {
  template = "${file("${path.module}/user-data-web")}"
}
