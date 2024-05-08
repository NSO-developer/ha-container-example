docker exec -i nso2_secondary ncs_cli -C -u admin << EOF
high-availability enable
high-availability be-secondary-to node nso1
show high-availability
exit
EOF   
