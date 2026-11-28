/*
#---------------------------------------------------------------------------------------------------
Created the Bronze.load_Bronze stored procedure to automate raw data ingestion into the Bronze layer.

- Added bulk load process for CRM source files:
  - crm_cust_info
  - crm_prd_info
  - crm_sales_details
######################################################################################################
- Added bulk load process for ERP source files:
  - erp_cust_az12
  - erp_loc_a101
  - erp_px_cat_g1v2
#########################################################################################################
- Implemented table truncation before each load to support full refresh processing.
- Used BULK INSERT for high-performance CSV file ingestion.
- Added execution time logging for individual table loads and overall batch duration.
- Included TRY...CATCH error handling to capture and report load failures.
- Added progress messages to improve ETL monitoring and troubleshooting.
#=========================================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS
BEGIN
	DECLARE @START_DATE DATETIME, @END_DATE DATETIME, @BATCH_START_TIME DATETIME, @BATCH_END_TIME DATETIME;
	BEGIN TRY
		SET @BATCH_START_TIME = GETDATE();
		PRINT '====================================================================================';
		PRINT 'Extract data from resource';
		PRINT '====================================================================================';

		PRINT '------------------------------------------------------------------------------------';
		PRINT 'LOAD DATA FROM CRM';
		PRINT '------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();

		TRUNCATE TABLE Bronze.crm_cust_info;
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();
		TRUNCATE TABLE Bronze.crm_prd_info;
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();
		TRUNCATE TABLE Bronze.crm_sales_details;
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		PRINT '------------------------------------------------------------------------------------';
		PRINT 'LOAD DATA FROM ERM';
		PRINT '------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();
		TRUNCATE TABLE Bronze.erp_cust_az12;
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();
		TRUNCATE TABLE Bronze.erp_loc_a101;
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		SET @START_DATE = GETDATE();
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_DATE = GETDATE();
		PRINT 'LOAD DURATION :' + CAST(DATEDIFF(second, @START_DATE, @END_DATE) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

		SET @BATCH_END_TIME = GETDATE();
		PRINT ' ========================================================================================='
		PRINT 'FULL BATCH LOAD DURATION :' + CAST(DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME) AS NVARCHAR) + 'SECOND';
		PRINT ' --------------------------------------------------------------------------------------';

	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END;
