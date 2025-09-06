resource "docker_container" "docker-lab" {
  name  = "nginx-docker"
  image = docker_image.ubuntu.image_id
  tty   = true
  command = ["sleep", "infinity"]
}


resource "docker_image" "ubuntu" {
  name         = "ubuntu:20.04"
  keep_locally = true
}


resource "null_resource" "provision" {
  depends_on = [docker_container.docker-lab]

  provisioner "local-exec" {
    command = <<EOT
      docker exec nginx-docker apt-get update
      docker exec nginx-docker apt-get install -y nginx
    EOT
  }
}