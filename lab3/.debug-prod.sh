# set the subscription
export ARM_SUBSCRIPTION_ID="c59cb858-b5c2-4699-8eb2-398034c73ab0"

# set the application / environment 
export TF_VAR_application_name="observability"
export TF_VAR_environment_name="prod"

# set the backend
export BACKEND_RESOURCE_GROUP_NAME="kvg-rg-tf101-prod"
export BACKEND_STORAGE_ACCOUNT_NAME="kvgst0up67i1av5001"
export BACKEND_CONTAINER_NAME="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

# run terraform 
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform