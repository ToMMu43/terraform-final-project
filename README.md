# slurm-tf-final-project
Slurm DevOps Upgrade 5 поток: Terraform practice (Yandex Cloud provider)

1. Подготовка к работе
Для работы необходимы:
- Yandex Cloud CLI
- Terraform
- Packer

2. Инициализируем Yandex Cloud CLI и экспортируем переменные
```
yc init
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_TOKEN=$(yc config get token)
export TF_VAR_folder_id=$(yc config get folder-id)
```
или заполняем и используем файл secrets.tfback

3. Работа с Packer
```
cd packer
packer init config.pkr.hcl
packer validate -var 'image_tag=1' nginx.pkr.hcl
packer build -var 'image_tag=1' nginx.pkr.hcl
```
При необходимости можно изменить имя тега: packer build -var 'image_tag=1' nginx.pkr.hcl.

4. Работа с Terraform
Перейдите в директорию Terraform:
```
cd terraform
terraform init
terraform apply
```
При необходимости можно изменить имя тега: в файле terraform.tfvars исправьте image_tag = "1" на необходимый тег.

5. Удаление ресурсов
```
terraform destroy
```
