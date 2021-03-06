using ModelAttemptWPF;
using System;

public class Person
{
    public int ID;

    // The 'Big 5' Personality traits
    public double opn; // Openess
    public double con; // Conscientiousness
    public double ext; // Extraversion
    public double agr; // Agreeableness
    public double nrt; // Neuroticism

   

    public double freqUse; // A measure of how likely a user is to check social media in a 15 min timeslot, 0-1
    public double sessionLength; // A measure of how many posts a person sees in 1 view of their feed, 0-1, Maybe should be int?
    public double connectivity; // A measure of how likely someone is to have a large network group, can be greater than one

    public double emotionalState; // Represents how emotional someone feels, 0-1
    public double politicalLeaning; // 0 represents 'the left', 1 represents 'the right'
    public double onlineLiteracy; // how likely someone is to believe fake news
    public bool informationLiterate;
    public double sharingFreq;

    public string name;
    public int nFakeShares;
    public int nTrueShares;

    public Random random = new Random();
    public Person(int ID,string name,double opn, double con, double ext, double agr, double nrt, double politicalLeaning, double onlineLiteracy)
	{
        this.ID = ID;
        this.name = name;
        this.opn = opn;
        this.con = con;
        this.ext = ext;
        this.agr = agr;
        this.nrt = nrt;

        this.politicalLeaning = politicalLeaning;
        this.onlineLiteracy = onlineLiteracy;
        this.emotionalState = 0.5; // emotional state starts average
        this.DetermineComplexBehaviours(); // set the behavioural parameters based on the personality traits
	}
    
    public void DetermineComplexBehaviours()
    {
        // From caci et al 2014 path analysis
        double tempFreqUse = -0.18 * this.con + 0.12 * this.ext - 0.21 * this.agr + 0.14 * this.nrt;
        double minFreqUse = -0.39; // -0.18-0.21
        double maxFreqUse = 0.26; // 0.12+0.14
        this.freqUse = (tempFreqUse - minFreqUse)/ (maxFreqUse - minFreqUse);
        



        //double tempSL = -0.16 * this.c + 0.24 * e + 0.14 * this.n+0.5;
        double tempSL = -0.16 * this.con + 0.24 * ext + 0.14 * this.nrt;
        double minSL = -0.16; // -0.16
        double maxSL = 0.38;//
        this.sessionLength = (tempSL - minSL) / (maxSL - minSL);
 
        this.connectivity = Math.Max(0,(0.24 * this.opn - 0.28 * this.con + 0.47 * this.ext - 0.28 * this.agr)); // can be larger than 1
        // research on likelihood of sharing from amichai- vitinzsky
        this.sharingFreq = this.ext * this.nrt;
    }


    public double AssesNews(News news)
    {
        // Currently the news is assessed according to 3 factors equally, politics, emotional level and believability

        // political factor is higher if the political leanings are closer
        double poldist = news.politicalLeaning - this.politicalLeaning;
        double politicalFactor = Math.Max(0.4 - 0.4*Math.Abs(poldist), 1-5*poldist*poldist); //if poldist is close, then we care strongly about how close -- if it's far, probability is small
        // how much the news appeals emotionally increases with the person's emotional level and how emotional the news is
        double emotionalFactor = this.nrt * news.emotionalLevel;

        double believabilityFactor = news.believability * onlineLiteracy + (1-onlineLiteracy);
        //believabilityFactor = 1 - onlineLiteracy;
        // The perceived believability is dependent on the believability of the article and the person's online literacy
        

        // According to Pennycook & Rand (2018) failing to identify news is fake is the biggest affector of how likely a person is to believe and therefore share it (partisanship/ political factor is more minor)

        double shareProb = Math.Min(1,this.sharingFreq *believabilityFactor*(politicalFactor +emotionalFactor));
        //Console.WriteLine(this.name+" probability of sharing "+news.name+": "  shareProb);
        // return the likelihood that someone will share the news
        return shareProb;

    }
}
