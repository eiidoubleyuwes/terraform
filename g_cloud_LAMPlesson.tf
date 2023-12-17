resource "google_compute_instance" "lampstack-1-vm-1" {
  boot_disk {
    auto_delete = true
    device_name = "bitnami-package-for-vm-tmpl-boot-disk"

    initialize_params {
      image = "projects/bitnami-launchpad/global/images/bitnami-lampstack-8-2-13-0-r05-linux-debian-11-x86-64-nami"
      size  = 10
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-dm     = "lampstack-1"
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"

  metadata = {
    bitnami-base-password    = "Y#######"
    google-logging-enable    = "0"
    google-monitoring-enable = "0"
    startup-script           = "#!/bin/bash\n\nset -e\n\nDEFAULT_UPTIME_DEADLINE=\"300\"  # 5 minutes\n\nmetadata_value() {\n  curl --retry 5 -sfH \"Metadata-Flavor: Google\" \\\n       \"http://metadata/computeMetadata/v1/$1\"\n}\n\naccess_token() {\n  metadata_value \"instance/service-accounts/default/token\" \\\n  | python3 -c \"import sys, json; print(json.load(sys.stdin)['access_token'])\"\n}\n\nuptime_seconds() {\n  seconds=\"$(cat /proc/uptime | cut -d' ' -f1)\"\n  echo $${seconds%%.*}  # delete floating point.\n}\n\nconfig_url() { metadata_value \"instance/attributes/status-config-url\"; }\ninstance_id() { metadata_value \"instance/id\"; }\nvariable_path() { metadata_value \"instance/attributes/status-variable-path\"; }\nproject_name() { metadata_value \"project/project-id\"; }\nuptime_deadline() {\n  metadata_value \"instance/attributes/status-uptime-deadline\" \\\n      || echo $DEFAULT_UPTIME_DEADLINE\n}\n\nconfig_name() {\n  python3 - $(config_url) <<EOF\nimport sys, urllib.parse\nparsed = urllib.parse.urlparse(sys.argv[1])\nprint('/'.join(parsed.path.rstrip('/').split('/')[-4:]))\nEOF\n}\n\nvariable_body() {\n  encoded_value=$(echo \"$2\" | base64)\n  printf '{\"name\":\"%s\", \"value\":\"%s\"}\\n' \"$1\" \"$encoded_value\"\n}\n\npost_result() {\n  var_subpath=$1\n  var_value=$2\n  var_path=\"$(config_name)/variables/$var_subpath/$(instance_id)\"\n\n  curl --retry 5 -sH \"Authorization: Bearer $(access_token)\" \\\n      -H \"Content-Type: application/json\" \\\n      -X POST -d \"$(variable_body \"$var_path\" \"$var_value\")\" \\\n      \"$(config_url)/variables\"\n}\n\npost_success() {\n  post_result \"$(variable_path)/success\" \"$${1:-Success}\"\n}\n\npost_failure() {\n  post_result \"$(variable_path)/failure\" \"$${1:-Failure}\"\n}\n\n# The contents of initScript are contained within this function.\ncustom_init() (\n  return 0\n)\n\n# The contents of checkScript are contained within this function.\ncheck_success() (\n  grep -sq true /opt/bitnami/.firstboot.status /var/lib/bitnami/metadata/first_boot_status\n  if [ $? -ne 0 ]; then\n    echo 'Initialization failed'\n    exit 1\n  fi\n)\n\ncheck_success_with_retries() {\n  deadline=\"$(uptime_deadline)\"\n  while [ \"$(uptime_seconds)\" -lt \"$deadline\" ]; do\n    message=$(check_success)\n    case $? in\n    0)\n      # Success.\n      return 0\n      ;;\n    1)\n      # Not ready; continue loop\n      ;;\n    *)\n      # Failure; abort.\n      echo $message\n      return 1\n      ;;\n    esac\n\n    sleep 5\n  done\n\n  # The check was not successful within the required deadline.\n  echo \"status check timeout\"\n  return 1\n}\n\ndo_init() {\n  # Run the init script first. If no init script was specified, this\n  # is a no-op.\n  echo \"software-status: initializing...\"\n\n  set +e\n  message=\"$(custom_init)\"\n  result=$?\n  set -e\n\n  if [ $result -ne 0 ]; then\n    echo \"software-status: init failure\"\n    post_failure \"$message\"\n    return 1\n  fi\n}\n\ndo_check() {\n  # Poll for success.\n  echo \"software-status: waiting for software to become ready...\"\n  set +e\n  message=\"$(check_success_with_retries)\"\n  result=$?\n  set -e\n\n  if [ $result -eq 0 ]; then\n    echo \"software-status: success\"\n    post_success\n  else\n    echo \"software-status: failed with message: $message\"\n    post_failure \"$message\"\n  fi\n}\n\n# Run the initialization script synchronously.\ndo_init || exit $?\n\n# The actual software initialization might come after google's init.d\n# script that executes our startup script. Thus, launch this script\n# into the background so that it does not block init and eventually\n# timeout while waiting for software to start.\ndo_check & disown"
    status-config-url        = "####"
    status-uptime-deadline   = "1800"
    status-variable-path     = "status"
  }

  name = "lampstack-1-vm-1"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = "p##"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "XXXXX"
    scopes = ["https://###y", "https:###", "https:/#"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["lampstack-1-deployment"]
  zone = "us-east1-b"
}
