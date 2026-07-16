#!/bin/bash
 
/opt/mssql/bin/sqlservr &
 
echo "Aguardando SQL Server inicializar..."
sleep 30
 
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Admin@1234" -No -Q "
RESTORE DATABASE [AdventureWorks2022]
FROM DISK = N'/var/backups/AdventureWorks2022.bak'
WITH
  MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022.mdf',
  MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf',
  NOUNLOAD,
  STATS = 5
"
 
echo "Restore concluído."
wait