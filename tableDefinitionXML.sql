DECLARE
    IN_APPLICATION_NAME VARCHAR2(100) := '&application_name';
    table_html VARCHAR2(4000);
    table_description VARCHAR2(4000);
    table_description_length NUMBER(10);
    table_notes VARCHAR2(4000);
    table_notes_length NUMBER(10);
    column_description VARCHAR2(4000);
    column_description_length NUMBER(10);
    column_note VARCHAR2(4000);
    column_note_length NUMBER(10);
    
    col_bytes ci_columns.average_length%type;
    row_bytes NUMBER(10);
    table_rows NUMBER(10);
    table_bytes NUMBER(10);
    table_bytes_per_quarter NUMBER(10);
    table_block_size NUMBER(10);
    table_block_size_per_quarter NUMBER(10);
    initial_table_extent NUMBER(10);
    next_table_extent NUMBER(10);
    base_table_block_size NUMBER(10) := 8;
    max_next_table_extent NUMBER(10) := 1280;
    cons_initial_extent NUMBER(10);
    cons_next_extent NUMBER(10);
    ix_initial_extent NUMBER(10);
    ix_next_extent NUMBER(10);
    total_index_storage number(10) := 0;
    total_table_storage number(10) := 0;
    
    index_bytes NUMBER(10);
    wip_data_bytes NUMBER(10);
    wip_index_bytes NUMBER(10);
    change_data_bytes NUMBER(10);
    change_index_bytes NUMBER(10);
    ofl_data_bytes NUMBER(10);
    ofl_index_bytes NUMBER(10);
    
    num_unique NUMBER(10);
    num_primary NUMBER(10);
    pk VARCHAR2(1);
    uk VARCHAR2(1);
    nl VARCHAR2(1);
    --****************************************************************************************************
    PROCEDURE prnt(in_message VARCHAR2)
    IS
                -- Program Data
                L_END_POS NUMBER(10, 0);
                L_MAX_LENGTH NUMBER(10, 0);
                L_MESSAGE_PART VARCHAR2(4000);
                L_POS NUMBER(10, 0);
    BEGIN
    
            l_pos := 0;
            l_max_length := 254;
            l_end_pos := l_pos + l_max_length;
        
            WHILE l_pos < length(IN_MESSAGE)
            LOOP
                    IF l_end_pos > length(IN_MESSAGE) THEN
                            l_max_length := length(IN_MESSAGE) - l_pos;
                    END IF;
        
                    l_message_part := substr(IN_MESSAGE, l_pos + 1, l_max_length);
        
                    dbms_output.put_line(l_message_part);
        
        
                    l_pos := l_end_pos;
                    l_end_pos := l_pos + l_max_length;
            END LOOP;
    END;
    
    FUNCTION calculate_column_size(l_datatype VARCHAR2,
																	 l_data_length NUMBER := 0,
																	 l_average_length NUMBER := 0)
    RETURN NUMBER
    IS
    	ret_col_bytes NUMBER(10);
    BEGIN
	    IF l_datatype = 'DATE' or l_datatype = 'TIMESTAMP' then
	      ret_col_bytes := 7;
	    ELSE
	      IF l_average_length > 0 then
	        ret_col_bytes := l_average_length + 1;
	      ELSE
	        ret_col_bytes := l_data_length + 1;
	      END IF;
	    END IF;
	    
	    return ret_col_bytes;
    END;
    
    FUNCTION calculate_block_size(l_bytes NUMBER)
    RETURN NUMBER
    IS
    	ret_block_size NUMBER(10);
    BEGIN
    	-- 1.5 is an insurance factor
    	ret_block_size := ceil(ceil(l_bytes/1000) * 1.5);
    	
    	return ret_block_size;
    END;
    
    FUNCTION calculate_extent_size(l_rows NUMBER,
    															 l_block_size NUMBER,
																	 l_base_block_size NUMBER)
		RETURN NUMBER
    IS
    	ret_extent_size NUMBER(10) := 0;
    BEGIN
			if mod(l_block_size, l_base_block_size) = 0 then
				ret_extent_size := l_block_size;
			else
				ret_extent_size := l_block_size + l_base_block_size - mod(l_block_size, l_base_block_size);
			end if;
			
			return ret_extent_size;
    END;
    																
