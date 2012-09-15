using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Services
{
    public sealed class GameService
    {
        private Domain.Repositories.IGameRepository _game_repo;
        public GameService(Domain.Repositories.IGameRepository game_repo)
        {
            _game_repo = game_repo;
        }
        Domain.Entities.Game CreateGame(string username1, string username2, List<string> letters, List<string> words)
        {
            try
            {
                username2 = username2.ToLower();
                username1 = username1.ToLower();
                if (string.IsNullOrWhiteSpace(username1) || string.IsNullOrWhiteSpace(username2) || username2 == username1
                    || letters == null || words == null || letters.Count <= 1 || words.Count == 0)
                {
                    throw new Domain.Exceptions.ArgumentException("Username's cannot be empty or the same, there must be at least one letter and word to start a game.");
                }
                return _game_repo.CreateGame(username1, username2, letters, words);
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
        Domain.Entities.Game GetGame(string username, Guid game_id)
        {
            try
            {
                throw new NotImplementedException();
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
        Domain.Entities.Game UpdateGame(Domain.Entities.Game game)
        {
            try
            {
                throw new NotImplementedException();
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
        IEnumerable<Domain.Entities.Game> GetActiveGames(string username)
        {
            try
            {
                throw new NotImplementedException();
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
        IEnumerable<Domain.Entities.Game> GetAllGames(string username)
        {
            try
            {
                throw new NotImplementedException();
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
        IEnumerable<Domain.Entities.Game> GetFinishedGames(string username)
        {
            try
            {
                throw new NotImplementedException();
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
        IEnumerable<Domain.Entities.Game> GetFinishedGamesBetweenPlayers(string username1, string username2)
        {
            try
            {
                throw new NotImplementedException();
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
        bool IsGameComplete(string username1, string username2, Guid game_id)
        {
            try
            {
                throw new NotImplementedException();
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
