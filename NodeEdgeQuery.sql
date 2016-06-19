--===========================================================================
--Nodes
--===========================================================================

SELECT DISTINCT 
	Node.object_id AS Id,
	SCHEMA_NAME(Node.SCHEMA_ID) + '.' + Node.name AS Label,
	SCHEMA_NAME(Node.SCHEMA_ID) AS SchemaName,
	Node.type_desc AS ObjectType,
	'' AS SuggestedSchema

FROM 
	sys.objects AS Node

	INNER JOIN
	(

		SELECT
		entitySource.object_id AS [Source],
		entityTarget.object_id AS [Target]

		FROM
		sys.sql_expression_dependencies dependencies

		INNER JOIN
			sys.objects entitySource 
			ON 
			dependencies.referencing_id = entitySource.[object_id]

		LEFT OUTER JOIN
			sys.objects entityTarget 
			ON 
			dependencies.referenced_id = entityTarget.[object_id]

		WHERE 
		SCHEMA_NAME(entityTarget.SCHEMA_ID) IS NOT NULL

	) AS Edge
	ON 
	Node.object_id = Edge.[Source]
	OR
	Node.object_id = Edge.[Target]

ORDER BY 

	SCHEMA_NAME(Node.SCHEMA_ID) + '.' + Node.name

--===========================================================================
--Edges
--===========================================================================

SELECT
		entitySource.object_id AS [Source],
		entityTarget.object_id AS [Target]

		FROM
		sys.sql_expression_dependencies dependencies

		INNER JOIN
			sys.objects entitySource 
			ON 
			dependencies.referencing_id = entitySource.[object_id]

		LEFT OUTER JOIN
			sys.objects entityTarget 
			ON 
			dependencies.referenced_id = entityTarget.[object_id]

		WHERE 
		SCHEMA_NAME(entityTarget.SCHEMA_ID) IS NOT NULL