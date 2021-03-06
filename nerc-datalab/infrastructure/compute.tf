resource "openstack_compute_instance_v2" "bastion" {
  name       = "${var.cluster_name}-bastion-${count.index+1}"
  count      = var.number_of_bastions
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_bastion)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.bastion.name,
    openstack_compute_secgroup_v2.k8s.name,
    "default",
  ]

  metadata = {
    ssh_user    = local.ssh_user
    groups      = "bastion,${var.site}"
    depends_on  = var.tenant_network
  }
}

resource "openstack_compute_instance_v2" "load_balancer" {
  name       = "${var.cluster_name}-load-balancer"
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_load_balancer)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.load_balancer.name,
    "default",
  ]

  metadata = {
    ssh_user    = local.ssh_user
    groups      = "load-balancers,prod-load-balancers,proxied,${var.site}"
    depends_on  = var.tenant_network
  }
}

resource "openstack_compute_instance_v2" "test_load_balancer" {
  name       = "${var.cluster_name}-test-load-balancer"
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_load_balancer)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.load_balancer.name,
    "default",
  ]

  metadata = {
    ssh_user    = local.ssh_user
    groups      = "load-balancers,test-load-balancers,proxied,${var.site}"
    depends_on  = var.tenant_network
  }
}

resource "openstack_compute_instance_v2" "k8s_master" {
  name       = "${var.cluster_name}-k8s-master"
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_k8s_master)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.k8s_master.name,
    openstack_compute_secgroup_v2.k8s.name,
    "default",
  ]

  metadata = {
    ssh_user    = local.ssh_user
    groups      = "k8s-master,k8s-cluster,proxied,${var.site}"
    depends_on  = var.tenant_network
  }
}

resource "openstack_compute_instance_v2" "k8s_node" {
  name        = "${var.cluster_name}-k8s-node-${count.index+1}"
  count       = var.number_of_k8s_nodes
  image_name  = var.server_image
  flavor_name = var.flavor_k8s_node
  key_pair    = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.k8s.name,
    "default",
  ]

  metadata = {
    ssh_user   = local.ssh_user
    groups     = "k8s-node,k8s-cluster,proxied,${var.site}"
    depends_on = var.tenant_network
  }

  lifecycle {
    ignore_changes = [
      "image_name",
    ]
  }
}


resource "openstack_compute_instance_v2" "gluster_node" {
  name       = "${var.cluster_name}-glusterfs-${count.index+1}"
  count      = var.number_of_gluster_nodes
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_gluster_node)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    openstack_compute_secgroup_v2.gluster.name,
    "default",
  ]

  metadata = {
    ssh_user   = local.ssh_user
    groups     = "gluster-node,proxied,${var.site}"
    depends_on = var.tenant_network
  }
}

resource "openstack_compute_instance_v2" "nfs_node" {
  name       = "${var.cluster_name}-nfs-${count.index+1}"
  count      = var.number_of_nfs_nodes
  image_name = var.server_image
  flavor_id  = lookup(local.flavours, var.flavor_nfs_node)
  key_pair   = var.openstack_keypair

  network {
    name = var.tenant_network
  }

  security_groups = [
    "default",
  ]

  metadata = {
    ssh_user   = local.ssh_user
    groups     = "nfs-node,proxied,${var.site}"
    depends_on = var.tenant_network
  }
}
