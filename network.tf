resource "yandex_vpc_network" "main" {
  name = "main-network"
  timeouts {
    create = "1m"
  }
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.region
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.region
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

