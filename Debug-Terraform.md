
# Terraform Debugging Guide

## Overview

This document explains how to enable and interpret detailed Terraform debug logs using the `TF_LOG` environment variable. Debug logs are useful for troubleshooting issues during Terraform commands such as `init`, `plan`, `apply`, etc.

---

## Enabling Debug Logs

Terraform provides a built-in logging mechanism controlled by the environment variable `TF_LOG`. Setting this variable enables detailed internal logs that help diagnose what Terraform is doing behind the scenes.

### Log Levels

* `TRACE` - Most detailed logging, including HTTP requests, internal function calls, and data parsing.
* `DEBUG` - Debug-level messages, less verbose than `TRACE`.
* `INFO` - Informational messages.
* `WARN` - Warnings.
* `ERROR` - Only errors.

### How to Set

To enable the most verbose logs, use:

```bash
export TF_LOG=TRACE
```

Or prefix your Terraform command inline:

```bash
TF_LOG=TRACE terraform init
```

---

## Example Debug Output (from `terraform init`)

```bash
2025-07-24T09:52:36.562+0530 [INFO]  Terraform version: 1.12.2
2025-07-24T09:52:36.564+0530 [DEBUG] using github.com/hashicorp/go-tfe v1.74.1
...
2025-07-24T09:52:37.352+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
Terraform has been successfully initialized!
```

This output includes timestamps, log levels, and detailed information about:

* Terraform version and plugins loaded
* Backend initialization steps
* Provider plugin discovery and caching
* HTTP requests made to Terraform Registry
* State file reading/writing
* Final success message

---

## Where Logs Are Output

* Logs are printed directly to **stderr** by default.
* To capture logs into a file, redirect stderr:

```bash
TF_LOG=TRACE terraform init 2> terraform-debug.log
```

---

## Tips for Using Terraform Logs

* Use `TRACE` only when debugging, as it produces very verbose output.
* Review the logs to identify:

  * Plugin download and loading issues
  * Backend initialization problems
  * Provider version conflicts
  * State file read/write errors
* Combine with `terraform plan` or `terraform apply` for further insights.
* When sharing logs for support, review them first to remove sensitive information.

---

## Disabling Logs

Unset `TF_LOG` or set it to empty string to disable logging:

```bash
unset TF_LOG
```

---

## Additional Debugging Tools

* `terraform validate` — Checks syntax of configuration files.
* `terraform providers` — Lists provider plugins used.
* `terraform version` — Shows Terraform and provider versions.
* Use `terraform fmt` to format your configuration files.

---

# Summary

Enabling `TF_LOG=TRACE` provides detailed insight into Terraform's internal operations and can help diagnose complex issues during Terraform workflows.

# Example

