using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Repositories
{
    public interface IPlayerRepository
    {
        bool IsUsernameAvailable(string username);
        Domain.Entities.Player CreatePlayerWithFacebookID(string username, string facebookid, string device_id = null);
        Domain.Entities.Player CreatePlayerWithPassword(string username, string password, string device_id = null);
        Domain.Entities.Player GetPlayerByFacebookID(string facebook_id);
        Domain.Entities.Player GetPlayerByUsername(string username);
        Domain.Entities.Player GetPlayerByUsernameAndPassword(string username,string password);
        bool UpdatePlayersPassword(string username, string old_password, string new_password);
        bool LinkPlayersFacebookID(string username, string facebook_id);
        bool UpdatePlayersDeviceID(string username, string device_id);
    }
}
