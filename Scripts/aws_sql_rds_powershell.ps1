# Install-Module -Name AWSPowerShell
Set-AWSCredentials -StoredCredentials myAWScredentials


# Get-Help is your friend, a good editor helps too :)
Get-Help New-RDSDBInstance -ShowWindow


# Describe Instance
Get-RDSDBInstance -region "us-east-2"


# Describe Instance, easier to read and relevant columns
Get-RDSDBInstance -Region "us-east-2" `
    | Select-Object DBInstanceIdentifier, DBInstanceStatus, Engine, EngineVersion, DBInstanceClass, DBInstanceArn `
    | Out-Gridview


# Create database instance - Much quicker than GUI
New-RDSDBInstance `
    -dbinstanceidentifier "nebula-frankfurt-dev" `
    -region "eu-central-1" `
    -VpcSecurityGroupId "sg-00***************" `
    -allocatedstorage 20 `
    -dbinstanceclass "db.t2.micro" `
    -engine "sqlserver-ex" `
    -masterusername "*******" `
    -masteruserpassword "*************" `
    -availabilityzone "eu-central-1a" `
    -port 50000 `
    -engineversion "14.00.3281.6.v1"


# Stop a RDS instance - Useful for starting non prod instances out of hours
Stop-RDSDBInstance -dbinstanceidentifier "nebula-frankfurt-dev" -Region "eu-central-1"


# Start a stopped instance - Useful for starting non prod instances out of hours
Start-RDSDBInstance -dbinstanceidentifier "nebula-frankfurt-dev" -Region "eu-central-1"


# Create Snapshot
New-RDSDBSnapshot `
    -DBInstanceIdentifier "nebula-frankfurt-dev" `
    -DBSnapshotIdentifier "nebula-frankfurt-dev-keep" `
    -Region "eu-central-1"


# Describe Snapshot(s)
Get-RDSDBSnapshot -Region "eu-central-1" 
Get-RDSDBSnapshot `
    -Region "eu-central-1" `
    | Select-Object DBInstanceIdentifier,DBSnapshotIdentifier,SnapshotType,SnapshotCreateTime,Status `
    | Out-Gridview


# Remove Snapshot(s)
Remove-RDSDBSnapshot -DBSnapshotIdentifier "nebula-frankfurt-dev-keep" -Region "eu-central-1" -Force


# Restore database - Can use the same params as New-RDSDBInstance.
# If you don't it inherits the params from the original instance
Restore-RDSDBInstanceFromDBSnapshot `
    -DBInstanceIdentifier "nebula-frankfurt-dev-restored" `
    -DBSnapshotIdentifier "nebula-frankfurt-dev-keep" `
    -Region "eu-central-1"


#Delete instance
Remove-RDSDBInstance `
    -DBInstanceIdentifier "nebula-frankfurt-dev" `
    -Region "eu-central-1" `
    -SkipFinalSnapshot 1 `
    -Force