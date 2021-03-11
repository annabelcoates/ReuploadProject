using ModelAttemptWPF;
using System;
using System.Collections.Generic;

public class Person
{
    public int ID;

    // The 'Big 5' Personality traits
    public double opn; // Openess
    public double con; // Conscientiousness
    public double ext; // Extraversion
    public double agr; // Agreeableness
    public double nrt; // Neuroticism

    private double usePsych;

    private Simulation simulation;
    public double freqUse; // A measure of how likely a user is to check social media in a 15 min timeslot, 0-1
    public double sessionLength; // A measure of how many posts a person sees in 1 view of their feed, 0-1, Maybe should be int?
    public double connectivity; // A measure of how likely someone is to have a large network group, can be greater than one

    public double emotionalState; // Represents how emotional someone feels, 0-1
    public double politicalLeaning; // 0 represents 'the left', 1 represents 'the right'
    public double onlineLiteracy; // how likely someone is to believe fake news
    // TODO
    // ! Dead code
    public bool informationLiterate;
    public double sharingFreq;

    public string name;
    public int nFakeShares;
    public int nTrueShares;
    public bool isSet = false;
    public int nFakeViews;
    public int nTrueViews;
    public int nTotalViews;

    public Random random = new Random();

    public double[] beliefPerNews;

    private double SHARING_FREQ_FACTOR = 0.15;

    public Person(int ID,string name,double opn, double con, double ext, double agr, double nrt, double usePsych, Simulation simulation, int nFake, int nTrue)
	{
        this.ID = ID;
        this.name = name;
        this.opn = opn;
        this.con = con;
        this.ext = ext;
        this.agr = agr;
        this.nrt = nrt;
        this.usePsych = usePsych;
        this.simulation = simulation;
        int nNews = nFake + nTrue;
        this.beliefPerNews = new double[nNews];
        for (int i = 0; i < nNews; i++) {
            this.beliefPerNews[i] = 0;
        }
        //this.politicalLeaning = politicalLeaning;
        //this.onlineLiteracy = onlineLiteracy;
        //this.emotionalState = 0.5; // emotional state starts average
        //this.DetermineComplexBehaviours(); // set the behavioural parameters based on the personality traits
	}

    public void PreSetEnvironmentDetermined(double politicalLeaning, double onlineLiteracy, double emotionalState)
    {
        this.politicalLeaning = politicalLeaning;
        this.onlineLiteracy = onlineLiteracy;
        this.emotionalState = emotionalState; // emotional state starts average
        //DetermineComplexBehaviours();
        this.isSet = true;
    }
    public void AdjustEnvironmentDetermined(double politicalLeaning, double plStd, double onlineLiteracy, double olStd, double emotionalState, double esSTD, double doesAffect)
    {
        //this.politicalLeaning = doesAffect * this.politicalLeaning + (1-doesAffect) * politicalLeaning;
        this.politicalLeaning = simulation.NormalDistribution(this.politicalLeaning * doesAffect + politicalLeaning * (1-doesAffect), (1 - doesAffect) *plStd); // 1/1.25
        this.onlineLiteracy = simulation.NormalDistribution(this.onlineLiteracy * doesAffect + onlineLiteracy * (1 - doesAffect), (1 - doesAffect) * olStd); // 1/5
        this.emotionalState = simulation.NormalDistribution(this.emotionalState * doesAffect + emotionalState * (1 - doesAffect), (1 - doesAffect) *esSTD); // 1/10
        DetermineComplexBehaviours();
        //this.isSet = true;
    }

    public void DetermineComplexBehaviours()
    {
        // From caci et al 2014 path analysis
        double tempFreqUse = -0.18 * this.con + 0.12 * this.ext - 0.21 * this.agr + 0.14 * this.nrt;
        double minFreqUse = -0.39; // -0.18-0.21
        double maxFreqUse = 0.26; // 0.12+0.14
        this.freqUse = ((tempFreqUse - minFreqUse) / (maxFreqUse - minFreqUse)) * usePsych + simulation.NormalDistribution(0.4,0.06) * (1-usePsych); // av 0.4, between 0.2 and 0.6
        



        //double tempSL = -0.16 * this.c + 0.24 * e + 0.14 * this.n+0.5;
        double tempSL = -0.16 * this.con + 0.24 * ext + 0.14 * this.nrt;
        double minSL = -0.16; // -0.16
        double maxSL = 0.38;//
        this.sessionLength = ((tempSL - minSL) / (maxSL - minSL)) * usePsych + simulation.NormalDistribution(0.475, 0.14) * (1 - usePsych); // av 9.5, between 0 and 17

        this.connectivity = (0.24 * this.opn - 0.28 * this.con + 0.47 * this.ext - 0.28 * this.agr + 0.2*random.NextDouble()) * usePsych + random.NextDouble() * (1-usePsych);
        // research on likelihood of sharing from amichai- vitinzsky
        this.sharingFreq = ((this.ext + this.nrt) / 2 * usePsych + simulation.NormalDistribution(0.5,0.15) * (1-usePsych)) * SHARING_FREQ_FACTOR; // av 0.125, between 0 and 0.25 (with SFF of 0.25) -> so 0.5, and between 0 and 1
    }


    public double AssessNews(News news)
    {
        // Currently the news is assessed according to 3 factors equally, politics, emotional level and believability

        // political factor is higher if the political leanings are closer
        double poldist = news.politicalLeaning - this.politicalLeaning;
        double politicalFactor = Math.Max(0.4 - 0.4*Math.Abs(poldist), 1-5*poldist*poldist); //if poldist is close, then we care strongly about how close -- if it's far, probability is small
        // how much the news appeals emotionally increases with the person's emotional level and how emotional the news is
        double emotionalFactor = (this.nrt * news.emotionalLevel) * usePsych + 0.4925 * news.emotionalLevel * (1-usePsych); //0.4925 is default nrt

        double believabilityFactor = news.believability * onlineLiteracy + (1-onlineLiteracy);
        //believabilityFactor = 1 - onlineLiteracy;
        // The perceived believability is dependent on the believability of the article and the person's online literacy
        this.beliefPerNews[news.ID] = believabilityFactor;

        // According to Pennycook & Rand (2018) failing to identify news is fake is the biggest affector of how likely a person is to believe and therefore share it (partisanship/ political factor is more minor)

        double shareProb = Math.Min(0.9,this.sharingFreq * (2*believabilityFactor + politicalFactor + emotionalFactor*emotionalState*1.8)/4);
        //Console.WriteLine(this.sharingFreq + ", " + believabilityFactor + ", " + politicalFactor + ", " + emotionalFactor + ", " + shareProb);
        // return the likelihood that someone will share the news

        this.nTotalViews++;

        return shareProb;
    }
}
