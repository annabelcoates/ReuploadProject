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
        private Simulation simulation;

        Random random = new Random();
        Facebook facebook;
        public static string globalLoc;
        private string smallWorldPath;

        private const string smallWorldPathRel = @"\FacebookUK\small_world_graph.csv";
        private const string pythonSource = @"\FacebookUK\pythonSource.txt";

        // define fixed settings 
        private const int fixedN = 1000; // the fixed number of people in the simulation
        private const int fixedK = 100; // the fixed k-value of the network (how many in each clique)
        private const int fixedNFake = 100; // number of fake news articles in the experiment
        private const int fixedNTrue = 200; // number if true news articles in the experiment (true news is more prevalent than fake news)
        private const double onlineLit = 0.4; //mean online literacy
        private const int RUNS = 1;

        private const double MEAN_EMO_FAKE_NEWS = 0.66;
        private const double MEAN_BEL_FAKE_NEW = 0.33;
        private const double MEAN_EMO_TRUE_NEWS = 0.33;
        private const double MEAN_BEL_TRUE_NEWS = 0.66;
        private const double EMO_STD = 0.15;
        private const double BEL_STD = 0.15;
        // TODO
        // ? Should this be 0.5
        //public const double DEFAULT_FRAC_FOLLOWS = 0.5;
        public const int RUNTIME = 300;
        public const int FB_TIMEFRAME = 50;

        public List<double> values;

        public MainWindow()
        {
            globalLoc = Directory.GetParent(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory()).ToString()).ToString()).ToString();
            smallWorldPath = globalLoc + smallWorldPathRel;
            //this.values = new List<int> { 1, 2, 4, 6, 8, 10, 12 };
            int variable = 1;
            // instructions for variable:
            // 1 means that the onlineLit is variable
            // 2 means the ratio between initial true and fake news is variable
            // 3 means the timefrime is variable
            // 4 means diminishing/exaggerating emotional level of news

            // TODO
            // ? This is where OL40 and OL60 come from, I believe
            double[] values = { 0.4, 0.6 };
            this.UKDistributionSimulation("OL", fixedN, fixedK, fixedNFake, fixedNTrue, onlineLit, RUNTIME, variable, values); // start the simulation with these parameters
            this.Close();
            //this.RunLoop(100);
        }

        /*private void SetClockFunctions()
        {
            Clock.Interval = TimeSpan.FromMilliseconds(150f / simulation.runSpeed);
            Clock.Tick += StandardFBUpdate;

            InitializeComponent();
            Clock.Start();
            MinClock.Start();
        }*/
        /*private Boolean StandardFBUpdate()
        {
            this.facebook.TimeSlotPasses(simulation.time);

            if (simulation.time == 1000)
            {
                // prevent timer based functions firing during the next simulation being made
                this.Clock = new DispatcherTimer();
                this.MinClock = new DispatcherTimer();

                SimulationEnd(this.simulation);
            }
            else if (simulation.time % 100 == 0)
            {
             //   this.AddDistributedNews(0, 1, this.facebook);
            }
            simulation.time++;
            return (simulation.time > RUNTIME);
        }*/

        /*private void RunLoop(int iterations=1000)
        {
            for (int timestep = 0; timestep < iterations; timestep++)
            {
                this.facebook.TimeSlotPasses(timestep);
                if (timestep == 1000)
                {
                    // prevent timer based functions firing during the next simulation being made
                    this.Clock = new DispatcherTimer();
                    this.MinClock = new DispatcherTimer();

                    SimulationEnd(this.simulation);
                }
            }
        }*/

        private void UKDistributionSimulation(string name,int n,int k,int nFake,int nTrue, double ol, int runtime, int variable, double[] values)
        {
            foreach (double val in values)
            {
                for (int i = 0; i < RUNS; i++)
                {
                    System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();
                    timer.Start();

                    //this.Activate();
                    this.simulation = new Simulation(name, val, i+1); // create a new simulation object
                    this.simulation.DistributionPopulate(n); // populate with people, personality traits taken from UK distribution
                    this.facebook = new Facebook("FacebookUK", (variable == 3 ? (int) val : FB_TIMEFRAME)); // make a facebook object

                    // Give facebook a small initial population
                    //int defaultFollows = Convert.ToInt32(n * DEFAULT_FRAC_FOLLOWS); // set the default number of people that each Facebook user will follow
                    this.facebook.PopulateFromPeople(simulation.humanPopulation); // Populate facebook with users from the simulation population, make a network graph in python
                    this.facebook.CreateMutualFollowsFromGraph(smallWorldPath); // Create follows as defined by the network graph
                    // TODO
                    // Delete this method
                    // this.facebook.CreateFollowsBasedOnPersonality(defaultFollows); // Create additional follows depending on personality traits
                    this.simulation.GraphBasedDistribute(facebook, (variable == 1 ? val : ol));
                    // Create some news to be shared
                    AddDistributedNews((variable == 2 ? (int) ((nFake + nTrue) * val) : nFake), (variable == 2 ? (int) ((nFake + nTrue) * val) : nTrue), this.facebook, (variable == 4 ? (MEAN_EMO_FAKE_NEWS - 0.5) * (1+val) + 0.5 : MEAN_EMO_FAKE_NEWS), MEAN_BEL_FAKE_NEW, (variable == 4 ? (MEAN_EMO_TRUE_NEWS - 0.5) * (1 + val) + 0.5 : MEAN_EMO_TRUE_NEWS), MEAN_BEL_TRUE_NEWS); // Add true and fake news into Facebook, that's e and b values are generated from a distribution
                                      
                    timer.Stop();
                    Console.WriteLine("Initialising run " + i + " for value " + val + " took " + timer.ElapsedMilliseconds);

                    facebook.RunFor(runtime);
                    
                    SimulationEnd();
                }
            }
        }
        
        private void AddDistributedNews(int nFake,int nTrue, OSN osn,double meanEFake, double meanETrue, double meanBFake,double meanBTrue)
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

       
        private void SimulationEnd()
        {
            System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();
            timer.Start();

            double newValue = simulation.value;
            string endFileName = Convert.ToInt64((newValue * 100)).ToString();

            string generalPath = @"..\..\Results\" + simulation.versionName + endFileName +"_"+simulation.runNumber+@"\"; //!! set to local results folder
           Directory.CreateDirectory(generalPath);
            Console.WriteLine(generalPath);

            facebook.SaveFollowCSV(generalPath);

            File.WriteAllLines(generalPath + "nSharedFakeNews.csv", this.facebook.nSharedFakeNewsList.Select(x => string.Join(",", x)));

            File.WriteAllLines(generalPath + "newsInfo.csv", this.facebook.newsList.Select(x => string.Join(",", x.believability, x.emotionalLevel)));

            var csv = new StringBuilder();
            var csv2 = new StringBuilder();
            var csvNShared = new StringBuilder();
            var csvNViewed = new StringBuilder();
            var csvSharers = new StringBuilder();
            var csvViewers = new StringBuilder();
            // List<double> populationAverages = simulation.CalculateAverages();
            //var firstLine = string.Format("{0},{1},{2},{3},{4},{5},{6}", populationAverages[0], populationAverages[1], populationAverages[2], populationAverages[3], populationAverages[4], populationAverages[5], populationAverages[6]);
            // csv.AppendLine(firstLine);
            File.WriteAllLines(generalPath + "fakeShareProbs.csv", facebook.fakeShareProbs.Select(x => string.Join(",", x)));
            File.WriteAllLines(generalPath + "trueShareProbs.csv", facebook.trueShareProbs.Select(x => string.Join(",", x)));
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
            File.WriteAllText(generalPath + "nSharesAll.csv", csvNShared.ToString());
            File.WriteAllText(generalPath + "nViewsAll.csv", csvNViewed.ToString());
            File.WriteAllText(generalPath + "sharersAll.csv", csvSharers.ToString());
            File.WriteAllText(generalPath + "viewersAll.csv", csvViewers.ToString());
           // File.WriteAllText(generalPath + "sharerPersonalityAverages.csv", csv.ToString());
           // File.WriteAllText(generalPath + "viewerPersonalityAverages.csv", csv2.ToString());


            CreateNSharesCSV(generalPath);

            //MakeNextSimulation(simulation);
            timer.Stop();
            Console.WriteLine("Writing output of run took " + timer.ElapsedMilliseconds);

        }

        /*private void MakeNextSimulation(Simulation currentSimulation)
        {

            if (currentSimulation.runNumber == currentSimulation.nRuns) // if all the runs of one data point have been done
            {
                this.dpNumber++;
                
                if (this.dpNumber<values.Count)
                {
                    double newValue = values[this.dpNumber];
                    string endFileName = Convert.ToInt64((newValue * 100)).ToString();
                    string newName = currentSimulation.versionName.Remove(currentSimulation.versionName.Length - 2) + endFileName;
                    this.UKDistributionSimulation(newName, fixedN, fixedK, fixedNFake, fixedNTrue, newValue);
                }
                else // if all the desired setting values have been simulated
                {
                    this.Close();
                }
            }
            else
            {
                this.UKDistributionSimulation(currentSimulation.versionName, fixedN, fixedK, fixedNFake, fixedNTrue, currentSimulation.value);
                this.simulation.runNumber = currentSimulation.runNumber + 1;
            }
            

        }*/
    
        public void CreateNSharesCSV(string generalPath)
        {
            var csv = new StringBuilder();
            csv.AppendLine("ID,nFollowers,o,c,e,a,n,Online Literacy,Political Leaning,nFakeShares,nTrueShares,freqUse,sessionLength,shareFreq"); // column headings
            foreach (Account account in facebook.accountList)
            {
                var line = String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13}", account.ID, account.followers.Count, account.person.opn, account.person.con, account.person.ext, account.person.agr, account.person.nrt, account.person.onlineLiteracy, account.person.politicalLeaning,account.person.nFakeShares, account.person.nTrueShares,account.person.freqUse,account.person.sessionLength, account.person.sharingFreq);// o,c,e,a,n,OL,PL nFakeShares, nTrueShares
                csv.AppendLine(line);
            }
            File.WriteAllText(generalPath+"NsharesPopulation.csv", csv.ToString());

        }
    }
}
