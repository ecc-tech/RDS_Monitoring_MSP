region           = "ap-south-1"
cpu_threshold    = 40
memory_threshold = 50000000  # ~200 MB


#memory_threshold = 900000000  # 900 MB

disk_threshold = 10000000000  # 10 GB
//disk_threshold = 15000000000  # 15 GB

rds_instance_ids =[
    "database-1",
    "database-2",
    "database-new",
    "database-latest"
]


//rds_instances = ["database-1"]  # Replace with your actual RDS identifiers
