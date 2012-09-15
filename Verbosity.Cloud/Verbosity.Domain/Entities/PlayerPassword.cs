using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Entities
{
    public sealed class PlayerPassword : BaseEntity
    {
        //partitionkey = player_username
        //rk = passwordhash
        public PlayerPassword(string username, string password)
        {
            if (!string.IsNullOrWhiteSpace(password) && password.Length >= 4 && password.Length <= 7)
            {
                username = username.ToLower();
                var md5 = System.Security.Cryptography.MD5.Create();
                var inputBytes = System.Text.Encoding.UTF8.GetBytes(password + username);
                byte[] hash = md5.ComputeHash(inputBytes);
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hash.Length; i++)
                {
                    sb.Append(hash[i].ToString("X2"));
                }
                this.RowKey = sb.ToString();
                this.PartitionKey = username;
            }
            else
            {
                throw new Domain.Exceptions.ArgumentException("password", "Password cannot be blank and must be between than 4 and 7 characters long.");
            }
        }

    }
}
