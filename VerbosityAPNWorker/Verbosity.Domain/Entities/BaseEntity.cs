using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Entities
{
    public class BaseEntity
    {  
        //required
        public string RowKey;//their username
        //the first letter of their username
        public string PartitionKey;
        public DateTime TimeStamp; 
       
    }
}
