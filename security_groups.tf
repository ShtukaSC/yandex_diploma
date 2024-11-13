variable "network_id" {
  description = "ID сети"
  type        = string
  default     = "enpfvfcpvajoa2sspq18"
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.main.id
  ingress {
    description    = "Allow HTTPS traffic"
    protocol       = "tcp"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить доступ со всего интернета
  }

  ingress {
    description    = "Allow HTTP traffic"
    protocol       = "tcp"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить доступ со всего интернета
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "any"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить исходящий доступ ко всему интернету
  }
}

resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description    = "Allow SSH traffic"
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить доступ к SSH со всех IP
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "any"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить исходящий доступ ко всему интернету
  }
}


resource "yandex_vpc_security_group" "db_sg" {
  name       = "db-sg"
  network_id = yandex_vpc_network.main.id
  ingress {
    description       = "Allow PostgreSQL traffic from web_sg"
    protocol          = "tcp"
    port              = 5432
    security_group_id = yandex_vpc_security_group.web_sg.id # Разрешить доступ к БД только от web_sg
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "any"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить исходящий доступ ко всему интернету
  }
}

resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.main.id
  ingress {
    description    = "Allow Zabbix Agent traffic"
    protocol       = "tcp"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить доступ от всех IP
  }

  ingress {
    description    = "Allow Zabbix Server traffic"
    protocol       = "tcp"
    port           = 10051
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить доступ от всех IP
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "any"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешить исходящий доступ ко всему интернету
  }
}
