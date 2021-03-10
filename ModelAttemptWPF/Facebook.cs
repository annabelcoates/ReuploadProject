using System;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace ModelAttemptWPF
{


    public class Facebook : OSN
    {
        private const String pythonRel = @"\ModelAttemptWPF\network_generator.py";
        private const String pythonSrcFile = @"\ModelAttemptWPF\pythonSource.txt";
        public Facebook(string name, int ftf):base(name, ftf)
        {

        }
        
        // TODO
        // ! Dead code
        //public new void CreateRandomMutualFollows(Account account, int nConnections)
        //{
        //    List<int> connectionIDs = new List<int>();
        //    bool connectionsNotFound = true;

        //    for (int i = 0; i < nConnections; i++)
        //    {
        //        connectionsNotFound = true;
        //        while (connectionsNotFound)
        //        {
        //            int randomID = random.Next(0, IDCount);
        //            if ((randomID != account.ID) & (connectionIDs.Contains(randomID) == false))
        //            {
        //                connectionIDs.Add(randomID); // use the list to keep track of who has already been followed
        //                Follow(accountList[account.ID], accountList[randomID]);
        //                Follow(accountList[randomID], accountList[account.ID]);
        //                connectionsNotFound = false;
        //            }
        //        }
        //    }
        //}

        public void GenerateSmallWorldNetwork(string graphFilePath, string scriptFilePath)
        {
            // TODO
            // ! WARNING: Hardcoded values
            string python_args = "connected_watts_strogatz_graph [1000,50,0.3]" + " " + graphFilePath;
            ProcessStartInfo start = new ProcessStartInfo();
            // ! NOTE: You MUST store the path string of your Python3 executable in the python source file
            using (System.IO.StreamReader file = new System.IO.StreamReader(MainWindow.globalLoc + pythonSrcFile))
            {
                start.FileName = file.ReadLine();
                start.Arguments = string.Format("{0} {1}", scriptFilePath, python_args);
                start.UseShellExecute = false;
                start.RedirectStandardOutput = true;

                using (Process process = Process.Start(start))
                {
                    using (StreamReader reader = process.StandardOutput)
                    {
                        string result = reader.ReadToEnd();
                        Console.Write(result);
                    }
                }
            }
        }
        
        // TODO
        // ? Should we have the `new` keyword set or should we remove it
        public new void CreateMutualFollowsFromGraph(string graphFilePath, string scriptFilePath)
        {
            accountList = accountList.OrderBy(o => o.person.connectivity).ToList();
            GenerateSmallWorldNetwork(graphFilePath, scriptFilePath);
            List<string[]> connections = LoadCsvFile(graphFilePath);
            foreach (string[] connection in connections)
            {
                int followerID = Convert.ToInt16(connection[0]);
                int followeeID = Convert.ToInt16(connection[1]);
                this.Follow(accountList[followeeID], accountList[followerID]);
                this.Follow(accountList[followerID], accountList[followeeID]);
            }
        }
    }
}