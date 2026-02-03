[talos_nodes]
%{ for name, ip in vms ~}
${name} ansible_host=${ip}
%{ endfor ~}