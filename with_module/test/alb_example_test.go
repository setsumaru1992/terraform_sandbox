package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"time"
)

func TestAlbExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../examples/alb",
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	expectedStatusCode := 404
	expectedBody := "404: page not found"
	maxRetries := 5
	timeBetweenRetries := 30 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		nil,
		expectedStatusCode,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
		)
}