data "template_file" "linux-metadata" {
    template = file("${path.module}/scripts/startup-script.sh")

    vars = {
        company  = var.company
        app_name = var.app_name
    }
}
