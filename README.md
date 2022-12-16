# terraform-crds-manager

Manage Helm Custom Resource Definitions (CRDs) with Terraform. 

## Why?

Helm is a remarkable piece of technology to manage your Kubernetes deployment, and used along Terraform is perfect for deploying following the GitOps strategy.

However, Helm has a limitation: [it doesn't manage the lifecycle of CRDs][0], meaning it will only install the CRDs during the first installation of a chart. Subsequent chart upgrades will not add or remove CRDs, even if the CRDs have changed.

With this module, Terraform can apply the CRDs on its own, managing their lifecycle alongside the Helm chart they belong to.

## Usage

Given a list of links to CRDs definitions, input them to the module. It is strongly suggested to link to versioned CRDs, to ensure the same version of CRDs and charts.

This module uses the [kubectl Terraform provider][2], so you need to configure it, as [illustrated in their guide][3].

### Example

The [kube-promeheus-stack][4] requires eight different CRDs: managing them manually is quite time-consuming, so it is the perfect candidate for this module.

Let's have a `chart_version` variable, where it is specified the version of the chart deployed with the [Helm provider][5].

Alongside, let's specify the CRDs we want to manage:

```terraform
module "kube_prometheus_stack_crds" {
    source = "rpadovani/helm-crds/kubectl"
    version = "0.2.0"

    crds_urls = [
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-alertmanagerconfigs.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-alertmanagers.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-podmonitors.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-probes.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-prometheuses.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-prometheusrules.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-servicemonitors.yaml",
        "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-${var.chart_version}/charts/kube-prometheus-stack/crds/crd-thanosrulers.yaml",
    ]
}
```

There are two important things to notice here:
- we use the raw version of the file: we want to have only the pure YAML manifest to give to the module;
- we specify the version in the URL, so we can be sure the CRDs are kept in sync with the Helm chart we are deploying;

The Helm resource then can depend on the newly created resource, and we can also disable there the management of the CRDs:

```terraform
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "${var.chart_version}" # <- With this, we keep in sync Helm Chart and CRDs
  
  skip_crds = true # Optional, given that they should be skipped if they are already present
  
  depends_on = [module.kube_prometheus_stack_crds]
}
```

[0]: https://helm.sh/docs/chart_best_practices/custom_resource_definitions/
[2]: https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0
[3]: https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs#configuration
[4]: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md
[5]: https://registry.terraform.io/providers/hashicorp/helm/latest/docs
