#Create a LAMP stack in GCP
resource "google_compute_instance" "web" {
  name         = "terraform-lamp"
  machine_type = "E2-micro"
  zone         = "us-central1-a"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install apache2 php7.0 -y
  sudo service apache2 restart
  EOF
}