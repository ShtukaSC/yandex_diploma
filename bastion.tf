resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
  hostname    = "bastion"
  platform_id = "standard-v1"
  zone        = var.region

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
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${var.ssh_public_key}"
    user-data = file("${path.module}/scripts/bastion_cloud_init.yaml")
  }
}
