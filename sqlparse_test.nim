import parsesql,streams

let sql = """
select abc from table1;
"""

let node = parsesql.parseSql(newStringStream(sql),"stdin")
echo node.kind
echo node.sons.len
echo node.sons[0].kind
echo node.sons[1].kind

