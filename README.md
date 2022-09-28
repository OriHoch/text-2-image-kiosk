# Text 2 Image Kiosk

## Stable Diffusion API Server 

Stable Diffusion API Server provides a REST API for generating images based on text input and
serving the generated files.

Prerequsites:

* Terraform
* Python3
* Download the files listed in [ansible/roles/api/vars/main.yaml](ansible/roles/api/vars/main.yaml) to `.ansible` directory
* Set env vars:
  * AWS_ACCESS_KEY_ID / AWS_SECRET_KEY / AWS_SESSION_TOKEN
  * TF_VAR_cloudflare_api_token
  * TF_VAR_main_root_domain

Create Stable Diffusion server:

```
terraform init
terraform apply
python3 -m venv venv
. venv/bin/activate
pip install -r requirements-infra.txt
ansible-playbook playbook.yaml
```

Start api server locally:

```
python3 -m venv venv
. venv/bin/activate
pip install -r requirements-api.txt

```