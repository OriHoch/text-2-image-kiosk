# Text 2 Image Kiosk

## Prerequisites

* Terraform
* Python3
* Download the files listed in [ansible/roles/api/vars/main.yaml](ansible/roles/api/vars/main.yaml) to `.ansible` directory
* Set env vars:
  * AWS_ACCESS_KEY_ID / AWS_SECRET_KEY
  * TF_VAR_cloudflare_api_token
  * TF_VAR_main_root_domain

## Install

```
terraform init
terraform apply
python3 -m venv venv
. venv/bin/activate
pip install -r requirements-infra.txt
ansible-playbook playbook.yaml
```

