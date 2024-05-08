docker exec -i nso1_primary ncs_cli -C -u admin << EOF
high-availability enable
high-availability be-primary
show high-availability
exit
EOF
