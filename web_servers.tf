resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index}"
  hostname    = "web-${count.index}"
  platform_id = "standard-v1"
  zone        = element(["ru-central1-a", "ru-central1-a"], count.index)

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd89r7tf1kehpogd5bgt" # Ubuntu 24.04
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
