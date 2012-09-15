using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Services
{
    public sealed class GameService
    {
        private Domain.Repositories.IGameRepository _game_repo;
        public GameService(Domain.Repositories.IGameRepository game_repo, Domain.Repositories.IPlayerRepository player_repo)
        {
            _game_repo = game_repo;
        }
        Domain.Entities.Game CreateGame(string username1, string username2, List<string> letters, List<string> words)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username1) || string.IsNullOrWhiteSpace(username2))
                {
                    throw new Domain.Exceptions.ArgumentException("Usernames cannot be empty when starting a game.");
                }
                username2 = username2.ToLower();
                username1 = username1.ToLower();
                if (username2 == username1
                     || letters == null || words == null || letters.Count <= 1 || words.Count == 0)
                {
                    throw new Domain.Exceptions.ArgumentException(
                        @"Usernames cannot be the same and there must be at least one letter and word to start a game.");
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
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty when searching for a game.");
                }
                if (Guid.Empty == game_id)
                {
                    throw new Domain.Exceptions.ArgumentException("Game ID cannot be empty.");
                }
                username = username.ToLower();
                return _game_repo.GetGame(username, game_id);
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
                if (game == null)
                {
                    throw new Domain.Exceptions.ArgumentException("Game is invalid.");
                }
                return _game_repo.UpdateGame(game);
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
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty when searching for a game.");
                }
                username = username.ToLower();
                return _game_repo.GetActiveGames(username);
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
                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty when searching for a game.");
                }
                username = username.ToLower();
                return _game_repo.GetAllGames(username);
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

                if (string.IsNullOrWhiteSpace(username))
                {
                    throw new Domain.Exceptions.ArgumentException("Username cannot be empty when searching for a game.");
                }
                username = username.ToLower();
                return _game_repo.GetFinishedGames(username);
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
                if (string.IsNullOrWhiteSpace(username1) || string.IsNullOrWhiteSpace(username2))
                {
                    throw new Domain.Exceptions.ArgumentException("Usernames cannot be empty when starting a game.");
                }
                username2 = username2.ToLower();
                username1 = username1.ToLower();
                if (username2 == username1)
                {
                    throw new Domain.Exceptions.ArgumentException(
                        @"Usernames cannot be the same.");
                }
                return _game_repo.GetFinishedGamesBetweenPlayers(username1, username2);
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
                if (string.IsNullOrWhiteSpace(username1) || string.IsNullOrWhiteSpace(username2))
                {
                    throw new Domain.Exceptions.ArgumentException("Usernames cannot be empty when starting a game.");
                }
                if (username2 == username1)
                {
                    throw new Domain.Exceptions.ArgumentException(
                        @"Usernames cannot be the same.");
                }
                if (Guid.Empty == game_id)
                {
                    throw new Domain.Exceptions.ArgumentException("Game ID cannot be empty.");
                }

                username2 = username2.ToLower();
                username1 = username1.ToLower();
                
                return _game_repo.IsGameComplete(username1, username2, game_id);
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
