select 
  * 
from (
  select 'abc' as name,'hello' as name2
union all
  select 'def' as name,'hello' as name2
union all
  select 'ghi' as name,'hello' as name2
) dummy
where 1=1
and name = /*name*/'abc'
or  name in ( /*name2*/'def' , /*name3*/'ghi' ) 