BEGIN
    DECLARE
        CURSOR td_cur (cur_application_name VARCHAR2) is
            select  tab1.irid as tableId,
                    tab1.ivid as tableVersionId,
                    tab1.name as tableName,
                    tab1.initial_number_of_rows,
                    tab1.maximum_number_of_rows as rowsPerQuarter
              from  ci_table_definitions tab1,
                    sdd_folder_members mem,
                    sdd_folders fld
             where  mem.member_object=tab1.irid
               and  mem.folder_reference=fld.irid
               and  mem.ownership_flag = 'Y'
               and  fld.name = cur_application_name
--               and  tab1.name not like '%_OF'
--               and  tab1.name not like '%_CH'
--               and  tab1.name not like 'DEV_%'
--               and  tab1.name not like 'REF_%'
             order
                by  tab1.name;

        CURSOR col_cur (cur_table_id VARCHAR2) is
            select  col.irid as columnId,
                    col.name as name,
                    col.datatype,
                    to_char(col.maximum_length) as dataLength,
                    to_char(col.decimal_places) as dataPrecision,
                    col.null_indicator,
                    col.remark,
                    col.average_length
              from  ci_table_definitions tab1,
                    ci_columns col
             where  col.table_reference = tab1.irid
               and  tab1.id = cur_table_id
             order 
                by  sequence_number;
    
        CURSOR cons_cur (cur_table_id VARCHAR2) is
            select  cons.irid as constraintId,
                    cons.constraint_type,
                    cons.name as name,
                    cons.check_constraint_type
              from  ci_table_definitions tab1,
                    ci_constraints cons
             where  cons.table_reference = tab1.irid
               and  tab1.id = cur_table_id
             order 
                by  2,
                    3;
    
        CURSOR cons_col_cur (cur_cons_id VARCHAR2) is
            select  col.irid as columnId,
                    col.name as columnName,
                    col.datatype,
                    to_char(col.maximum_length) as dataLength,
                    col.average_length,
                    kc.sequence_number
              from  ci_columns col,
                    ci_key_components kc,
                    ci_constraints cons
             where  col.irid = kc.column_reference
               and  kc.constraint_reference = cons.irid
               and  cons.irid = cur_cons_id
             order 
                by  3;
                
        CURSOR indexes_cur (cur_table_id VARCHAR2) is
            select irid as indexId,
                   name as index_name
              from ci_relation_indexes
             where table_definition_reference = cur_table_id;
             
        CURSOR index_cols_cur (cur_index_id VARCHAR2) is
            select col.irid as columnId,
                   col.name as columnName,
                    col.datatype,
                    to_char(col.maximum_length) as dataLength,
                    col.average_length,
                   ie.sequence_number
              from ci_index_entries ie,
                   ci_columns col
             where col.irid = ie.column_reference
               and ie.relation_index_reference = cur_index_id
             order
                by 3;
               
        CURSOR key_cur(cur_column_id VARCHAR2, cur_constraint_type VARCHAR2) is
            select count('x') as ref_count
              from ci_key_components kc,
                   ci_constraints co,
                   ci_columns c
             where 
                   co.irid = kc.constraint_reference
               and c.irid = kc.column_reference
               and co.constraint_type = cur_constraint_type
               and c.irid = cur_column_id;



    BEGIN
        dbms_output.enable(1000000);
        dbms_output.put_line('<?xml version="1.0"?>');
        dbms_output.put_line(chr(10));
        dbms_output.put_line('<?xml-stylesheet type="text/xsl" href="I:\DBFORUM\Designer\HTMLReports\tableDefinition.xsl"?>');
        dbms_output.put_line(chr(10));
        dbms_output.put_line('<tables>');

        FOR td_rec in td_cur(in_application_name) LOOP
            table_html := chr(9) || '<table name="' ||
                        td_rec.tableName || 
                        '" cellpadding="4">' || chr(10);
            dbms_output.put_line(table_html);
            
            rmotext.readall(td_rec.tableId, 'CDIDSC', table_description, 4000, table_description_length);
            rmotext.readall(td_rec.tableId, 'CDINOT', table_notes, 4000, table_notes_length);

            IF table_description_length > 0 THEN
                dbms_output.put_line(chr(9) || chr(9) || '<description>');
                dbms_output.put_line(chr(9) || chr(9) || chr(9) || '<line>');
                dbms_output.put_line('<![CDATA[');
                prnt(table_description);
                dbms_output.put_line(']]>');
                dbms_output.put_line(chr(9) || chr(9) || chr(9) || '</line>');
                dbms_output.put_line(chr(9) || chr(9) || '</description>');
            END IF;

            table_html := '';
            table_html := table_html || chr(9) || chr(9) || '<deployment>' || chr(10)
			                         || chr(9) || chr(9) || chr(9) || '<line>' || chr(39) || 'WIP' || chr(39) || ' schema:FAC tablespace: WIP_DATA</line>' || chr(10)
                                     || chr(9) || chr(9) || chr(9) || '<line>_CH schema:FAC tablespace:CH_DATA</line>' || chr(10)
			                         || chr(9) || chr(9) || chr(9) || '<line>_OF schema:OFL tablespace: OFL_DATA</line>' || chr(10)
		                             || chr(9) || chr(9) || '</deployment>' || chr(10);

            dbms_output.put_line(table_html);
            
            row_bytes := 0;

        
            -- Columns
            table_html := '';
            table_html := table_html || chr(9) || chr(9) || '<columns>' || chr(10);  
						dbms_output.put_line(table_html);  
						
            FOR col_rec in col_cur(td_rec.tableId) LOOP
                rmotext.readall(col_rec.columnId, 'CDIDSC', column_description, 4000, column_description_length);
                rmotext.readall(col_rec.columnId, 'CDINOT', column_note, 4000, column_note_length);
           
                OPEN key_cur(col_rec.columnId, 'PRIMARY');
                FETCH key_cur INTO num_primary;
                IF num_primary = 0 THEN
                    pk := 'N';
                ELSE
                    pk := 'Y';
                END IF;
                
                num_primary := 0;
                close key_cur;
                
                OPEN key_cur(col_rec.columnId, 'UNIQUE');
                FETCH key_cur INTO num_primary;
                IF num_unique = 0 THEN
                    uk := 'N';
                ELSE
                    uk := 'Y';
                END IF;
                
                num_unique := 0;
                close key_cur;
                
                IF col_rec.null_indicator = 'NOT NULL' THEN
                    nl := 'N';
                ELSE
                    nl := 'Y';
                END IF;
                
                col_bytes := calculate_column_size(col_rec.datatype,
                																	 col_rec.dataLength,
                																	 col_rec.average_length);
                
            
                row_bytes := row_bytes + col_bytes;
                
                table_html := '';
    			      table_html := table_html || chr(9) || chr(9) || chr(9) || '<column>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<name>' || col_rec.name || '</name>' || chr(10);
                dbms_output.put_line(table_html);                                         
                                 
                dbms_output.put_line(chr(9) || chr(9) || chr(9) || chr(9) || '<description>');
                dbms_output.put_line('<![CDATA[');
                prnt(nvl(column_description, 'N/A'));
                dbms_output.put_line(']]>');
                dbms_output.put_line('</description>' || chr(10));
                                                 
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<dataType>' || nvl(col_rec.dataType, 'N/A') || '</dataType>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<dataLength>' || nvl(col_rec.dataLength, 'N/A') || '</dataLength>' || chr(10);
                dbms_output.put_line(table_html);                                         
                                         
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<number_of_bytes>' || col_bytes || '</number_of_bytes>' || chr(10);
                dbms_output.put_line(table_html);                                         
                                         
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<dataPrecision>' || nvl(col_rec.dataPrecision, 'N/A') || '</dataPrecision>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<key>' || pk || '</key>' || chr(10);
                dbms_output.put_line(table_html);                                         
                                         
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<unique>' || uk || '</unique>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<null>' || nvl(nl, 'N/A') || '</null>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<notes>' || nvl(column_note, 'N/A') || chr(10) || col_rec.remark || '</notes>' || chr(10);
                dbms_output.put_line(table_html);                                         
                                         
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || '</column>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || '<line>_CH schema:FAC tablespace:CH_DATA</line>' || chr(10)
    			                         || chr(9) || chr(9) || chr(9) || '<line>_OF schema:OFL tablespace: OFL_DATA</line>' || chr(10);   
                dbms_output.put_line(table_html);
            END LOOP;

            table_html := '';
            table_html := table_html || chr(9) || chr(9) || '</columns>' || chr(10);  
						dbms_output.put_line(table_html);   
            -- Columns

            -- Row Size
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<row_size>' || row_bytes || '</row_size>' || chr(10);
                dbms_output.put_line(table_html);
            -- End Row Size
            
            -- Table Rows
            		table_rows := td_rec.initial_number_of_rows + td_rec.rowsPerQuarter;

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<initial_number_of_rows>' || td_rec.initial_number_of_rows || '</initial_number_of_rows>' || chr(10);
                table_html := table_html || chr(9) || chr(9) || '<rows_per_quarter>' || td_rec.rowsPerQuarter || '</rows_per_quarter>' || chr(10);
                table_html := table_html || chr(9) || chr(9) || '<table_rows>' || table_rows || '</table_rows>' || chr(10);
                dbms_output.put_line(table_html);
            -- End Table Rows
            
            -- Table Size
            		table_bytes := row_bytes * table_rows;

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<table_size>' || table_bytes || '</table_size>' || chr(10);
                dbms_output.put_line(table_html);
            -- End Table Size
            
            -- Table Size Increase Per Quarter
            		table_bytes_per_quarter := row_bytes * td_rec.rowsPerQuarter;

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<table_size_per_quarter>' || table_bytes_per_quarter || '</table_size_per_quarter>' || chr(10);
                dbms_output.put_line(table_html);
            -- End Table Size Increase Per Quarter
            
            -- Table Block Size
            		-- Multiplying by 1.5 just for an extra factor
            		table_block_size := calculate_block_size(table_bytes);

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<table_block_size>' || table_block_size || '</table_block_size>' || chr(10);
                dbms_output.put_line(table_html);
            -- End Table Block Size

						-- Initial Table Extent
								initial_table_extent := calculate_extent_size(table_rows,
																															table_block_size,
																															base_table_block_size);
																															
								total_table_storage := total_table_storage + initial_table_extent;

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<initial_table_extent>' || initial_table_extent || '</initial_table_extent>' || chr(10);
                dbms_output.put_line(table_html);
						-- End Initial Table Extent
            
						-- Next Table Extent										
								table_block_size_per_quarter := calculate_block_size(table_bytes_per_quarter);	
								next_table_extent := calculate_extent_size(td_rec.rowsPerQuarter,
																															table_block_size_per_quarter,
																															base_table_block_size);
																															
								if next_table_extent > 1280 then
								  next_table_extent := 1280;
								end if;
																															
								total_table_storage := total_table_storage + (8 * next_table_extent);

                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<next_table_extent>' || next_table_extent || '</next_table_extent>' || chr(10);
                dbms_output.put_line(table_html);
						-- End Next Table Extent
            
            -- Constraints
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<constraints>' || chr(10);
                dbms_output.put_line(table_html);                                         
            FOR cons_rec in cons_cur(td_rec.tableId) LOOP
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || '<constraint>' || chr(10);
                dbms_output.put_line(table_html);                                         
                
                
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<name>' || cons_rec.name || '</name>' || chr(10);
                dbms_output.put_line(table_html);                                         
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<constraint_type>' || nvl(cons_rec.constraint_type, 'N/A') || '</constraint_type>' || chr(10)
                                         || chr(9) || chr(9) || chr(9) || chr(9) || '<check_constraint_type>' || nvl(cons_rec.check_constraint_type, 'N/A') || '</check_constraint_type>' || chr(10);
                dbms_output.put_line(table_html);
                
                -- Constraint Columns                                                                                  
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_columns>' || chr(10);
                dbms_output.put_line(table_html);
                
								row_bytes := 0;
								
                FOR cons_col_rec in cons_col_cur(cons_rec.constraintId) LOOP
                    table_html := '';
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_column>' || chr(10);
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<column_name>' || cons_col_rec.columnName || '</column_name>' || chr(10);
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</cons_column>' || chr(10);
                    
                    dbms_output.put_line(table_html);
										
										col_bytes := calculate_column_size(cons_col_rec.datatype,
																											 cons_col_rec.dataLength,
																											 cons_col_rec.average_length);
		                
		                row_bytes := row_bytes + col_bytes;
                										                                         
                END LOOP;
                
                                                                                                  
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '</cons_columns>' || chr(10);
                dbms_output.put_line(table_html);                                         
                -- End Constraint Columns

								-- Constraint Row Size
								if row_bytes != 0 AND (cons_rec.constraint_type = 'PRIMARY' or cons_rec.constraint_type = 'UNIQUE') then                
	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_bytes>' || row_bytes || '</cons_bytes>' || chr(10);
	                dbms_output.put_line(table_html);
	                
	                -- Constraint Initial Extent
	                cons_initial_extent := calculate_extent_size(table_rows,
	                																						 calculate_block_size(row_bytes * table_rows),
	                																						 base_table_block_size);
																															
									total_index_storage := total_index_storage + cons_initial_extent;

	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_initial_extent>' || cons_initial_extent || '</cons_initial_extent>' || chr(10);
	                dbms_output.put_line(table_html);
	                -- End Constraint Initial Extent
	                
	                -- Constraint Next Extent
	                cons_next_extent := calculate_extent_size(table_rows,
	                																					calculate_block_size(row_bytes * td_rec.rowsPerQuarter),
	                																					base_table_block_size);
																															
									if cons_next_extent > 1280 then
								  	cons_next_extent := 1280;
									end if;
																															
									total_index_storage := total_index_storage + (8 * cons_next_extent);

	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_next_extent>' || cons_next_extent || '</cons_next_extent>' || chr(10);
	                dbms_output.put_line(table_html);
	                -- End Constraint Next Extent
	                
	              end if;
                -- End Constraint Row Size
                  
                  
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || '</constraint>' || chr(10);
                dbms_output.put_line(table_html);
            END LOOP;
            table_html := '';                       
            table_html := table_html || chr(9) || chr(9) || '</constraints>' || chr(10);   
            dbms_output.put_line(table_html);
                   -- End Constraints

            -- Indexes
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || '<indexes>' || chr(10);
                dbms_output.put_line(table_html);       
								
            FOR index_rec in indexes_cur(td_rec.tableId) LOOP
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || '<index>' || chr(10);
                dbms_output.put_line(table_html);                                         
                
                
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<name>' || index_rec.index_name || '</name>' || chr(10);
                dbms_output.put_line(table_html);    
                
                -- Index Columns                                                                                  
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<index_columns>' || chr(10);
                dbms_output.put_line(table_html);
                
								row_bytes := 0;
						                                  
                FOR index_cols_rec in index_cols_cur(index_rec.indexId) LOOP
                    table_html := '';
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<index_column>' || chr(10);
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<column_name>' || index_cols_rec.columnName || '</column_name>' || chr(10);
                    table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</index_column>' || chr(10);
                    
                    dbms_output.put_line(table_html);                                         
										
										col_bytes := calculate_column_size(index_cols_rec.datatype,
																											 index_cols_rec.dataLength,
																											 index_cols_rec.average_length);
		                
		                row_bytes := row_bytes + col_bytes;

                END LOOP;                
                                                                                                  
                table_html := '';
                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '</index_columns>' || chr(10);
                dbms_output.put_line(table_html);                                         
                -- End Index Columns

								-- Index Row Size
								if row_bytes != 0 then                
	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_bytes>' || row_bytes || '</cons_bytes>' || chr(10);
	                dbms_output.put_line(table_html);
	                
	                -- Index Initial Extent
	                ix_initial_extent := calculate_extent_size(table_rows,
	                																						 calculate_block_size(row_bytes * table_rows),
	                																						 base_table_block_size);
																															
									total_index_storage := total_index_storage + ix_initial_extent;

	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<ix_initial_extent>' || ix_initial_extent || '</ix_initial_extent>' || chr(10);
	                dbms_output.put_line(table_html);
	                -- End Index Initial Extent
	                
	                -- Index Next Extent
	                ix_next_extent := calculate_extent_size(table_rows,
	                																					calculate_block_size(row_bytes * td_rec.rowsPerQuarter),
	                																					base_table_block_size);
																															
									if ix_next_extent > 1280 then
								  	ix_next_extent := 1280;
									end if;
																															
									total_index_storage := total_index_storage + (8 * ix_next_extent);

	                table_html := '';
	                table_html := table_html || chr(9) || chr(9) || chr(9) || chr(9) || '<ix_next_extent>' || ix_next_extent || '</ix_next_extent>' || chr(10);
	                dbms_output.put_line(table_html);
	                -- End Index Next Extent
	                
	              end if;
                -- End Index Row Size
                  
                table_html := '';                       
                table_html := table_html || chr(9) || chr(9) || chr(9) || '</index>' || chr(10);
                dbms_output.put_line(table_html);
            END LOOP;
            table_html := '';                       
            table_html := table_html || chr(9) || chr(9) || '</indexes>' || chr(10);   
            dbms_output.put_line(table_html);
                   -- End Indexes

            IF table_notes_length > 0 THEN
                dbms_output.put_line(chr(9) || chr(9) || '<notes>');
                prnt(table_notes);
                dbms_output.put_line(chr(9) || chr(9) || '</notes>');
            END IF;
            
            --dbms_output.put_line(table_html);
            
            table_html := '';    
            table_html := table_html || chr(9) || '</table>';
                        
            dbms_output.put_line(table_html);
        END LOOP;

        dbms_output.put_line('</tables>');
        dbms_output.put_line('<total_table_storage>' || total_table_storage || '</total_table_storage>');
        dbms_output.put_line('<total_index_storage>' || total_index_storage || '</total_index_storage>');

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('<html><body>');
            dbms_output.put_line('******************************************************************************');
            dbms_output.put_line('ERROR:');
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line('******************************************************************************');
            dbms_output.put_line('</body></html>');
    END;
END;

