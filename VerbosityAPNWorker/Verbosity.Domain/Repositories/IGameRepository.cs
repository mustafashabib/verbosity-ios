using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Repositories
{
    public interface IGameRepository
    {
        Domain.Entities.Game CreateGame(string username1, string username2, List<string> letters, List<string> words);
        Domain.Entities.Game GetGame(string username, Guid game_id);
        Domain.Entities.Game UpdateGame(Domain.Entities.Game game);
        IEnumerable<Domain.Entities.Game> GetActiveGames(string username);
        IEnumerable<Domain.Entities.Game> GetAllGames(string username);
        IEnumerable<Domain.Entities.Game> GetFinishedGames(string username);
        IEnumerable<Domain.Entities.Game> GetFinishedGamesBetweenPlayers(string username1, string username2);
        bool IsGameComplete(string username1, string username2, Guid game_id);
    }
}
