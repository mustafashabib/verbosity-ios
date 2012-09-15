using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Services
{
    public sealed class PlayerService
    {
        private Domain.Repositories.IPlayerRepository _player_repo;
        public PlayerService(Domain.Repositories.IPlayerRepository player_repo)
        {
            _player_repo = player_repo;
        }

        bool IsUsernameAvailable(string username)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                username = username.ToLower();
                return _player_repo.IsUsernameAvailable(username);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        Domain.Entities.Player CreatePlayerWithFacebookID(string username, string facebookid, string device_id = null)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                if (string.IsNullOrWhiteSpace(facebookid))
                {
                    throw new Domain.Exceptions.ArgumentException("Facebook ID cannot be empty.");
                }
                username = username.ToLower();
                facebookid = facebookid.ToLower();
                if (!string.IsNullOrEmpty(device_id))
                {
                    device_id = device_id.Trim(); //only trim if it is not null or empty
                }
                return _player_repo.CreatePlayerWithFacebookID(username, facebookid, device_id);


            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        Domain.Entities.Player CreatePlayerWithPassword(string username, string password, string device_id = null)
        {
            try
            {

                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                if (string.IsNullOrWhiteSpace(password))
                {
                    throw new Domain.Exceptions.ArgumentException("Facebook ID cannot be empty.");
                }
                username = username.ToLower();
               
                if (!string.IsNullOrEmpty(device_id))
                {
                    device_id = device_id.Trim(); //only trim if it is not null or empty
                }
                return _player_repo.CreatePlayerWithFacebookID(username, password, device_id);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        Domain.Entities.Player GetPlayerByFacebookID(string facebook_id)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(facebook_id))
                {
                    throw new Domain.Exceptions.ArgumentException("Facebook ID cannot be empty.");
                }
                facebook_id = facebook_id.ToLower();
                return _player_repo.GetPlayerByFacebookID(facebook_id);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        Domain.Entities.Player GetPlayerByUsername(string username)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                username = username.ToLower();
                return _player_repo.GetPlayerByFacebookID(username);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        Domain.Entities.Player GetPlayerByUsernameAndPassword(string username, string password)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                username = username.ToLower();
                return _player_repo.GetPlayerByUsernameAndPassword(username, password);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        bool UpdatePlayersPassword(string username, string old_password, string new_password)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                username = username.ToLower();
                if (string.IsNullOrWhiteSpace(new_password))
                {
                    throw new Domain.Exceptions.ArgumentException("New pass cannot be empty.");
                
                }

                if (new_password != old_password)
                {

                    return _player_repo.UpdatePlayersPassword(username, old_password, new_password);
                }
                else
                {
                    return true;//just return true if the password isn't changing to save a db call
                }
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        bool LinkPlayersFacebookID(string username, string facebook_id)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                if (string.IsNullOrWhiteSpace(facebook_id))
                {
                    throw new Domain.Exceptions.ArgumentException("Facebook ID cannot be empty.");
                }
                username = username.ToLower();
                facebook_id = facebook_id.ToLower();
                return _player_repo.LinkPlayersFacebookID(username, facebook_id);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
        bool UpdatePlayersDeviceID(string username, string device_id)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty.");
                }
                if (string.IsNullOrWhiteSpace(device_id))
                {
                    throw new Domain.Exceptions.ArgumentException("Device ID cannot be empty.");
                }
                username = username.ToLower();
                device_id = device_id.ToLower();
                return _player_repo.UpdatePlayersDeviceID(username, device_id);
            }
            catch (Domain.Exceptions.Exception)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw new Domain.Exceptions.Exception(ex);
            }
        }
    }
}
