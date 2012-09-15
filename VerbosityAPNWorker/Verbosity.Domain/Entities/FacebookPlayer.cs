using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Entities
{
    //create a link between a player and their facebook id allowing us to query on their rk by facebookid and find out their playerinfo
    public sealed class FacebookPlayer : BaseEntity
    {
        //partitionkey = facebook_id
        //rk = facebook_id
        public string Username;
        public FacebookPlayer(string facebook_id, string username)
        {
            PartitionKey = facebook_id.ToLower();
            RowKey = facebook_id.ToLower();
            Username = username;
        }
    }
}