```
eena@deena-jeevi:~/Pictures/whizlabs/terraform-vagrant-lab$ TF_LOG=TRACE terraform init
2025-07-24T09:52:36.562+0530 [INFO]  Terraform version: 1.12.2
2025-07-24T09:52:36.562+0530 [DEBUG] using github.com/hashicorp/go-tfe v1.74.1
2025-07-24T09:52:36.562+0530 [DEBUG] using github.com/hashicorp/hcl/v2 v2.23.1-0.20250203194505-ba0759438da2
2025-07-24T09:52:36.562+0530 [DEBUG] using github.com/hashicorp/terraform-svchost v0.1.1
2025-07-24T09:52:36.562+0530 [DEBUG] using github.com/zclconf/go-cty v1.16.2
2025-07-24T09:52:36.562+0530 [INFO]  Go runtime version: go1.24.2
2025-07-24T09:52:36.562+0530 [INFO]  CLI args: []string{"terraform", "init"}
2025-07-24T09:52:36.562+0530 [TRACE] Stdout is a terminal of width 136
2025-07-24T09:52:36.562+0530 [TRACE] Stderr is a terminal of width 136
2025-07-24T09:52:36.562+0530 [TRACE] Stdin is a terminal
2025-07-24T09:52:36.562+0530 [DEBUG] Attempting to open CLI config file: /home/deena/.terraformrc
2025-07-24T09:52:36.563+0530 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2025-07-24T09:52:36.563+0530 [DEBUG] checking for credentials in "/home/deena/.terraform.d/plugins"
2025-07-24T09:52:36.563+0530 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2025-07-24T09:52:36.563+0530 [DEBUG] will search for provider plugins in /home/deena/.terraform.d/plugins
2025-07-24T09:52:36.564+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/bmatcuk/vagrant v4.1.0 for linux_amd64 at /home/deena/.terraform.d/plugins/registry.terraform.io/bmatcuk/vagrant/4.1.0/linux_amd64
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /home/deena/snap/code/200/.local/share/terraform/plugins
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /home/deena/snap/code/200/.local/share/flatpak/exports/share/terraform/plugins
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /home/deena/snap/code/200/.local/share/terraform/plugins
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /home/deena/snap/code/200/terraform/plugins
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /snap/code/200/usr/share/terraform/plugins
2025-07-24T09:52:36.564+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/ubuntu/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/gnome/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /home/deena/.local/share/flatpak/exports/share/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /var/lib/flatpak/exports/share/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins
2025-07-24T09:52:36.566+0530 [DEBUG] ignoring non-existing provider search directory /var/lib/snapd/desktop/terraform/plugins
2025-07-24T09:52:36.568+0530 [INFO]  CLI command args: []string{"init"}
Initializing the backend...
2025-07-24T09:52:36.576+0530 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
2025-07-24T09:52:36.576+0530 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
2025-07-24T09:52:36.576+0530 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
2025-07-24T09:52:36.576+0530 [TRACE] Meta.Backend: instantiated backend of type <nil>
2025-07-24T09:52:36.578+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2025-07-24T09:52:36.580+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/bmatcuk/vagrant v4.1.0 for linux_amd64 at .terraform/providers/registry.terraform.io/bmatcuk/vagrant/4.1.0/linux_amd64
2025-07-24T09:52:36.580+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/null v3.2.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/null/3.2.4/linux_amd64
2025-07-24T09:52:36.581+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/bmatcuk/vagrant/4.1.0/linux_amd64 as a candidate package for registry.terraform.io/bmatcuk/vagrant 4.1.0
2025-07-24T09:52:36.581+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/null/3.2.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/null 3.2.4
2025-07-24T09:52:36.795+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
2025-07-24T09:52:36.987+0530 [DEBUG] checking for provisioner in "."
2025-07-24T09:52:37.007+0530 [DEBUG] checking for provisioner in "/usr/bin"
2025-07-24T09:52:37.008+0530 [DEBUG] checking for provisioner in "/home/deena/.terraform.d/plugins"
2025-07-24T09:52:37.008+0530 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
2025-07-24T09:52:37.008+0530 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
2025-07-24T09:52:37.008+0530 [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
2025-07-24T09:52:37.008+0530 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
2025-07-24T09:52:37.008+0530 [TRACE] statemgr.Filesystem: read nil snapshot
Initializing provider plugins...
- Reusing previous version of bmatcuk/vagrant from the dependency lock file
- Reusing previous version of hashicorp/null from the dependency lock file
2025-07-24T09:52:37.009+0530 [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
2025-07-24T09:52:37.009+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
2025-07-24T09:52:37.163+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/null/versions
2025-07-24T09:52:37.164+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/null/versions
2025-07-24T09:52:37.186+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2025-07-24T09:52:37.186+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/bmatcuk/vagrant v4.1.0 for linux_amd64 at .terraform/providers/registry.terraform.io/bmatcuk/vagrant/4.1.0/linux_amd64
2025-07-24T09:52:37.186+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/null v3.2.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/null/3.2.4/linux_amd64
2025-07-24T09:52:37.187+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/bmatcuk/vagrant/4.1.0/linux_amd64 as a candidate package for registry.terraform.io/bmatcuk/vagrant 4.1.0
2025-07-24T09:52:37.187+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/null/3.2.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/null 3.2.4
- Using previously-installed bmatcuk/vagrant v4.1.0
2025-07-24T09:52:37.352+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
- Using previously-installed hashicorp/null v3.2.4

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
deena@deena-jeevi:~/Pictures/whizlabs/terraform-vagrant-lab$ 

`
