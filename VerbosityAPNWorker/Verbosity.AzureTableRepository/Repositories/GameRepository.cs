using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.WindowsAzure.StorageClient;

namespace Verbosity.AzureTableRepository.Repositories
{
    public  sealed class GameRepository : Verbosity.Domain.Repositories.IGameRepository
    {
        private const string _table_name = "games";
        Microsoft.WindowsAzure.StorageClient.CloudTableClient _client;
        public GameRepository(Microsoft.WindowsAzure.StorageClient.CloudTableClient client)
        {
            _client = client;
            _client.CreateTableIfNotExist(_table_name);
        }

        public Domain.Entities.Game CreateGame(string username1, string username2, List<string> letters, List<string> words)
        {
            bool created_first_user_game = false;
            bool created_second_user_game = false;
            TableServiceContext service_context = _client.GetDataServiceContext();
            Domain.Entities.Game game_for_user1 = null;
            Domain.Entities.Game game_for_user2 = null;
            try
            {
                //create two games for each side of the game
                //this allows scalability better. they have the same guid to allow us to pinpoint this game via pk_rk more quickly on either side of the relationship
                Guid game_guid = Guid.NewGuid();

                game_for_user1 = new Domain.Entities.Game(username1, username2, letters, words, game_guid);
                game_for_user2 = new Domain.Entities.Game(username2, username1, letters, words, game_guid);

                //since they live on separate partitions, we cannot atomically create these two entities and must clean up after ourselves in case of errors
                service_context.AddObject(_table_name, game_for_user1);
                service_context.SaveChanges();
                created_first_user_game = true;
                service_context.AddObject(_table_name, game_for_user2);
                service_context.SaveChanges();
                created_second_user_game = true;
                return game_for_user1;

            }
            catch
            {
                try
                {
                    if (service_context != null)
                    {
                        if (created_first_user_game && game_for_user1 != null)
                        {
                            service_context.DeleteObject(game_for_user1);
                            service_context.SaveChanges();
                        }

                        if (created_second_user_game && game_for_user2 != null)
                        {
                            service_context.DeleteObject(game_for_user2);
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

        public Domain.Entities.Game GetGame(string username, Guid game_id)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);

                Domain.Entities.Game game = (from g in query where g.PartitionKey == username && g.RowKey == game_id.ToString("N") select g).SingleOrDefault();
                return game;
            }
            catch
            {
                throw;
            }
        }

        public Domain.Entities.Game UpdateGame(Domain.Entities.Game game)
        {
            bool updated_my_side = false;
            bool updated_other_side = false;
            Domain.Entities.Game my_old_game = new Domain.Entities.Game(game.PartitionKey, game.OtherPlayerUsername, game.Letters, game.PossibleWords, Guid.Parse(game.RowKey));
            Domain.Entities.Game other_side_old_game = null;
            TableServiceContext service_context = _client.GetDataServiceContext();
            try
            {

                service_context.UpdateObject(game);
                service_context.SaveChanges();
                updated_my_side = true;
                //also update the other side of it
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);
                Domain.Entities.Game other_side_of_game = (from g in query where g.PartitionKey == game.OtherPlayerUsername && g.RowKey == game.RowKey select game).SingleOrDefault();

                //save the old version in case we have to revert
                other_side_old_game = new Domain.Entities.Game(other_side_of_game.PartitionKey, other_side_of_game.OtherPlayerUsername, other_side_of_game.Letters, other_side_of_game.PossibleWords, Guid.Parse(other_side_of_game.RowKey));

                other_side_of_game.IsOtherPlayerDone = game.AmIDone;
                other_side_of_game.OtherPlayerScore = game.MyScore;
                other_side_of_game.OtherPlayerUsername = game.PartitionKey;
                other_side_of_game.OtherPlayerWordsFound = game.MyWordsFound;
                service_context.UpdateObject(other_side_of_game);
                service_context.SaveChanges();
                updated_other_side = true;

                return game;
            }
            catch
            {
                try
                {
                    if (service_context != null)
                    {
                        //revert on any error if possible
                        if (updated_my_side)
                        {
                            service_context.UpdateObject(my_old_game);
                            service_context.SaveChanges();
                        }

                        if (updated_other_side && other_side_old_game != null)
                        {
                            service_context.DeleteObject(other_side_old_game);
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

        public IEnumerable<Domain.Entities.Game> GetActiveGames(string username)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);

                List<Domain.Entities.Game> games = (from g in query where g.PartitionKey == username && (g.IsOtherPlayerDone == false || g.AmIDone == false) select g).ToList();
                return games;
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<Domain.Entities.Game> GetAllGames(string username)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);
                //limit to 30 days?
                List<Domain.Entities.Game> games = (from g in query where g.PartitionKey == username select g).ToList();
                return games;
            }
            catch
            {
                throw;
            }
        }

        
        public IEnumerable<Domain.Entities.Game> GetFinishedGames(string username)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);
                //todo: limit this to last 30 days?
                List<Domain.Entities.Game> games = (from g in query where g.PartitionKey == username && (g.IsOtherPlayerDone == true && g.AmIDone == true) select g).ToList();
                return games;
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<Domain.Entities.Game> GetFinishedGamesBetweenPlayers(string username1, string username2)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);

                List<Domain.Entities.Game> games = (from g in query where g.PartitionKey == username1 && g.OtherPlayerUsername == username2 && (g.IsOtherPlayerDone == true && g.AmIDone == true) select g).ToList();
                return games;
            }
            catch
            {
                throw;
            }
        }


        public bool IsGameComplete(string username1, string username2, Guid game_id)
        {
            try
            {
                TableServiceContext service_context = _client.GetDataServiceContext();
                var query = service_context.CreateQuery<Domain.Entities.Game>(_table_name);

                bool is_complete_first_perspective = (from g in query where 
                                                          g.PartitionKey == username1.ToLower() &&
                                                          g.RowKey == game_id.ToString("N") &&
                                                          g.OtherPlayerUsername == username2.ToLower() && 
                                                          (g.IsOtherPlayerDone == true && g.AmIDone == true) select 1).Any();

                bool is_complete_second_perspective = (from g in query
                                                       where
                                                           g.PartitionKey == username2.ToLower() &&
                                                           g.RowKey == game_id.ToString("N") &&
                                                           g.OtherPlayerUsername == username1.ToLower() &&
                                                           (g.IsOtherPlayerDone == true && g.AmIDone == true)
                                                       select 1).Any();

                return is_complete_first_perspective && is_complete_second_perspective;
            }
            catch
            {
                throw;
            }
        }
    }
}
