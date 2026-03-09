package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformInfrastructure(t *testing.T) {
	// Configure Terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Point to the root directory where the .tf files and dev.tfvars are located
		TerraformDir: "../terraform",

		// Pass the variables file to the environment
		VarFiles: []string{"dev.tfvars"},

		// Pass Vault credentials from OS environment so Terraform can authenticate
		EnvVars: map[string]string{
			"VAULT_ADDR":  os.Getenv("VAULT_ADDR"),
			"VAULT_TOKEN": os.Getenv("VAULT_TOKEN"),
		},
	})

	// The `defer` ensures that Terraform Destroy is executed at the end of the test,
	// regardless of whether the test passes or fails. This avoids wasting resources or polluting the state.
	defer terraform.Destroy(t, terraformOptions)

	// Execute the "terraform init" and "terraform apply" commands.
	// If an error occurs during apply, the test will automatically fail.
	terraform.InitAndApply(t, terraformOptions)

	// Retrieve the Terraform output that we extracted in `outputs.tf`
	instancePrivateIP := terraform.Output(t, terraformOptions, "instance_private_ip")
	ebsVolumeID := terraform.Output(t, terraformOptions, "ebs_volume_id")

	// Assert if the returned Private IP is not empty.
	assert.NotEmpty(t, instancePrivateIP, "The instance private IP should not be empty!")

	// Assert if the EBS Volume ID was created and returned
	assert.NotEmpty(t, ebsVolumeID, "EBS volume creation failed, the returned ID is empty!")
}
