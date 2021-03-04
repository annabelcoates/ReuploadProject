using System;
using System.Diagnostics;
using System.Collections.Generic;

namespace ModelAttemptWPF
{
    public class Facebook : OSN
    {
        public Facebook(string name, int ftf):base(name, ftf)
        {

        }
        public new void CreateRandomMutualFollows(Account account, int nConnections)
        {
            List<int> connectionIDS = new List<int>();
            bool connectionsNotFound = true;

            for (int i = 0; i < nConnections; i++)
            {
                connectionsNotFound = true;
                while (connectionsNotFound)
                {
                    int randomID = random.Next(0, IDCount);
                    if ((randomID != account.ID) & (connectionIDS.Contains(randomID) == false))
                    {
                        connectionIDS.Add(randomID); // use the list to keep track of who has already been followed
                        Follow(accountList[account.ID], accountList[randomID]);
                        Follow(accountList[randomID], accountList[account.ID]);
                        connectionsNotFound = false;
                    }
                }
            }
        }

        public void generateSmallWorldNetwork(string[] args)
        {
            string networkGeneratorPath = @"..\..\..\FacebookUK\network_generator.py";
            string smallWorldNetworkPath = @"..\..\..\FacebookUK\small_world_network.csv.py";
            ProcessStartInfo start = new ProcessStartInfo();
            start.FileName = "my/full/path/to/python.exe";
            start.Arguments = string.Format("{0} {1}", cmd, args);
            start.UseShellExecute = false;
            start.RedirectStandardOutput = true;
            using(Process process = Process.Start(start))
            {
                using(StreamReader reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    Console.Write(result);
                }
            }
        }
        public new void CreateMutualFollowsFromGraph(string filePath)
        {
            List<string[]> connections = LoadCsvFile(filePath);
            foreach (string[] connection in connections)
            {
                int followerID = Convert.ToInt16(connection[0]);
                int followeeID = Convert.ToInt16(connection[1]);
                // TODO: should this be bi-directionally symmetric by default? We can modify this at some point.
                this.Follow(accountList[followeeID], accountList[followerID]);
                this.Follow(accountList[followerID], accountList[followeeID]);
            }
        }
        public void CreateFollowsBasedOnPersonality(int defaultFollows)
        // TODO: Change this to take a default number of follows
        {
            foreach (Account account in this.accountList)
            {
                int nConnections = Convert.ToInt16(account.person.largeNetwork * defaultFollows);
                this.CreateRandomMutualFollows(account, nConnections);
            }
        }
    }
}