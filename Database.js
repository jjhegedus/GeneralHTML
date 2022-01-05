/* Class Database */
/*
	Prerequisites:
		Specific Database Classes
*/
	function Database(dbType)
	{
		this.dbType = dbType;
		this.create = Database_create;
		this.create(dbType);
		this.useLocalCursors = false;
		
		// Properties
		this.login = this.mvarSpecificDb.login;
		this.setDsn = this.mvarSpecificDb.setDsn;
		this.getDsn = this.mvarSpecificDb.getDsn;
		this.setConnectionStr = this.mvarSpecificDb.setConnectionStr;
		this.getConnectionStr = this.mvarSpecificDb.getConnectionStr;
		this.setUserId = this.mvarSpecificDb.setUserId;
		this.getUserId = this.mvarSpecificDb.getUserId;
		this.setPassword = this.mvarSpecificDb.setPassword;
		this.getPassword = this.mvarSpecificDb.getPassword;
		this.setServer = this.mvarSpecificDb.setServer;
		this.getServer = this.mvarSpecificDb.getServer;
		this.viewSystemTables = false;
		this.get_name = this.mvarSpecificDb.get_name;
		this.set_name = this.mvarSpecificDb.set_name;
		this.get_children = this.mvarSpecificDb.get_children;
		this.get_objectType = this.mvarSpecificDb.get_objectType;
		this.get_users = this.mvarSpecificDb.get_users;

		
		// Methods
		this.getConnection = this.mvarSpecificDb.getConnection;
		this.getData = Database_getData;
		this.execute = Database_execute;
		this.getTables = this.mvarSpecificDb.getTables;
		this.getColumns = this.mvarSpecificDb.getColumns;
		this.get_tablesCollection = this.mvarSpecificDb.get_tablesCollection;
		this.get_viewsCollection = this.mvarSpecificDb.get_viewsCollection;
		this.rstToHTMLTable = Database_rstToHTMLTable;
		this.getHTMLTable = Database_getHTMLTable;
		
		this.adoTypeName = Database_adoTypeName;
		this.adoTypeFromName = Database_adoTypeFromName;
		
		// ViewPort
		this.get_defaultViewPort = Database_get_defaultViewPort;
	}
		function Database_create(dbType)
		{
			try
			{
				if(dbType == 'access')
				{
					this.mvarSpecificDb = new AccessDatabase();
				}
				else if(dbType == 'oracle')
				{
					this.mvarSpecificDb = new OracleDatabase();
				}
				else
				{
					throwError('Database_create\r' + dbType + ' is not a valid database type');
				}
			}
			catch(e)
			{
				throwError('Database_create', e);
			}
		}
		function Database_getData(source)
		{
			try
			{
				var rset;
				rset = new ActiveXObject('ADODB.Recordset');

				if(this.useLocalCursors)
				{
					rset.cursorLocation = 3;
				}
				rset.lockType = 3;

				rset.Open(source, this.getConnection(), 2);
				
				return rset;
			}
			catch(e)
			{
				throw logError(e, source);
			}
		}
		function Database_execute(sqlStr)
		{
			try
			{
				this.getConnection().execute(sqlStr);
			}
			catch(e)
			{
				throwError('Database_execute', e, 'sqlString = :\r' + sqlStr);
			}
		}
		function Database_rstToHTMLTable(rst, tableName)
		{
			try
			{
				var numColumns = rst.Fields.Count;
				var columnWidth = 1/numColumns;
				columnWidth = columnWidth * 100;
				columnWidth = '' + columnWidth + '%';

				var tbl = document.createElement('table');
				tbl.width = '100%';
				tbl.height = '100%';
				var tblHead = document.createElement('thead');
				tbl.appendChild(tblHead);

				// Create the header
				if(tableName)
				{
					var titleRow = document.createElement('tr');
					tblHead.appendChild(titleRow);
					
					var titleCell = document.createElement('th');
					titleCell.colspan = numColumns;
					titleCell.innerText = tableName;
					titleRow.appendChild(titleCell);
				}

				var columnHeads = document.createElement('tr');
				tblHead.appendChild(columnHeads);

				// add columns for each field
				for(var i = 0;i < rst.Fields.Count;i++)
				{
					var columnHead = document.createElement('td');
					columnHead.width = columnWidth;
					columnHead.innerText = rst.Fields(i).Name;
				}

				if(!rst.EOF)
				{
					rst.MoveFirst();
				}

				var tableBody = document.createElement('tbody');
				tbl.appendChild(tableBody);
				while(!rst.EOF)
				{
					var rowNode = document.createElement('tr');
					tableBody.appendChild(rowNode);
				
							
					for(var i = 0;i < rst.Fields.Count;i++)
					{
						var fieldNode = document.createElement('td');
						fieldNode.align = 'center';
						rowNode.appendChild(fieldNode);

						if(rst.Fields(i).Value != null)
						{
							fieldNode.innerText += rst.Fields(i).Value;
						}
					}
							
					rst.MoveNext();
				}

				return tbl;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function Database_getHTMLTable(source,  tableName)
		{
			try
			{
				var rset = new ActiveXObject('ADODB.Recordset');
				rset.Open(source, this.getConnection(), 2);
				
				return this.rstToHTMLTable(rset, tableName);
			}
			catch(e)
			{
				throwError('Database_getHTMLTable', e);
			}
		}
		
		function Database_adoTypeName(typeNumber)
		{
			var typeName;
			
			switch(typeNumber)
			{
				case 3:
					typeName = 'adInteger';
					break;
				case 7:
					typeName = 'adDate';
					break;
				case 19:
					typeName = 'adUnsignedInt';
					break;
				case 72:
					typeName = 'adGUID';
					break;
				case 135:
					typeName = 'adDBTimeStamp';
					break;
				case 202:
					typeName = 'adVarWChar';
					break;
				case 203:
					typeName = 'adLongVarWChar';
					break;
			}
			
			return typeName;
		}
		
		function Database_adoTypeFromName(typeName)
		{
			var typeNumber;
			
			switch(typeName)
			{
				case adInteger:
					typeNumber = 3;
					break;
				case adDate:
					typeNumber = 7;
					break;
				case adUnsignedInt:
					typeNumber = 19;
					break;
				case adGUID:
					typeNumber = 202;
					break;72
				case adDBTimeStamp:
					typeNumber = 135;
					break;
				case adVarWChar:
					typeNumber = 202;
					break;
				case adLongVarWChar:
					typeNumber = 203;
					break;
			}
			
			return typeNumber;
		}
		
		
		// ViewPort functions
		function Database_get_defaultViewPort()
		{
			try
			{
				if(!this.mvarDefaultViewPort)
				{
					this.mvarDefaultViewPort = get_treeNodeViewPort(this);
				}
				
				return this.mvarDefaultViewPort;
			}
			catch(e)
			{
				throw logError(e);
			}
		}

