# Pipeline README

This `pipeline.yaml` file defines a multi-stage Azure DevOps pipeline for deploying Terraform infrastructure in different environments (QA and PROD). The pipeline performs the following tasks for each environment: planning, manual approval, and applying the Terraform changes.

## Pipeline Breakdown

### 1. **Pool**

The pipeline uses a custom self-hosted agent pool called `IC-DEV-SelfHosted`.

```yaml
pool: 'IC-DEV-SelfHosted'
```

### 2. **Parameters**

The `env` parameter defines the target environments for the pipeline. By default, the environments are set to `qa` and `prod`.

```yaml
parameters:
  - name: env
    displayName: Environment
    type: object
    default:
      - qa
      - prod
```

### 3. **Resources**

The pipeline fetches reusable templates from the `Infrastructure_Template` repository. The repository is defined under `resources` and points to the `main` branch of the `dev/Infrastructure_Template`.

```yaml
resources:
  repositories:
    - repository: Infrastructure_Template
      type: git
      name: dev/Infrastructure_Template
      endpoint: Infrastructure_Template
      ref: main
```

### 4. **Variables**

A variable group `terraform_adani_eventhub` is used to manage environment-specific variables like resource groups, storage accounts, etc.

```yaml
variables:
  - group: terraform_adani_eventhub
```

### 5. **Stages**

The pipeline consists of three stages for each environment:

#### i. **Terraform Plan Stage**

In this stage, Terraform's plan command is executed to preview infrastructure changes. The pipeline loops over the environments (`qa` and `prod`), dynamically replacing environment-specific values.

```yaml
stages:
- ${{ each envObject in parameters.env }}:
  - stage: ${{ envObject }}_Plan
    displayName: ${{ envObject }}_Terraform_plan
    jobs:
    - job: Terraform_plan
      variables:
       resource_group: $(resource_group_${{ envObject }})
       storage_account: $(storage_account_${{ envObject }})
       container_name: $(container_name_${{ envObject }})
       service_connection: $(service_connection_${{ envObject }})
      steps:     
      - script: |
          echo "Running validation for ${{ envObject }}"
          echo "Resource Group: $(resource_group)"
          echo "Storage Account: $(storage_account)"
          echo "Container Name: $(container_name)"
          echo "Service  Name: $(service_connection)"
        displayName: Print Backend variable values
      - template: template/tf_plan.yml@Infrastructure_Template
        parameters:
          env: ${{ envObject }}
          infraType : eventhub
```

##### Key steps:
- **Print Backend Variables**: Validates and prints the environment-specific backend variables like resource group, storage account, and container name.
- **Run Terraform Plan**: Uses the `tf_plan.yml` template to execute the Terraform plan for the environment.

#### ii. **Manual Approval Stage**

Before applying changes, manual approval is required. This stage ensures that the changes are reviewed before deployment.

```yaml
  - stage: ${{ envObject }}_Manual_Approval
    jobs:
    - job: waitForValidation
      displayName: ${{ envObject }}_Manual_Approval
      pool: server
      timeoutInMinutes: 4320 # job times out in 3 days
      steps:
      - template: template/steps/approval.yml@Infrastructure_Template
```

##### Key step:
- **Manual Approval**: The pipeline waits for manual approval for up to 3 days (4320 minutes) before proceeding to the next stage.

#### iii. **Terraform Apply Stage**

Once the plan is approved, this stage runs Terraform's apply command to make the actual infrastructure changes.

```yaml
  - stage: ${{ envObject }}_Apply
    displayName: ${{ envObject }}_Terraform_Apply
    jobs:
    - job: Terraform_ApplyJob
      variables:
       resource_group: $(resource_group_${{ envObject }})
       storage_account: $(storage_account_${{ envObject }})
       container_name: $(container_name_${{ envObject }})
       service_connection: $(service_connection_${{ envObject }})
      steps:     
      - script: |
          echo "Running validation for ${{ envObject }}"
          echo "Resource Group: $(resource_group)"
          echo "Storage Account: $(storage_account)"
          echo "Container Name: $(container_name)"
          echo "Service  Name: $(service_connection)"
        displayName: Print Backend variable values
      - template: template/tf_apply.yml@Infrastructure_Template
        parameters:
          env: ${{ envObject }}
          infraType : eventhub
```

##### Key steps:
- **Print Backend Variables**: Similar to the plan stage, the variables for the current environment are printed for verification.
- **Run Terraform Apply**: Uses the `tf_apply.yml` template to apply the changes for the environment.

### 6. **Summary**

This pipeline automates the Terraform deployment for multiple environments, providing:
- A separate plan, manual approval, and apply stage for each environment.
- Usage of reusable templates from a separate repository (`Infrastructure_Template`).
- Dynamic environment-specific variables.
