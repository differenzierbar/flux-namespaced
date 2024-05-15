
#!/bin/sh

# create flux resource definitions to install or update flux
# based on the 'flux' executable available from https://github.com/fluxcd/flux2/releases

here=`dirname $(realpath $0)`

[[ ! -d "$here/kubeadmin" ]] && mkdir "$here/kubeadmin"

flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "CustomResourceDefinition")' > $here/kubeadmin/flux-crds.yml
# flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "ClusterRole")' > $here/flux-clusterroles.yml
# flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "ClusterRole") | select(.metadata.name == "flux-edit-flux-system")' > $here/cluster-role-flux-edit-flux-system.yml
# flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "ClusterRole") | select(.metadata.name == "flux-edit-flux-system" or .metadata.name == "flux-view-flux-system")' > $here/kubeadmin/flux-clusterroles.yml

[[ ! -d "$here/developer" ]] && mkdir "$here/developer"

flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "ClusterRole")' > $here/kubeadmin/flux-clusterroles.yml
# flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "ClusterRoleBinding") | .kind="RoleBinding"' > $here/flux-rolebindings.yml
flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "NetworkPolicy") | del(.metadata.namespace)' > $here/developer/flux-network-policies.yml
flux install --watch-all-namespaces=false --export | yq e '. | select(.kind == "Deployment" or .kind == "Service" or .kind == "ServiceAccount") | del(.metadata.namespace)' > $here/developer/flux-controllers.yml
