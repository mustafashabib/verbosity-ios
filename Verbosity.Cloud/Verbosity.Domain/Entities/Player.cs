using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Entities
{
    internal static class _PlayerUtilities
    {
        private static System.Text.RegularExpressions.Regex _username_regex_check = new System.Text.RegularExpressions.Regex(
                "[a-z0-9]{5,7}",
                System.Text.RegularExpressions.RegexOptions.Compiled |
                System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        internal static bool IsUsernameValid(string username)
        {
            return _username_regex_check.IsMatch(username);
        }

    }
    public sealed class Player : BaseEntity
    {
        //partitionkey = first letter of username
        //rowkey = username

        public string DeviceID;
        public string FacebookID;

        public Player(string username)
        {
           
            //partition users on first letter of name for even distribution-with 300m users as an extremely
            //optimistic max guess of total players in the games lifetime, that means a max of 8m records will be 
            //created per player table partition, which given a rowkey of a username (lowercase) should perform well
            //in a "oh god we have to scale" situation
            if (!string.IsNullOrWhiteSpace(username) && _PlayerUtilities.IsUsernameValid(username))
            {
                DateTime now = DateTime.UtcNow;
                PartitionKey = username.Substring(0, 1).ToUpper();
                RowKey = username.ToLower(); //minimum 5 chars - 36chars per position (0-9a-z)
            
            }
            else throw new Domain.Exceptions.ArgumentException(username, "Username cannot be blank and must contain only letters and numbers (a-z and 0-9).");
        }

        public Player(string username, string fb_id)
        {

            //partition users on first letter of name for even distribution-with 300m users as an extremely
            //optimistic max guess of total players in the games lifetime, that means a max of 8m records will be 
            //created per player table partition, which given a rowkey of a username (lowercase) should perform well
            //in a "oh god we have to scale" situation
            if (!string.IsNullOrWhiteSpace(username) && _PlayerUtilities.IsUsernameValid(username))
            {
                DateTime now = DateTime.UtcNow;
                PartitionKey = username.Substring(0, 1).ToUpper();
                RowKey = username.ToLower(); //minimum 5 chars - 36chars per position (0-9a-z)
                FacebookID = fb_id;

            }
            else throw new Domain.Exceptions.ArgumentException(username, "Username cannot be blank and must contain only letters and numbers (a-z and 0-9).");
        }

    }
}
