# django-github-cicd
The project contains standard Django applications customised to use with GitHub Actions. GitHub Actions used to deploy application to AWS Instance, using Terraform.



|  Tool  |   Version    |
|--------|--------------|
| Python | Python 3.8.9 |

Workflows uses below secrets while provisioning infrastructure

| Secret Name | Its Use |
|-------------|---------|
| APP_SECRET  |         |
| AWS_ACCESS_KEY_ID|         |
| AWS_REGION|         |
| AWS_SECRET_ACCESS_KEY|         |
| DB_APP_USER|         |
| DB_AUTH|         |
| DB_HOST|         |
| DB_NAME|         |
| DB_PORT|         |
| DB_PWD|         |
| NEW_IMAGE|         |
| TF_API_TOKEN|         |
