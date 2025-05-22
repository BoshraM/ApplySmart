resource "aws_instance" "cyf-server-applysmart" {
    ami                                  = "ami-04e7764922e1e3a57"
    availability_zone                    = "eu-west-1b"
    disable_api_stop                     = false
    disable_api_termination              = false
    ebs_optimized                        = false
    get_password_data                    = false
    hibernation                          = false
    host_id                              = null
    iam_instance_profile                 = null
    instance_initiated_shutdown_behavior = "stop"
    instance_lifecycle                   = null
    instance_type                        = "t2.micro"
    ipv6_address_count                   = 0
    key_name                             = "learning"
    monitoring                           = false
    outpost_arn                          = null
    password_data                        = null
    placement_group                      = null
    placement_partition_number           = 0
    secondary_private_ips                = []
    security_groups                      = [
        "launch-wizard-1",
    ]
    source_dest_check                    = true
    spot_instance_request_id             = null
    subnet_id                            = "subnet-054a65b33451ec2ee"
    tags                                 = {
        "Name" = "cyf-server-applysmart"
    }
    tags_all                             = {
        "Name" = "cyf-server-applysmart"
    }
    tenancy                              = "default"
    vpc_security_group_ids               = [
        "sg-0f6eb4220a780feb5",
    ]

    capacity_reservation_specification {
        capacity_reservation_preference = "open"
    }

    cpu_options {
        amd_sev_snp      = null
        core_count       = 1
        threads_per_core = 1
    }

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    maintenance_options {
        auto_recovery = "default"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
        instance_metadata_tags      = "disabled"
    }

    private_dns_name_options {
        enable_resource_name_dns_a_record    = true
        enable_resource_name_dns_aaaa_record = false
        hostname_type                        = "ip-name"
    }
}