terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

variable "reserved_ip_address" {
  default = "178.154.200.203"
}

resource "yandex_compute_instance" "vm1" {
  name = "instance-1"
  zone = "ru-central1-a"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8gnpl76tcrdv0qsfko"
      size = 10
    }
  }

  network_interface {
    subnet_id = "e9btpamf4bei4ucnnvjj"
    ipv4 = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFkG/PHgB9IbMqrSTpDgfDx5DEvkHailwKKEHKau+odC {s.kachan@dunice.net}
EOF

  }
}

resource "yandex_compute_instance" "vm2" {
  name = "instance-2"
  zone = "ru-central1-a"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8gnpl76tcrdv0qsfko"
      size = 10
    }
  }

  network_interface {
    subnet_id = "e9btpamf4bei4ucnnvjj"
    ipv4 = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFkG/PHgB9IbMqrSTpDgfDx5DEvkHailwKKEHKau+odC {s.kachan@dunice.net}
EOF
  }
}

resource "yandex_compute_instance" "vm3" {
  name = "instance-3"
  zone = "ru-central1-a"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8gnpl76tcrdv0qsfko"
    }
  }

  network_interface {
    subnet_id = "e9btpamf4bei4ucnnvjj"
    nat       = true
    ipv4      = true
    nat_ip_address = var.reserved_ip_address
  }

metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFkG/PHgB9IbMqrSTpDgfDx5DEvkHailwKKEHKau+odC {s.kachan@dunice.net}
EOF
    serial-port-enable = "1"
}
}

output "vm1_private_ip" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}

output "vm2_private_ip" {
  value = yandex_compute_instance.vm2.network_interface.0.ip_address
}

output "vm3_public_ip" {
  value = yandex_compute_instance.vm3.network_interface.0.nat_ip_address
}
