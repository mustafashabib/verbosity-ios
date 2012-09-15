using System;
using System.Collections.Generic;
using System.Linq; 
using System.Text;

namespace Verbosity.Domain.Entities
{

    public sealed class Game : BaseEntity
    {   
        //pk = player_username
        //rk = game guid
        public string OtherPlayerUsername;


        public long MyScore;
        public long OtherPlayerScore;
        
        public bool AmIDone;
        public bool IsOtherPlayerDone;

        public List<string> MyWordsFound;
        public List<string> OtherPlayerWordsFound;
        public List<string> PossibleWords;

        public List<string> Letters;
        public Game(string username1, string username2, List<string> letters, List<string> words, Guid game_guid)
        {
            PartitionKey = username1;
            RowKey = game_guid.ToString("N");
            OtherPlayerUsername = username2;
            MyScore = 0;
            OtherPlayerScore = 0;
            MyWordsFound = new List<string>();
            OtherPlayerWordsFound = new List<string>();
            PossibleWords = words;
            Letters = letters;
            AmIDone = false;
            IsOtherPlayerDone = false;
        }
    }
}
