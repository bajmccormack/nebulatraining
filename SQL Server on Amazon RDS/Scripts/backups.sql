-- Restore database/ Backup Database syntax doesn't work - We need to use RDS stored procedures
-- Option Group - Allow SQLSERVER_BACKUP_RESTORE option
-- You must choose an IAM role with permissions to your S3 bucket
-- S3 bucket must be in same region


-- Compress backup files (Won't work on Express edition)
exec rdsadmin..rds_set_configuration 'S3 backup compression', 'true'; 


-- Initiate backup
exec msdb.dbo.rds_backup_database 
	@source_db_name='Demo2', 
	@s3_arn_to_backup_to='arn:aws:s3:::xxxxx/Demo2/Demo2-Full.bak', 
	@overwrite_S3_backup_file=1;

-- Check status
exec msdb.dbo.rds_task_status


-- Striped backup
exec msdb.dbo.rds_backup_database 
@source_db_name='Nebula',
@s3_arn_to_backup_to='arn:aws:s3:::xxxxx/Nebula/nebula-full-*.bak',
@number_of_files=3;

-- Check status
exec msdb.dbo.rds_task_status 

-- Restore database from backup in S3
exec msdb.dbo.rds_restore_database
@restore_db_name='AdventureWorksLT2017',
@s3_arn_to_restore_from='arn:aws:s3:::xxxxx/AdventureWorksLT2017/AdventureWorksLT2017.bak'

-- Check status
exec msdb.dbo.rds_task_status 

-- More options to investigate
-- Differential Backups
-- Log backups
-- Encrypt your backups with KMS keys
-- S3 lifecycle rules

-- Further reading
-- https://aws.amazon.com/premiumsupport/knowledge-center/native-backup-rds-sql-server/
-- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/SQLServer.Procedural.Importing.html#SQLServer.Procedural.Importing.Native.Enabling
-- https://aws.amazon.com/rds/faqs/