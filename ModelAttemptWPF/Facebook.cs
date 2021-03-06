using System;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace ModelAttemptWPF
{
    public class Facebook : OSN
    {
        public Facebook(string name, int ftf):base(name, ftf)
        {

        }
        public new void CreateRandomMutualFollows(Account account, int nConnections)
        {
            List<int> connectionIDs = new List<int>();
            bool connectionsNotFound = true;

            for (int i = 0; i < nConnections; i++)
            {
                connectionsNotFound = true;
                while (connectionsNotFound)
                {
                    int randomID = random.Next(0, IDCount);
                    if ((randomID != account.ID) & (connectionIDs.Contains(randomID) == false))
                    {
                        connectionIDs.Add(randomID); // use the list to keep track of who has already been followed
                        Follow(accountList[account.ID], accountList[randomID]);
                        Follow(accountList[randomID], accountList[account.ID]);
                        connectionsNotFound = false;
                    }
                }
            }
        }

        public void GenerateSmallWorldNetwork()
        {
            List<double> connectivityList = new List<double>();
            string python_script = @"..\..\..\FacebookUK\network_generator.py";
            // TODO
            // ! WARNING: Hardcoded values
            string python_args = "connected_watts_strogatz_graph [1000,50,0.3]";

            foreach (Account account in this.accountList)
            {
                connectivityList.Add(account.person.connectivity);
            }

            File.WriteAllLines(
            @"..\..\..\FacebookUK\connectivity_list.txt",
            connectivityList.Select(d => d.ToString("G17")));

            ProcessStartInfo start = new ProcessStartInfo();
            // TODO
            // ! WARNING: Hardcoded value
            // ! NOTE: You MUST change the following path to point to the location of your Python3 executable
            start.FileName = @"D:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\python.exe";
            start.Arguments = string.Format("{0} {1}", python_script, python_args);
            start.UseShellExecute = false;
            start.RedirectStandardOutput = true;
            using (Process process = Process.Start(start))
            {
                using (StreamReader reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    // Console.Write(result);
                }
            }
        }
        
        public new void CreateMutualFollowsFromGraph(string filePath)
        {
            GenerateSmallWorldNetwork();
            List<string[]> connections = LoadCsvFile(filePath);
            foreach (string[] connection in connections)
            {
                // TODO
                // Fix this for the new CSV
                int followerID = Convert.ToInt16(connection[0]);
                int followeeID = Convert.ToInt16(connection[1]);
                // TODO
                // Should this be bi-directionally symmetric by default? We can modify this at some point.
                this.Follow(accountList[followeeID], accountList[followerID]);
                this.Follow(accountList[followerID], accountList[followeeID]);
            }
        }
        
        public void CreateFollowsBasedOnPersonality(int defaultFollows)
        // TODO
        // Change this to take a default number of follows 
        // ? Is this not already done?
        {
            foreach (Account account in this.accountList)
            {
                // TODO
                // ? Behaviour doesn't align with descriptive comment of `~largeNetwork~ connectivity` which claims that `~largeNetwork~ connectivity` is "A measure of how likely someone is to have a large network group, can be greater than one".
                // Instead, `~largeNetwork~ connectivity` appears to be a multiplier or weighting on the default number of followers.
                // `~largeNetwork~ connectivity` is more like a randomly distributed variable
                int nConnections = Convert.ToInt16(account.person.connectivity * defaultFollows);
                this.CreateRandomMutualFollows(account, nConnections);
            }
        }
    }
}