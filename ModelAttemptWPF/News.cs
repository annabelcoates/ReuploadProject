using System;
using System.Collections.Generic;

namespace ModelAttemptWPF
{
    public class News
    {
        public int ID;
        public string name;
        public bool isTrue;
        public double emotionalLevel;
        public double politicalLeaning; // 0 represents 'the left', 1 represents 'the right'
        public double believability;

        private OSN o;

        public int totalViews;
        public int uniqueViews; // equal to the count of the viewers list so probably not needed
        //public List<Person> viewers = new List<Person>();
        public int[] vs;
        public int[] ss;
        //public List<int> nViews = new List<int>(); // the number of times each person has viewed the piece of news, corresponds to each element in the viewers list
        //public List<Person> sharers = new List<Person>();

        // Statistics
        public int nShared = 0;
        public List<int> nSharedList = new List<int>() { };
        public int nViewed = 0;
        public List<int> nViewedList = new List<int>() { };

        public News(int ID,string name, bool isTrue, double emotionalLevel,double believability, double politicalLeaning, OSN o)
        {
            this.ID = ID;
            this.name=name;
            this.isTrue = isTrue;
            this.politicalLeaning = politicalLeaning;
            this.emotionalLevel = emotionalLevel;
            this.believability = believability;
            this.o = o;
            vs = new int[o.IDCount];
            ss = new int[o.IDCount];
        }

        public bool HasSeen(Account account)
        {
            int personID = account.person.ID; //for speed
            // method to determine if news has been seen by a user before
            /*foreach(Person viewer in viewers)
            {
                if (viewer.ID == personID)
                {
                    return true;
                }
            }
            return false;*/
            return vs[personID] > 0;
        }

        /*public List<double> CalculateSharerAverages()
        {
         
            double o = 0; double c = 0; double e = 0; double a = 0; double n = 0;
            double onlineLiteracy = 0; double politicalLeaning = 0;
            double nSharers = Convert.ToDouble(sharers.Count);
            foreach (Person sharer in sharers)
            {
                // big 5 personality traits
                o += sharer.opn;
                c += sharer.con;
                e += sharer.ext;
                a += sharer.agr;
                n += sharer.nrt;
                
                // other traits
                onlineLiteracy += sharer.onlineLiteracy;
                politicalLeaning += sharer.politicalLeaning;
            }
            o /= nSharers; c /= nSharers; e /= nSharers; a /= nSharers; n /= nSharers;
            onlineLiteracy /= nSharers; politicalLeaning /= nSharers;
            List<double> averages = new List<double>() { o, c, e, a, n, onlineLiteracy, politicalLeaning };
            return averages;
        }*/

        /*public List<double> CalculateViewerAverages()
        {

            double o = 0; double c = 0; double e = 0; double a = 0; double n = 0;
            double onlineLiteracy = 0; double politicalLeaning = 0;
            double nViewers = Convert.ToDouble(sharers.Count);
            foreach (Person viewer in viewers)
            {
                // big 5 personality traits
                o += viewer.opn;
                c += viewer.con;
                e += viewer.ext;
                a += viewer.agr;
                n += viewer.nrt;

                // other traits
                onlineLiteracy += viewer.onlineLiteracy;
                politicalLeaning += viewer.politicalLeaning;
            }
            o /= nViewers; c /= nViewers; e /= nViewers; a /= nViewers; n /= nViewers;
            onlineLiteracy /= nViewers; politicalLeaning /= nViewers;
            List<double> averages = new List<double>() { o, c, e, a, n, onlineLiteracy, politicalLeaning };
            return averages;
        }*/

        public int NumberOfTimesViewed(Person person)
        {
            // Find the index of the viewer in the viewers list for the person that is currently viewing the news
            /*int key = viewers.FindIndex(viewer => viewer.ID == person.ID);
            if(key > 0)
            {
                return nViews[key];
            }
            else
            {
                return 0;
            }*/
            int personID = person.ID;
            return vs[personID];
        }
        public void personViews(Person p)
        {
            vs[p.ID]++;
        }

        internal void personShares(Person p)
        {
            ss[p.ID]++;
        }

        internal List<Person> sharers()
        {
            List<Person> r = new List<Person>();
            for(int i = 0; i < ss.Length; i++)
            {
                if (ss[i] > 0) r.Add(o.accountList[i].person);
            }
            return r;
        }

        internal List<Person> viewers()
        {
            List<Person> r = new List<Person>();
            for (int i = 0; i < vs.Length; i++)
            {
                if (vs[i] > 0) r.Add(o.accountList[i].person);
            }
            return r;
        }
    }
}