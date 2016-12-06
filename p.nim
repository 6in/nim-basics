import db_postgres
let db = open("", "postgres", "postgres", "host=localhost port=5432 dbname=sample")

for row in db.fastRows( sql"select * from test") :
  echo row

db.close()
