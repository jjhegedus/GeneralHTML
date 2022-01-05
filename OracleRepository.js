function OracleRepository(oracleDatabase)
{
	try
	{
		if(constructorName(oracleDatabase.constructor) != 'Database')
		{
			this.error = new Error(10045, "if(constructorName(oracleDatabase.constructor) != 'OracleDatabase')", "OracleRepository must be initialized with an object of type 'Database'");
			throw this.error;
		}
		
		if(constructorName(oracleDatabase.dbType) != 'oracle')
		{
			this.error = new Error(10045, "if(constructorName(oracleDatabase.dbType) != 'oracle')", "OracleRepository must be initialized with an 'oracle' Database");
			throw this.error;
		}
		
		
	}
	catch(e)
	{
		throw logError(e);
	}
}
