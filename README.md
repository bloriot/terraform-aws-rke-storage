# Kubernetes Cluster on AWS using Terraform and Terraform RKE Provider

This repository is an example for building a Kubernetes cluster using Terraform and Terraform RKE provider on AWS.

Using SUSE Linux Enterprise Server 15 SP2 as operating system for EC2 instances and additional EBS storage to demonstrate Longhorn or Rook functionalities. 

> based on: [https://github.com/rancher/terraform-provider-rke/tree/master/examples/aws_ec2](https://github.com/rancher/terraform-provider-rke/tree/master/examples/aws_ec2)]
> ref: [https://rancher.com/blog/2018/2018-05-14-rke-on-aws/](https://rancher.com/blog/2018/2018-05-14-rke-on-aws/)

## How to use

### Requirements

- [terraform](https://terraform.io) v0.11+
- [terraform-provider-rke](https://github.com/rancher/terraform-provider-rke)
- Valid AWS access_key and secret_key
- [optional] `kubectl` command

### Deploy Kubernetes Cluster on AWS

 * Clone this repo

```bash
$ git clone https://github.com/bloriot/terraform-aws-rke-storage
$ cd terraform-aws-rke-storage
```

 * Set API keys to environment variables

```bash
$ export AWS_ACCESS_KEY_ID="<your-access-key>"
$ export AWS_SECRET_ACCESS_KEY="<your-secret-key>" 
```

 * deploy

 ```bash
$ terraform init && terraform apply
```

When `terraform apply` is completed, kubeconfig file should be created in the current directory 

 * Set `KUBECONFIG` environment variable for kubectl

```bash
$ export KUBECONFIG=${PWD}/kube_config_cluster.yml 
```

Then, kubectl command can be used

 * Components and nodes status

```bash
$ kubectl get cs
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok                   
scheduler            Healthy   ok                   
etcd-0               Healthy   {"health": "true"}  

$ kubectl get nodes
NAME                       STATUS   ROLES               AGE     VERSION
ip-xx-xx-xx.ec2.internal   Ready    controlplane,etcd   3m28s   v1.19.4
ip-xx-xx-xx.ec2.internal   Ready    worker              3m26s   v1.19.4
ip-xx-xx-xx.ec2.internal   Ready    worker              3m25s   v1.19.4
ip-xx-xx-xx.ec2.internal   Ready    worker              3m25s   v1.19.4
```