using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.WindowsAzure.StorageClient;

namespace Verbosity.AzureTableRepository.Repositories
{
    public sealed class PlayerRepository : Verbosity.Domain.Repositories.IPlayerRepository
    { 
        private const string _table_name = "players";
        private const string _facebook_player_table_name = "facebook_players";
        private const string _player_password_table_name = "players_passwords";
        Microsoft.WindowsAzure.StorageClient.CloudTableClient _client;
        public PlayerRepository(Microsoft.WindowsAzure.StorageClient.CloudTableClient client)
        {
            _client = client;
            _client.CreateTableIfNotExist(_table_name);
            _client.CreateTableIfNotExist(_facebook_player_table_name);
            _client.CreateTableIfNotExist(_player_password_table_name);
        }
        public bool IsUsernameAvailable(string username)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Player>(_table_name);

               return !(from p in query where p.PartitionKey == username.Substring(0,1).ToUpper() && p.RowKey == username.ToLower() select true).Any();
            }
            catch
            {
                throw;
            }
        }

        public bool IsFacebookIDAvailable(string facebook_id)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.FacebookPlayer>(_facebook_player_table_name);

                return !(from p in query where p.PartitionKey == facebook_id.ToLower() && p.RowKey == facebook_id.ToLower() select true).Any();
            }
            catch
            {
                throw;
            }
        }

        public Domain.Entities.Player CreatePlayerWithFacebookID(string username, string facebook_id, string device_id = null)
        {
            
            bool created_player = false;
            bool created_player_fb_link = false;
            
            Domain.Entities.Player player = null;
            Domain.Entities.FacebookPlayer player_facebook = null;
            TableServiceContext service_context = _client.GetDataServiceContext();

            username = username.ToLower();
            facebook_id = facebook_id.ToLower();
            try{
                if (IsUsernameAvailable(username) && IsFacebookIDAvailable(facebook_id))
                {
                    player = new Domain.Entities.Player(username, facebook_id);
                    player.DeviceID = device_id;
                    service_context.AddObject(_table_name, player);
                    service_context.SaveChanges();
                    created_player = true;

                    player_facebook = new Domain.Entities.FacebookPlayer(facebook_id, username);
                    service_context.AddObject(_facebook_player_table_name, player_facebook);
                    service_context.SaveChanges();

                    created_player_fb_link = true;
                    return player;
                }
                else
                {
                    throw new ArgumentException("Username or FB ID already registered.", "username or facebook_id");
                }
           }
            catch{
                try
                {
                    if (service_context != null)
                    {
                        //revert on any error if possible
                        if (created_player)
                        {
                            service_context.DeleteObject(player);
                            service_context.SaveChanges();
                        }

                        if (created_player_fb_link && player_facebook != null)
                        {
                            service_context.DeleteObject(player_facebook);
                            service_context.SaveChanges();
                        }
                    }
                }
                catch
                {
                }

                throw;
            }
        }

        public Domain.Entities.Player CreatePlayerWithPassword(string username, string password, string device_id = null)
        {
            bool created_player = false;
            bool created_player_pass_link = false;

            Domain.Entities.Player player = null;
            Domain.Entities.PlayerPassword player_password = null;
            TableServiceContext service_context = _client.GetDataServiceContext();

            username = username.ToLower();
           
            try
            {
                if (IsUsernameAvailable(username))
                {
                    player = new Domain.Entities.Player(username);
                    player.DeviceID = device_id;
                    service_context.AddObject(_table_name, player);
                    service_context.SaveChanges();
                    created_player = true;

                    player_password = new Domain.Entities.PlayerPassword(username, password);
                    service_context.AddObject(_player_password_table_name, player_password);
                    service_context.SaveChanges();

                    created_player_pass_link = true;
                    return player;
                }
                else
                {
                    throw new ArgumentException("Username already registered.", "username");
                }
            }
            catch
            {
                try
                {
                    if (service_context != null)
                    {
                        //revert on any error if possible
                        if (created_player)
                        {
                            service_context.DeleteObject(player);
                            service_context.SaveChanges();
                        }

                        if (created_player_pass_link && player_password != null)
                        {
                            service_context.DeleteObject(player_password);
                            service_context.SaveChanges();
                        }
                    }
                }
                catch
                {
                }

                throw;
            }
        }

        public Domain.Entities.Player GetPlayerByFacebookID(string facebook_id)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var fb_p_query = service_context.CreateQuery<Domain.Entities.FacebookPlayer>(_facebook_player_table_name);
                string player_username = (from fbp in fb_p_query where fbp.PartitionKey == facebook_id.ToLower() && fbp.RowKey == facebook_id.ToLower() select fbp.RowKey.ToLower()).SingleOrDefault();
                if (string.IsNullOrWhiteSpace(player_username))
                {
                    return null;
                }
                var query = service_context.CreateQuery<Domain.Entities.Player>(_table_name);

                Domain.Entities.Player player = (from p in query where p.PartitionKey == player_username.Substring(0, 1).ToUpper()
                                                 && p.RowKey == player_username
                                             select p).SingleOrDefault();

                return player;
            }
            catch
            {
                throw;
            }
        }

        public Domain.Entities.Player GetPlayerByUsername(string username)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Player>(_table_name);

                Domain.Entities.Player player = (from p in query
                                                 where p.PartitionKey == username.Substring(0, 1).ToUpper()
                                                     && p.RowKey == username.ToLower()
                                                 select p).SingleOrDefault();

                return player;
            }
            catch
            {
                throw;
            }
        }

        public Domain.Entities.Player GetPlayerByUsernameAndPassword(string username, string password)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var p_pass_query = service_context.CreateQuery<Domain.Entities.PlayerPassword>(_player_password_table_name);
                var temp_player = new Domain.Entities.PlayerPassword(username, password);
                var hashedpass = temp_player.RowKey;
                string player_username = (from pp in p_pass_query 
                                          where pp.PartitionKey == username.ToLower() 
                                              && pp.RowKey == hashedpass 
                                          select username).SingleOrDefault();
                if (string.IsNullOrWhiteSpace(player_username))
                {
                    return null;
                }

                
                var query = service_context.CreateQuery<Domain.Entities.Player>(_table_name);

                Domain.Entities.Player player = (from p in query
                                                 where p.PartitionKey == player_username.Substring(0, 1).ToUpper()
                                                     && p.RowKey == player_username
                                                 select p).SingleOrDefault();

                return player;
            }
            catch
            {
                throw;
            }
        }

        public bool UpdatePlayersPassword(string username, string old_password, string new_password)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();

                var p_pass_query = service_context.CreateQuery<Domain.Entities.PlayerPassword>(_player_password_table_name);
                var old_temp_player = new Domain.Entities.PlayerPassword(username, new_password);
                var old_hashedpass = old_temp_player.RowKey;

                var new_temp_player_pass = new Domain.Entities.PlayerPassword(username, new_password);
                var new_hashedpass = new_temp_player_pass.RowKey;

                //check if old pass works out
                string player_username = (from pp in p_pass_query
                                          where pp.PartitionKey == username.ToLower()
                                              && pp.RowKey == old_hashedpass
                                          select username).SingleOrDefault();
                if (string.IsNullOrWhiteSpace(player_username))
                {
                    return false;
                }
                if (player_username.ToLower() == username.ToLower())
                {
                    service_context.UpdateObject(new_temp_player_pass);
                    service_context.SaveChanges();
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                throw;
            }
        }

        public bool LinkPlayersFacebookID(string username, string facebook_id)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var fb_p_query = service_context.CreateQuery<Domain.Entities.FacebookPlayer>(_facebook_player_table_name);
                var player_query = service_context.CreateQuery<Domain.Entities.Player>(_table_name);
                
                string username_of_player_with_fbid = (from fbp in fb_p_query where fbp.PartitionKey == facebook_id.ToLower() && fbp.RowKey == facebook_id.ToLower() select fbp.Username.ToLower()).SingleOrDefault();
                if (!string.IsNullOrWhiteSpace(username_of_player_with_fbid) && username.ToLower() !=username_of_player_with_fbid) //this facebook id was once tied to a username
                {
                    return false;
                }
                if (username_of_player_with_fbid.ToLower() == username.ToLower())
                {
                    return true; //already linked
                }

                Domain.Entities.Player original_player_to_update = (from p in player_query where p.PartitionKey == username.Substring(0, 1).ToUpper() && p.RowKey == username.ToLower() select p).SingleOrDefault();
                if (original_player_to_update == null)
                {
                    return false;
                }
                original_player_to_update.FacebookID = facebook_id.ToLower();
                service_context.UpdateObject(original_player_to_update);
                service_context.SaveChanges();

                Domain.Entities.FacebookPlayer fb_player = new Domain.Entities.FacebookPlayer(facebook_id, username.ToLower());
                service_context.AddObject(_facebook_player_table_name, fb_player);
                service_context.SaveChanges();
                return true;
            }
            catch
            {
                throw;
            }
        }

        public bool UpdatePlayersDeviceID(string username, string device_id)
        {
            try
            {
                var p = GetPlayerByUsername(username);
                if (p == null)
                {
                    return false;
                }
                p.DeviceID = device_id;
                TableServiceContext service_context = _client.GetDataServiceContext();

                service_context.AddObject(_table_name, p);
                return true;
            }
            catch
            {
                throw;
            }
        }
    }
}
