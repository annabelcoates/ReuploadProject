using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Threading;



namespace ModelAttemptWPF
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        //private Simulation simulation;

        Random random = new Random();
        //Facebook facebook;
        public static string globalLoc;
        // Graph 1: population, degree, edge randomization (keep between 0.2-0.5)
        // e.g. "[1000,30,0.3]"
        // keywords: clustering, small-world effects
        // Graph 2: population, degree
        // e.g. "[1000,30]"
        // keywords: preferential attachment
        public const int graphGeneratorIdx = 2;
        public const string graphGeneratorArgs = "[1000,30]";
        private string smallWorldPath;
        private string resultsPath;
        private string pythonScriptPath;
        private string timeString;

        private const string smallWorldPathRel = @"small_world_graph.csv";
        private const string resultsPathRel = @"\ModelAttemptWPF\Results";
        private const string pythonScriptPathRel = @"\ModelAttemptWPF\network_generator.pyw";

        // define fixed settings 
        private const int fixedN = 1000; // the fixed number of people in the simulation
        private const int fixedK = 100; // the fixed k-value of the network (how many in each clique)
        private const int fixedNFake = 100; // number of fake news articles in the experiment
        private const int fixedNTrue = 200; // number if true news articles in the experiment (true news is more prevalent than fake news)
        private const double onlineLit = 0.5; //default mean online literacy
        private const double usePsych = 1.0; //amplification of psychology (1 = normal psych levels, 0 is no psychology effects)
        private const double doesAffect = 1.0; //whether the networkgraph affects PL/OL/ES
        private const double provideWarning = 0.0; //whether users are warned that something is fake news
        private const int RUNS = 100;
        private const double MEAN_EMO_FAKE_NEWS = 0.66;
        private const double MEAN_BEL_FAKE_NEWS = 0.2;
        private const double MEAN_EMO_TRUE_NEWS = 0.33;
        private const double MEAN_BEL_TRUE_NEWS = 0.8;
        private const double EMO_STD = 0.4;
        private const double BEL_STD = 0.25;
        // TODO
        // ? Should this be 0.5
        //public const double DEFAULT_FRAC_FOLLOWS = 0.5;
        public const int RUNTIME = 400;
        public const int FB_TIMEFRAME = 50;


        public static int semaphore = 0;

        public List<double> values;

        public MainWindow()
        {
            globalLoc = Directory.GetParent(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory()).ToString()).ToString()).ToString();
            timeString = DateTime.Now.ToString(@"yyyy\-MM\-dd\-HH\-mm\-ss");
            resultsPath = globalLoc + resultsPathRel + @"\" + timeString;
            pythonScriptPath = globalLoc + pythonScriptPathRel;
            Directory.CreateDirectory(resultsPath);
            
            int variable = 5;
            // instructions for variable:
            // 1 means that the onlineLit is variable
            // 2 means the ratio between initial true and fake news is variable
            // 3 means the timefrime is variable
            // 4 means diminishing/exaggerating emotional level of news
            // 5 means varying whether or not to use personality
            // 6 means varying whether or not derived traits spread via the network

            //double[] values = { 0, 1 };
            double[] values = { 0, 0.2, 0.4, 0.6, 0.8, 1 };


            this.UKDistributionSimulation("OL", fixedN, fixedK, fixedNFake, fixedNTrue, onlineLit, RUNTIME, variable, values); // start the simulation with these parameters
            this.SaveRunParams(variable, values, timeString);
            //this.Close();
        }

        private void UKDistributionSimulation(string name,int n,int k,int nFake,int nTrue, double ol, int runtime, int variable, double[] values)
        {
            System.Threading.ThreadPool.SetMaxThreads(16, 16);
            foreach (double val in values)
            {
                for (int i = 0; i < RUNS; i++)
                {
                    // TODO
                    // ! Multithreading fix: dummy variable
                    int runCountCurrent = 1;
                    runCountCurrent += i;
                    System.Threading.Tasks.Task t = new System.Threading.Tasks.Task(() => innerSim(name, n, k, nFake, nTrue, ol, runtime, variable, val, runCountCurrent));
                    t.Start();
                    
                    //innerSim(name, n, k, nFake, nTrue, ol, runtime, variable, val, runCountCurrent);
                }
            }
        }

        private void innerSim(string name, int n, int k, int nFake, int nTrue, double ol, int runtime, int variable, double val, int i)
        {
            semaphore++;
            Console.WriteLine("semaphore inc to " + semaphore);
            System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();
            timer.Start();
            
            string varParamString = Convert.ToInt64((val * 100)).ToString();
            string runNumberString = i.ToString();
            
            string resultsPathThread = resultsPath + @"\" + name + varParamString + "_" + runNumberString + @"\";
            Directory.CreateDirectory(resultsPathThread);
            string smallWorldPathThread = resultsPathThread + smallWorldPathRel;

            Simulation simulation = new Simulation(name, val, i,(variable == 5 ? val : usePsych), provideWarning); // create a new simulation object
            simulation.DistributionPopulate(n, nFake, nTrue); // populate with people, personality traits taken from UK distribution
            Facebook facebook = new Facebook("FacebookUK", (variable == 3 ? (int)val : FB_TIMEFRAME)); // make a facebook object

            // Give facebook a small initial population
            //int defaultFollows = Convert.ToInt32(n * DEFAULT_FRAC_FOLLOWS); // set the default number of people that each Facebook user will follow
            facebook.PopulateFromPeople(simulation.humanPopulation); // Populate facebook with users from the simulation population, make a network graph in python
            facebook.CreateMutualFollowsFromGraph(smallWorldPathThread, pythonScriptPath); // Create follows as defined by the network graph
            // TODO
            // Delete this method
            // this.facebook.CreateFollowsBasedOnPersonality(defaultFollows); // Create additional follows depending on personality traits
            
            simulation.GraphBasedDistribute(facebook, (variable == 1 ? val : ol), (variable == 6 ? val : doesAffect));
            // Create some news to be shared
            // TODO
            // ! These parameters appear to be input the wrong way around
            AddDistributedNews(
                (variable == 2 ? (int)((nFake + nTrue) * val) : nFake),
                (variable == 2 ? (int)((nFake + nTrue) * val) : nTrue),
                simulation,
                facebook,
                (variable == 4 ? (MEAN_EMO_FAKE_NEWS - 0.5) * (1 + val) + 0.5 : MEAN_EMO_FAKE_NEWS),
                MEAN_BEL_FAKE_NEWS,
                (variable == 4 ? (MEAN_EMO_TRUE_NEWS - 0.5) * (1 + val) + 0.5 : MEAN_EMO_TRUE_NEWS),
                MEAN_BEL_TRUE_NEWS
            ); // Add true and fake news into Facebook, that's e and b values are generated from a distribution

            timer.Stop();
            Console.WriteLine("Initialising run " + i + " for value " + val + " took " + timer.ElapsedMilliseconds);

            facebook.RunFor(runtime);

            SimulationEnd(simulation, facebook, resultsPathThread, smallWorldPathThread);
        }
        
        private void AddDistributedNews(int nFake,int nTrue, Simulation simulation, OSN osn,double meanEFake, double meanETrue, double meanBFake,double meanBTrue)
        {
            int nPostsPerTrue = 1; // used to vary the number of posts created per true news story
            int timeOfNews = 0;
            for (int i = 0; i < nFake; i++)
            {
                double e = simulation.NormalDistribution(meanEFake, EMO_STD); // generate an e value from normal dist
                double b = simulation.NormalDistribution(meanBFake, BEL_STD); // generate a b value from normal dist
                osn.CreateNewsRandomPoster("FakeNews", false, timeOfNews, e, b);
            }
            for (int j =nFake; j< nFake+nTrue; j++)
            {
                double e = simulation.NormalDistribution(meanETrue, EMO_STD); // generate an e value from normal dist
                double b = simulation.NormalDistribution(meanBTrue, BEL_STD); // generate a b value from normal dist
                osn.CreateNewsRandomPoster("TrueNews", true, timeOfNews, e, b,nPostsPerTrue);
            }
        }

        private void SimulationEnd(Simulation simulation, OSN facebook, string resultsPathThread, string smallWorldPathThread)
        {
            System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();
            timer.Start();

            double newValue = simulation.value;
            string endFileName = Convert.ToInt64((newValue * 100)).ToString();

            facebook.SaveFollowCSV(resultsPathThread, smallWorldPathThread);

            File.WriteAllLines(resultsPathThread + "nSharedFakeNews.csv", facebook.nSharedFakeNewsList.Select(x => string.Join(",", x)));

            File.WriteAllLines(resultsPathThread + "newsInfo.csv", facebook.newsList.Select(x => string.Join(",", x.believability, x.emotionalLevel, x.politicalLeaning)));

            var csv = new StringBuilder();
            var csv2 = new StringBuilder();
            var csvNShared = new StringBuilder();
            var csvNViewed = new StringBuilder();
            var csvSharers = new StringBuilder();
            var csvViewers = new StringBuilder();
            var csvBeliefPerNews = new StringBuilder();
            // List<double> populationAverages = simulation.CalculateAverages();
            //var firstLine = string.Format("{0},{1},{2},{3},{4},{5},{6}", populationAverages[0], populationAverages[1], populationAverages[2], populationAverages[3], populationAverages[4], populationAverages[5], populationAverages[6]);
            // csv.AppendLine(firstLine);
            File.WriteAllLines(resultsPathThread + "fakeShareProbs.csv", facebook.fakeShareProbs.Select(x => string.Join(",", x)));
            File.WriteAllLines(resultsPathThread + "trueShareProbs.csv", facebook.trueShareProbs.Select(x => string.Join(",", x)));

            foreach (News news in facebook.newsList)
            {
                // the number that shared with respect to time
                //var singleString = string.Join(",", _values.ToArray() );
                csvNShared.Append(string.Join(",",news.nSharedList.ToArray())+"\n");
                csvNViewed.Append(string.Join(",",news.nViewedList.ToArray())+ "\n"); ;


                // Write a list of everyone who has shared each news article     
                csvSharers.Append(string.Join(",", news.sharers().Select(x => string.Join(",", x.ID))) + "\n");
                csvViewers.Append(string.Join(",", news.viewers().Select(x => string.Join(",", x.ID))) + "\n");
                


               // List<double> personalityAverages = news.CalculateSharerAverages();
               // List<double> viewerAverages = news.CalculateViewerAverages();

               // var newLine = string.Format("{0},{1},{2},{3},{4},{5},{6}", personalityAverages[0], personalityAverages[1], personalityAverages[2], personalityAverages[3], personalityAverages[4], personalityAverages[5], personalityAverages[6]);
               // csv.AppendLine(newLine);

              //  var newLine2 = string.Format("{0},{1},{3},{4},{5},{6}", viewerAverages[0], viewerAverages[1], viewerAverages[2], viewerAverages[3], viewerAverages[4], viewerAverages[5], viewerAverages[6]);
              //  csv2.AppendLine(newLine2);

            }

            foreach (Account account in facebook.accountList) {
                csvBeliefPerNews.Append(
                    string.Join(",", account.person.beliefPerNews)+"\n"
                );
            }

            // TODO
            // ? Change "nSharesAll" to "nSharedAll"
            File.WriteAllText(resultsPathThread + "nSharesAll.csv", csvNShared.ToString());
            File.WriteAllText(resultsPathThread + "nViewsAll.csv", csvNViewed.ToString());
            File.WriteAllText(resultsPathThread + "sharersAll.csv", csvSharers.ToString());
            File.WriteAllText(resultsPathThread + "viewersAll.csv", csvViewers.ToString());
            File.WriteAllText(resultsPathThread + "beliefPerNews.csv", csvBeliefPerNews.ToString());
           // File.WriteAllText(resultsPathThread + "sharerPersonalityAverages.csv", csv.ToString());
           // File.WriteAllText(resultsPathThread + "viewerPersonalityAverages.csv", csv2.ToString());


            CreateNSharesCSV(resultsPathThread, facebook);
            
            //MakeNextSimulation(simulation);
            timer.Stop();
            Console.WriteLine("Writing output of run took " + timer.ElapsedMilliseconds);
            semaphore--;
            Console.WriteLine("semaphore dec to " + semaphore);
            if (semaphore == 0)
            {
                Console.WriteLine("FINISHED");
                Environment.Exit(0);
            }
        }
    
        public void CreateNSharesCSV(string resultsPathThread, OSN facebook)
        {
            var csv = new StringBuilder();
            csv.AppendLine("ID,nFollowers,o,c,e,a,n,Online Literacy,Political Leaning,nFakeShares,nTrueShares,freqUse,sessionLength,shareFreq,emotionalState,nFakeViews,nTrueViews"); // column headings
            foreach (Account account in facebook.accountList)
            {
                var line = String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16}", account.ID, account.followers.Count, account.person.opn, account.person.con, account.person.ext, account.person.agr, account.person.nrt, account.person.onlineLiteracy, account.person.politicalLeaning,account.person.nFakeShares, account.person.nTrueShares,account.person.freqUse,account.person.sessionLength, account.person.sharingFreq, account.person.emotionalState, account.person.nFakeViews, account.person.nTrueViews);// o,c,e,a,n,OL,PL nFakeShares, nTrueShares
                csv.AppendLine(line);
            }
            File.WriteAllText(resultsPathThread+"nSharesPopulation.csv", csv.ToString());

        }

        private void SaveRunParams(int variable, double[] values, string timeString)
        {
            List<string> runParams = new List<string>();
            runParams.Add(RUNS.ToString() + " # nRuns");
            runParams.Add(fixedN.ToString() + " # population");
            runParams.Add(fixedNFake.ToString() + " # nFake");
            runParams.Add(fixedNTrue.ToString() + " # nTrue");
            runParams.Add(timeString + " # timeOfRun");
            runParams.Add(variable.ToString() + " # variable");
            runParams.Add(usePsych.ToString() + " # usePsych");
            runParams.Add(doesAffect.ToString() + " # defaultDoesAffect");
            
            string varParams = "";
            foreach (double val in values)
            {
                varParams += Convert.ToInt64((val * 100)).ToString() + ",";
            }
            varParams = varParams.Remove(varParams.Length - 1);
            runParams.Add(varParams + " # variable parameters");
            
            string writeFilePath = resultsPath + @"\runParams.txt";
            File.WriteAllLines(
                writeFilePath,
                runParams
            );

            string timesFilePath = globalLoc + @"\ModelAttemptWPF\timesOfRuns.txt";
            File.AppendAllText(
                timesFilePath,
                timeString + "\n"
            );
        }
    }
}
