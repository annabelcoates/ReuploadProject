﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Microsoft.Data.Analysis;
using Medallion;
using System.Text;


namespace ModelAttemptWPF
{
    public class OSN
    {
        public string name;
        public int feedTimeFrame = 150; // the number of timeslots to go back 

        private Process process = null; // for python connection
        public string followCSVPath = @"C:\Users\ancoa\Documents\Proj\CSVs and text files\FacebookUK\follows";
        private string smallWorldPath = @"C:\Users\ancoa\Documents\Proj\CSVs and text files\FacebookUK\small_world_graph.csv";


        public List<Account> accountList = new List<Account>();
        public int IDCount = 0;
        public List<News> newsList = new List<News>();
        public int newsCount = 0;

        List<string> nameList = new List<string>() {
            "aakash", "aamir", "aaron", "abbas", "abby", "abdul", "abdullah", "abe", "abel", "abhay", "abhijeet", "abhijit", "abhilash", "abhinav", "abhishek", "abigail", "abraham", "abu", "ace", "ada", "adam", "adarsh", "adeel", "adel", "adi", "adil", "aditi", "aditya", "adnan", "adolfo", "adrian", "adriana", "adriano", "adrienne", "agnes", "agnieszka", "ahmad", "ahmed", "ahmet", "ahsan", "aida", "aidan", "aileen", "aimee", "aisha", "aj", "ajay", "ajit", "akash", "akhil", "akshay", "al", "alaa", "alain", "alan", "alana", "albert", "alberto", "aldo", "ale", "alec", "alejandra", "alejandro", "aleksandra", "alessandra", "alessandro", "alex", "alexa", "alexander", "alexandr", "alexandra", "alexandre", "alexandria", "alexandru", "alexey", "alexis", "alfonso", "alfred", "alfredo", "ali", "alice", "alicia", "alina", "aline", "alireza", "alisa", "alisha", "alison", "alissa", "alistair", "allan", "allen", "allie", "allison", "ally", "allyson", "alma", "alok", "alvaro", "alvin", "alyssa", "amal", "aman", "amanda", "amar", "amber", "amelia", "american", "ami", "amie", "amin", "amina", "amine", "amir", "amit", "amol", "amos", "amr", "amy", "ana", "anand", "anas", "anastasia", "anders", "anderson", "andi", "andre", "andrea", "andreas", "andreea", "andrei", "andres", "andrew", "andrey", "andré", "andrés", "andy", "angel", "angela", "angelica", "angelina", "angelo", "angie", "angus", "anh", "ani", "anil", "anish", "anita", "anjali", "ankit", "ankita", "ankur", "ann", "anna", "anne", "annette", "annie", "anoop", "anshul", "anthony", "antoine", "antoinette", "anton", "antonia", "antonio", "antony", "antónio", "anu", "anuj", "anup", "anurag", "anwar", "anya", "apple", "april", "archie", "ari", "ariel", "arif", "arjun", "arlene", "armand", "armando", "arnaud", "arnold", "arpit", "arshad", "art", "artem", "arthur", "artur", "arturo", "arun", "arvind", "asad", "ash", "asha", "asher", "ashish", "ashleigh", "ashley", "ashok", "ashraf", "ashton", "ashutosh", "ashwin", "asif", "asim", "astrid", "athena", "atif", "atul", "aubrey", "audrey", "augusto", "aurora", "austin", "autumn", "ava", "avery", "avi", "avinash", "axel", "ayesha", "ayman", "ayush", "aziz", "bailey", "bala", "balaji", "barb", "barbara", "barney", "baron", "barry", "bart", "basil", "beatrice", "beatriz", "beau", "becca", "becky", "bee", "belinda", "bella", "ben", "benedict", "benjamin", "benny", "benoit", "benson", "bernadette", "bernard", "bernardo", "bernie", "bert", "best", "beth", "bethany", "betsy", "betty", "bev", "beverly", "bhanu", "bharat", "bianca", "big", "bilal", "bill", "billie", "billy", "bjorn", "black", "blaine", "blair", "blake", "blanca", "blue", "bob", "bobbi", "bobbie", "bobby", "bogdan", "bonnie", "boris", "boyd", "brad", "bradford", "bradley", "brady", "brandi", "brandon", "brandy", "brenda", "brendan", "brendon", "brent", "bret", "brett", "brian", "brianna", "bridget", "bright", "brigitte", "britt", "brittany", "brittney", "brock", "brooke", "bruce", "bruno", "bryan", "bryant", "bryce", "buck", "bud", "butch", "byron", "caio", "caitlin", "cal", "caleb", "calvin", "cam", "cameron", "camila", "camilla", "camille", "camilo", "candace", "candice", "candy", "captain", "cara", "carey", "cari", "carina", "carl", "carla", "carlo", "carlos", "carlton", "carly", "carmen", "carol", "carole", "carolina", "caroline", "carolyn", "carrie", "carson", "carter", "cary", "caryn", "casey", "cassandra", "cassie", "catalina", "catherine", "cathy", "cecil", "cecilia", "cedric", "celeste", "celia", "cesar", "chad", "chaitanya", "chan", "chance", "chandan", "chandler", "chandra", "chantal", "charity", "charlene", "charles", "charley", "charlie", "charlotte", "charmaine", "chas", "chase", "chaz", "chelsea", "chen", "cheri", "cherie", "cherry", "cheryl", "chester", "chet", "chetan", "chi", "chiara", "chip", "chirag", "chloe", "chris", "chrissy", "christa", "christi", "christian", "christie", "christina", "christine", "christoph", "christophe", "christopher", "christy", "chuck", "cindi", "cindy", "cj", "claire", "clara", "clare", "clarence", "clark", "claude", "claudia", "claudio", "clay", "clayton", "clement", "cliff", "clifford", "clifton", "clint", "clinton", "clive", "clyde", "cody", "cole", "colette", "colin", "colleen", "collin", "collins", "connie", "connor", "conor", "conrad", "constance", "cora", "corey", "corinne", "cory", "courtney", "craig", "cris", "cristian", "cristiano", "cristina", "crystal", "curt", "curtis", "cyndi", "cynthia", "cyril", "cyrus", "césar", "daisy", "dakota", "dale", "dalia", "dallas", "dalton", "damian", "damien", "damon", "dan", "dana", "dane", "dani", "daniel", "daniela", "daniele", "daniella", "danielle", "danilo", "danish", "danny", "dante", "daphne", "dara", "darcy", "daren", "daria", "darin", "dario", "darius", "darla", "darlene", "darrel", "darrell", "darren", "darrin", "darryl", "darshan", "darwin", "daryl", "dave", "david", "davide", "davis", "dawn", "dean", "deanna", "deb", "debbie", "debby", "debi", "deborah", "debra", "dee", "deep", "deepa", "deepak", "deirdre", "dejan", "delia", "delores", "dena", "denis", "denise", "dennis", "denny", "derek", "derrick", "desiree", "desmond", "destiny", "devendra", "devin", "devon", "dexter", "dheeraj", "dhiraj", "dhruv", "diana", "diane", "dianna", "dianne", "dick", "diego", "dilip", "dillon", "dima", "dimitri", "dimitris", "dina", "dinesh", "dino", "diogo", "dion", "dirk", "divya", "dmitri", "dmitriy", "dmitry", "dolly", "dolores", "dom", "dominic", "dominick", "dominique", "don", "donald", "donna", "donnie", "donny", "donovan", "dora", "doreen", "dorian", "doris", "dorothy", "doug", "douglas", "drake", "drew", "duane", "duke", "duncan", "dustin", "dusty", "dwayne", "dwight", "dylan", "earl", "ed", "eddie", "eddy", "edgar", "edith", "edmond", "edmund", "edna", "edson", "eduard", "eduardo", "edward", "edwin", "ehsan", "eileen", "ekaterina", "el", "elaine", "eleanor", "elena", "eleni", "eli", "elias", "elie", "elijah", "elisa", "elisabeth", "elise", "elisha", "eliza", "elizabeth", "ella", "elle", "ellen", "ellie", "elliot", "elliott", "elmer", "elsa", "elsie", "elvis", "emanuel", "emeka", "emil", "emilia", "emilie", "emilio", "emily", "emma", "emmanuel", "enrico", "enrique", "eric", "erica", "erich", "erick", "ericka", "erik", "erika", "erin", "ernest", "ernesto", "ernie", "errol", "erwin", "esteban", "esther", "ethan", "etienne", "eugene", "eunice", "eva", "evan", "evans", "eve", "evelyn", "everett", "ezra", "fabian", "fabien", "fabio", "fadi", "fahad", "faisal", "faith", "farah", "farhan", "farid", "fatima", "faye", "federico", "felicia", "felipe", "felix", "fernanda", "fernando", "filip", "filipe", "fiona", "flavio", "flora", "florence", "florian", "floyd", "forbes", "forrest", "fran", "frances", "francesca", "francesco", "francine", "francis", "francisco", "franco", "francois", "frank", "frankie", "franklin", "franz", "fred", "freddie", "freddy", "frederic", "frederick", "fredrick", "fredrik", "fritz", "gabby", "gabe", "gabriel", "gabriela", "gabriele", "gabriella", "gabrielle", "gaby", "gail", "gale", "galina", "ganesh", "gareth", "garrett", "garry", "gary", "gaurav", "gautam", "gavin", "gayle", "gemma", "gene", "genevieve", "geo", "geoff", "geoffrey", "george", "georges", "georgia", "georgina", "gerald", "geraldine", "gerard", "gerardo", "geri", "german", "gerry", "gideon", "gigi", "gil", "gilbert", "gilberto", "gilles", "gillian", "gina", "ginger", "ginny", "gino", "gio", "giorgi", "giorgio", "giovanni", "girish", "gisele", "giuseppe", "gladys", "glen", "glenda", "glenn", "gloria", "godfrey", "godwin", "gonzalo", "gopal", "goran", "gordon", "govind", "grace", "graeme", "graham", "grant", "green", "greg", "gregg", "gregory", "greta", "gretchen", "guido", "guilherme", "guillaume", "guillermo", "gus", "gustavo", "gwen", "gwendolyn", "hadi", "hai", "hal", "haley", "hamid", "hamza", "han", "hana", "hani", "hank", "hanna", "hannah", "hans", "happy", "hardik", "hari", "haris", "harish", "harley", "harold", "harriet", "harris", "harrison", "harry", "harsh", "harsha", "harvey", "hasan", "hassan", "hayden", "hayley", "hazel", "heath", "heather", "hector", "heidi", "helen", "helena", "helene", "hemant", "henri", "henrik", "henrique", "henry", "herb", "herbert", "herman", "hilary", "hillary", "himanshu", "hitesh", "hoang", "holly", "hong", "hope", "howard", "hubert", "hugh", "hugo", "humberto", "hung", "hunter", "hussain", "hussein", "huy", "héctor", "iain", "ian", "ibrahim", "ida", "ignacio", "igor", "ike", "ilona", "ilya", "iman", "imran", "ina", "inga", "ingrid", "inna", "ioana", "ira", "irena", "irene", "irfan", "irina", "iris", "irma", "irving", "isaac", "isabel", "isabella", "isabelle", "isaiah", "ismael", "ismail", "israel", "ivan", "ivana", "ivo", "ivy", "jack", "jacki", "jackie", "jackson", "jacky", "jaclyn", "jacob", "jacqueline", "jacquelyn", "jacques", "jacqui", "jacquie", "jade", "jae", "jai", "jaime", "jake", "jakob", "jakub", "jamal", "james", "jami", "jamie", "jamil", "jan", "jana", "jane", "janelle", "janet", "janette", "janice", "janie", "janine", "janis", "jared", "jarrett", "jarrod", "jasmin", "jasmine", "jason", "jasper", "jatin", "javier", "jay", "jayne", "jayson", "jc", "jd", "jean", "jeanette", "jeanie", "jeanine", "jeanne", "jeannette", "jeannie", "jed", "jeff", "jefferson", "jeffery", "jeffrey", "jelena", "jen", "jenifer", "jenn", "jenna", "jenni", "jennie", "jennifer", "jenny", "jens", "jeremiah", "jeremy", "jeri", "jeroen", "jerome", "jerry", "jesper", "jess", "jesse", "jessica", "jessie", "jesus", "jhon", "jill", "jillian", "jim", "jimmie", "jimmy", "jin", "jing", "jitendra", "jo", "joan", "joana", "joann", "joanna", "joanne", "joao", "joaquin", "jocelyn", "jodi", "jodie", "jody", "joe", "joel", "joelle", "joey", "johan", "johann", "johanna", "john", "johnathan", "johnnie", "johnny", "johnson", "jojo", "jon", "jonah", "jonas", "jonathan", "jonathon", "joni", "jonny", "jordan", "jordi", "jorge", "jose", "josef", "joseph", "josephine", "josh", "joshua", "josie", "josue", "josé", "joy", "joyce", "joão", "jp", "jr", "juan", "juanita", "jude", "judi", "judith", "judy", "jules", "julia", "julian", "juliana", "julie", "julien", "juliet", "julio", "julius", "jun", "junaid", "june", "junior", "just", "justin", "justine", "jyoti", "kai", "kaitlyn", "kamal", "kamil", "kamran", "kapil", "kara", "karan", "kareem", "karen", "kari", "karim", "karin", "karina", "karl", "karla", "karolina", "karthik", "kartik", "karyn", "kasey", "kashif", "kasia", "kat", "katarina", "kate", "katelyn", "katerina", "katharine", "katherine", "kathi", "kathie", "kathleen", "kathryn", "kathy", "katia", "katie", "katrina", "katy", "katya", "kaushik", "kay", "kayla", "kc", "keisha", "keith", "kelley", "kelli", "kellie", "kelly", "kelsey", "kelvin", "ken", "kendall", "kendra", "kennedy", "kenneth", "kenny", "kent", "keri", "kerri", "kerry", "ketan", "kevin", "khaled", "khalid", "kieran", "kim", "kimberley", "kimberly", "king", "kingsley", "kira", "kiran", "kirk", "kirsten", "kishore", "kit", "kitty", "klaus", "kofi", "konstantin", "kris", "krishna", "krista", "kristen", "kristi", "kristian", "kristie", "kristin", "kristina", "kristine", "kristy", "krystal", "krzysztof", "kumar", "kunal", "kurt", "kwame", "kyle", "kylie", "la", "lacey", "lady", "lakshmi", "lalit", "lana", "lance", "lane", "lara", "larissa", "larry", "lars", "laura", "laurel", "lauren", "laurence", "laurent", "lauri", "laurie", "lawrence", "le", "lea", "leah", "leandro", "leanne", "lee", "lei", "leigh", "leila", "leland", "len", "lena", "lenny", "leo", "leon", "leonard", "leonardo", "leroy", "lesley", "leslie", "lester", "leticia", "levi", "lewis", "lex", "li", "lia", "liam", "libby", "lidia", "lilian", "liliana", "lillian", "lilly", "lily", "lim", "lin", "lina", "lincoln", "linda", "lindsay", "lindsey", "linh", "lionel", "lisa", "lise", "little", "liz", "liza", "lizzie", "lloyd", "logan", "lois", "lokesh", "lola", "long", "lonnie", "lora", "lord", "loren", "lorena", "lorenzo", "loretta", "lori", "lorna", "lorraine", "lou", "louie", "louis", "louisa", "louise", "lourdes", "love", "lowell", "lu", "luc", "luca", "lucas", "lucia", "luciana", "luciano", "lucky", "lucy", "luigi", "luis", "luisa", "luiz", "lukas", "luke", "luz", "luís", "lydia", "lyle", "lyn", "lynda", "lynette", "lynn", "lynne", "ma", "mac", "mack", "madeline", "madhav", "madison", "magda", "magdalena", "maggie", "magnus", "mahendra", "mahesh", "mahmoud", "mai", "maja", "malcolm", "malik", "mallory", "mandy", "mani", "manish", "manisha", "manny", "manoj", "manu", "manuel", "manuela", "mara", "marc", "marcel", "marcela", "marcelo", "marci", "marcia", "marcie", "marcin", "marcio", "marco", "marcos", "marcus", "marcy", "marek", "margaret", "margarita", "margie", "margo", "mari", "maria", "mariah", "mariam", "marian", "mariana", "marianna", "marianne", "mariano", "marie", "marilyn", "marina", "mario", "marion", "marisa", "marisol", "marissa", "maritza", "marius", "marjorie", "mark", "marko", "markus", "marla", "marlene", "marlon", "marsha", "marshall", "marta", "martha", "marti", "martin", "martina", "marty", "marvin", "mary", "maryam", "maryann", "maría", "mason", "massimo", "mat", "matheus", "mathew", "mathieu", "matt", "matteo", "matthew", "matthias", "maura", "maureen", "maurice", "mauricio", "mauro", "max", "maxim", "maxine", "maxwell", "may", "maya", "mayank", "mayra", "mayur", "md", "md.", "meagan", "meg", "megan", "megha", "meghan", "mehdi", "mehmet", "mehul", "mel", "melanie", "melinda", "melissa", "melody", "melvin", "mercedes", "meredith", "mia", "micah", "michael", "michaela", "michal", "micheal", "michel", "michele", "michelle", "mick", "mickey", "miguel", "mihaela", "mihai", "mikael", "mike", "mikey", "mikhail", "miki", "mila", "milan", "milena", "miles", "millie", "milos", "milton", "mimi", "min", "mina", "mindy", "ming", "minh", "mir", "mira", "miranda", "miriam", "miss", "missy", "mister", "misty", "mitch", "mitchell", "mj", "mo", "moe", "mohamad", "mohamed", "mohammad", "mohammed", "mohan", "mohd", "mohit", "mohsin", "moises", "molly", "mona", "monica", "monika", "monique", "morgan", "morris", "morten", "moses", "moshe", "mostafa", "muhammad", "muhammed", "mukesh", "murali", "murat", "murray", "musa", "mustafa", "mustapha", "my", "myles", "myra", "myron", "nabil", "nadeem", "nadia", "nadine", "nana", "nancy", "naomi", "narendra", "naresh", "nasir", "nat", "natalia", "natalie", "natasha", "nate", "nathalie", "nathan", "nathaniel", "naveed", "naveen", "navin", "neal", "ned", "neeraj", "neha", "neil", "nelly", "nelson", "neo", "nestor", "new", "ng", "nguyen", "nic", "nicholas", "nichole", "nick", "nicki", "nicky", "nico", "nicola", "nicolas", "nicole", "nidhi", "niels", "nigel", "nik", "nikhil", "niki", "nikita", "nikki", "nikola", "nikolay", "nikos", "nilesh", "nina", "nino", "niraj", "nirmal", "nisha", "nishant", "nita", "nitesh", "nitin", "noah", "noel", "noelle", "nolan", "noor", "nora", "norm", "norma", "norman", "not", "nuno", "nur", "oksana", "ola", "old", "oleg", "olga", "oliver", "olivia", "olivier", "omar", "omer", "orlando", "osama", "oscar", "osman", "osvaldo", "otto", "owen", "pablo", "paco", "paige", "pam", "pamela", "pankaj", "paola", "paolo", "parker", "parth", "pascal", "pastor", "pat", "patrice", "patricia", "patrick", "patsy", "patti", "patty", "paul", "paula", "paulette", "paulina", "pauline", "paulo", "pavan", "pavel", "pawan", "pearl", "pedro", "peggy", "penelope", "penny", "per", "perry", "pete", "peter", "petr", "petra", "phil", "philip", "philippe", "phillip", "phoebe", "phoenix", "phuong", "phyllis", "pia", "pierre", "pieter", "piotr", "piyush", "pj", "polly", "pooja", "poonam", "pradeep", "prakash", "pramod", "pranav", "prasad", "prasanna", "prashant", "prashanth", "prateek", "pratik", "praveen", "pravin", "precious", "preeti", "prem", "preston", "prince", "princess", "priscilla", "priya", "priyanka", "puneet", "quang", "quentin", "quinn", "rachael", "rachel", "rachelle", "radu", "rae", "rafael", "raghu", "rahul", "rainer", "raj", "raja", "rajan", "rajat", "rajeev", "rajendra", "rajesh", "rajiv", "raju", "rakesh", "ralph", "ram", "rama", "raman", "ramesh", "rami", "ramiro", "ramon", "ramona", "rana", "randal", "randall", "randi", "randolph", "randy", "ranjeet", "raphael", "raquel", "rashid", "rashmi", "raul", "raven", "ravi", "ravindra", "ray", "raymond", "real", "rebecca", "rebekah", "red", "reed", "reggie", "regina", "reginald", "reid", "rekha", "renata", "renato", "rene", "renee", "rené", "reuben", "rex", "rey", "reza", "rhonda", "ria", "ric", "ricardo", "riccardo", "rich", "richa", "richard", "richie", "rick", "ricky", "rico", "riley", "rishabh", "rishi", "rita", "ritesh", "ritu", "rizwan", "rj", "rob", "robb", "robbie", "robby", "robert", "roberta", "roberto", "robin", "robyn", "rocco", "rochelle", "rocio", "rocky", "rod", "roderick", "rodger", "rodney", "rodolfo", "rodrigo", "rogelio", "roger", "rogerio", "rohan", "rohit", "roland", "rolando", "rolf", "roman", "romeo", "ron", "ronald", "ronaldo", "ronda", "roni", "ronnie", "ronny", "rory", "rosa", "rosanne", "rosario", "rose", "rosemarie", "rosemary", "roshan", "rosie", "ross", "roxana", "roxanne", "roy", "royce", "ruben", "ruby", "rudy", "rui", "ruslan", "russ", "russell", "rusty", "ruth", "ryan", "saad", "sabina", "sabrina", "sachin", "saeed", "sagar", "sahil", "sai", "said", "saif", "sajid", "sal", "salah", "salim", "sally", "salman", "salvador", "salvatore", "sam", "samantha", "sameer", "samer", "sami", "samir", "sammy", "samson", "samuel", "san", "sana", "sandeep", "sandi", "sandip", "sandra", "sandro", "sandy", "sanjay", "sanjeev", "santhosh", "santiago", "santosh", "sara", "sarah", "sascha", "sasha", "satish", "satya", "saul", "saurabh", "saurav", "savannah", "sayed", "scot", "scott", "sean", "sebastian", "sebastien", "seema", "senthil", "serena", "serge", "sergei", "sergey", "sergio", "seth", "shah", "shahid", "shahzad", "shan", "shana", "shane", "shankar", "shanna", "shannon", "shantanu", "sharad", "shari", "sharon", "shashank", "shashi", "shaun", "shauna", "shawn", "shawna", "shay", "sheena", "sheila", "shelby", "sheldon", "shelley", "shelly", "sheri", "sherif", "sherman", "sherri", "sherrie", "sherry", "sheryl", "shirley", "shiv", "shiva", "shivam", "shoaib", "shruti", "shubham", "shweta", "shyam", "sid", "siddharth", "sidney", "silver", "silvia", "simon", "simona", "simone", "siobhan", "siva", "sky", "skyler", "smith", "sneha", "sofia", "solomon", "sonali", "sonia", "sonja", "sonny", "sonya", "sophia", "sophie", "spencer", "sri", "sridhar", "srikanth", "srinivas", "sriram", "stacey", "stacie", "stacy", "stan", "stanley", "star", "stefan", "stefanie", "stefano", "stella", "steph", "stephan", "stephane", "stephanie", "stephen", "sterling", "steve", "steven", "stewart", "stu", "stuart", "su", "sudhir", "sue", "suman", "sumit", "sunil", "sunny", "suraj", "suresh", "surya", "susan", "susana", "susanna", "susanne", "sushant", "sushil", "susie", "suzan", "suzanne", "suzi", "suzie", "suzy", "sven", "svetlana", "swapnil", "swati", "sydney", "syed", "sylvia", "sérgio", "tabitha", "tam", "tamara", "tamer", "tami", "tammie", "tammy", "tan", "tania", "tanja", "tanner", "tanya", "tara", "tarek", "tariq", "tarun", "taryn", "tasha", "tatiana", "taylor", "tech", "ted", "teddy", "tee", "tejas", "terence", "teresa", "teri", "terrance", "terrence", "terri", "terry", "tess", "tessa", "thanh", "theo", "theodore", "theresa", "therese", "thiago", "thierry", "thom", "thomas", "tia", "tiago", "tiffany", "tim", "timmy", "timothy", "tin", "tina", "tj", "tobias", "toby", "tod", "todd", "tom", "tomas", "tomasz", "tommy", "toni", "tony", "tonya", "tori", "tracey", "traci", "tracie", "tracy", "tran", "travis", "trent", "trevor", "trey", "tricia", "trina", "trish", "trisha", "tristan", "troy", "trudy", "tuan", "tushar", "tyler", "tyrone", "tyson", "uday", "uma", "umair", "umar", "umesh", "ursula", "usman", "vadim", "vaibhav", "val", "valentina", "valeria", "valerie", "van", "vanessa", "varun", "vaughn", "venkat", "venkatesh", "vera", "vernon", "veronica", "veronika", "vic", "vicente", "vicki", "vickie", "vicky", "victor", "victoria", "vijay", "vikas", "vikram", "viktor", "vinay", "vince", "vincent", "vineet", "vinicius", "vinny", "vinod", "vipin", "vipul", "virginia", "vishal", "vishnu", "vitor", "vivek", "vivian", "vlad", "vladimir", "wade", "waleed", "walid", "wallace", "wally", "walt", "walter", "wan", "wanda", "wang", "waqas", "warren", "wayne", "wei", "wendell", "wendy", "wes", "wesley", "whitney", "wil", "will", "william", "williams", "willie", "willis", "willy", "wilma", "wilson", "winnie", "winston", "wolf", "wolfgang", "wong", "wyatt", "xavier", "xiao", "yan", "yana", "yang", "yash", "yasir", "yasmin", "yasser", "yi", "ying", "yogesh", "yolanda", "yong", "young", "youssef", "yu", "yulia", "yuri", "yusuf", "yves", "yvette", "yvonne", "zac", "zach", "zachary", "zack", "zain", "zak", "zane", "zeeshan", "zoe"
        };
        public Random random = new Random();

        public StringBuilder followCSV = new StringBuilder();


        // Statistics
        public int nSharedFakeNews = 0;
        public int nSeenFakeNews = 0;
        public List<int> nSharedFakeNewsList = new List<int>() { 0 }; // at t=0, 0 people have seen fake news
        public List<double> fakeShareProbs = new List<double>();
        public List<double> trueShareProbs = new List<double>();
        

        public OSN(string name)
        {
            this.name = name;
            followCSV.AppendLine("key,source,target");
        }

        public Account NewAccount(Person person)
        {
            Account newAccount = new Account(this, person);
            IDCount++;
            accountList.Add(newAccount);
            return newAccount;
        }

        public void Follow(Account follower, Account followee)
        {
            accountList[follower.ID].following.Add(followee);
            accountList[followee.ID].followers.Add(follower);
            WriteConnectionToCSV(follower.ID, followee.ID);
        }


        public void PopulateFromPeople(int n, int k, List<Person> population)
        {
           
            // Choose n people from the population to make accounts
            for (int i = 0; i < n; i++)
            {
                // Pick the next person (there is no pattern to the order of people in the population so this is effectively random)
                Person person = population[i];
                // Make them an account
                this.NewAccount(person);
            }
            //this.CreateGraphCSV(n.ToString(),k.ToString());
        }

        public void CreateRandomMutualFollows(Account account,int nConnections)
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
                            Follow(accountList[account.ID],accountList[randomID]);
                            Follow(accountList[randomID],accountList[account.ID]);
                            connectionsNotFound = false;
                        }
                    }
                }
        }

        public void CreateRandomFollow()
        {
            List<Account> validFollowers = new List<Account>();
            foreach (Account account in accountList)
            {
                if (account.followers.Count != accountList.Count - 1)
                {
                    validFollowers.Add(account);
                }
            }
            if (validFollowers.Count != 0)
            {
                int followerID = random.Next(validFollowers.Count);
                int followeeID = 0;
                bool validID = false;
                while (validID == false)
                {
                    followeeID = random.Next(this.IDCount);
                    validID = true;
                    foreach (Account existingFollower in this.accountList[followeeID].followers)
                    {
                        if (followerID == existingFollower.ID | followerID == followeeID)
                        {
                            validID = false;
                        }
                    }
                }
                validFollowers[followerID].Follow(accountList[followeeID]);
                this.Follow(this.accountList[followerID], this.accountList[followeeID]);
            }

        }

        public void ShareNews(News news, Account poster,int time)
        {
            Post post = new Post(news, time, poster);
            accountList[poster.ID].page.Add(post);
            this.newsList[news.ID].sharers.Add(poster.person);
            if (news.isTrue == false)
            {
                this.nSharedFakeNews++;
                poster.person.nFakeShares++;
            }
            else
            {
                poster.person.nTrueShares++;
            }
            this.newsList[news.ID].nShared++;

        }


        public News CreateNewsRandomPoster(string name, bool isTrue,int time,double emotionalLevel,double believability,int nPosts=1)
        {
            News news = new News(this.newsCount,name+newsCount, isTrue,emotionalLevel,believability);
            this.newsList.Add(news);
            for (int i = 0; i < nPosts; i++)
            {
                // could have it so that the time is different for multiple posters
                Account poster = accountList[random.Next(IDCount)];
                this.ShareNews(news, poster, time);
            }
            this.newsCount++;
            return news;
        }

        public void ViewNews( Account account, News news, int time)
        {
            if (accountList[account.ID].HasShared(news) == false)
                // change this so the probability of sharing decreases exponentially
            {
                double randomWeightedDouble = random.NextDouble() *(Math.Exp(news.NumberOfTimesViewed(account.person)));
                // TO do change this back to exponential
                double shareProb = account.person.AssesNews(news);
                if (news.isTrue)
                {
                    trueShareProbs.Add(shareProb);
                }
                else
                {
                    fakeShareProbs.Add(shareProb);
                }
                //Console.WriteLine(account.person.name + " assesed " + news.name +"(b=" +news.believability+", e="+news.emotionalLevel + ") as: " + assesment);
                if (randomWeightedDouble < shareProb)
                {
                    //Console.WriteLine(account.person.name + " shared " + news.name);
                    this.ShareNews(news, account, time);
                }
                if (news.HasSeen(account) == false)
                {
                    newsList[news.ID].nViewed++;
                    newsList[news.ID].viewers.Add(account.person);
                    news.nViews.Add(1);
                    accountList[account.ID].seen.Add(news);
                }
                else
                {
                    int key = news.viewers.IndexOf(account.person);
                    // Find the index of the viewer in the viewers list for the person that is currently viewing the news
                    int key2 = news.viewers.FindIndex(viewer => viewer.ID == account.person.ID);
                    newsList[news.ID].nViews[key2] += 1;
                }
            }
        }

        public void ViewFeed(Account account, int time)
        {
            // Create a list of all the posts within the last 30 mins (up to 100) (2 timeslots)
            List<Post> currentFeed = new List<Post>();
            int count = 0;
            foreach (Account followee in account.following)
            {
                foreach (Post post in followee.page)
                {
                    if (time - post.time <= this.feedTimeFrame & count <100)
                    {
                        currentFeed.Add(post);
                    }
                }
            }
            currentFeed.Shuffle(random);
            int nPostsToView = Convert.ToInt16(Math.Ceiling(Convert.ToDecimal(account.person.sessionLength * 20)));
            foreach (Post post in currentFeed.Take(nPostsToView))
            {
                this.ViewNews(account, post.news, time);
            }
        }

        public List<string[]> LoadCsvFile(string filePath)
        {
            var reader = new StreamReader(File.OpenRead(filePath));
            List<string[]> searchList = new List<string[]>();
            while (!reader.EndOfStream)
            {
                string line = reader.ReadLine(); // ignore the line of labels
                if (line!= ",source,target")
                {
                    char[] seperator = new char[] { ',' };
                    string[] lineList = line.Split(seperator);
                    searchList.Add(lineList);
                }
            }
            return searchList;
                       
        }

        private void CreateGraphCSV(string n, string k)
        {
            process = new Process();
            process.StartInfo.WorkingDirectory = @"C:\Users\ancoa\Documents\Proj\ReuploadProject"; //!! set this to the folder that the .sln file is in
            process.OutputDataReceived += (sender, e) => Console.WriteLine($"Recieved:\t{e.Data}");
            process.ErrorDataReceived += (sender, e) => Console.WriteLine($"ERROR:\t {e.Data}");
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.RedirectStandardError = true;
            process.StartInfo.UseShellExecute = false;

            process.StartInfo.FileName = @"C:\Users\Anni\AppData\Local\Programs\Python\Python37\python.exe"; //!! set this to the location of python.exe on your device
            /// python exe @"C:\Users\Anni\PycharmProjects\NetworkGraphs\tester_wheel_graph.py";
            process.StartInfo.Arguments = "tester_wheel_graph.py --n " + n + " --k " + k;
            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();
            process.WaitForExit();
        }
        
        public void CreateMutualFollowsFromGraph(string filePath)
        {
            List<string[]> connections = LoadCsvFile(filePath);
            foreach( string[] connection in connections)
            {
                // string[0] is the key and isn't necesary
                int followerID = Convert.ToInt16(connection[1]);
                int followeeID = Convert.ToInt16(connection[2]);
                this.Follow(accountList[followeeID], accountList[followerID]);
                this.Follow(accountList[followerID], accountList[followeeID]);
            }
        }

        public void CreateFollowsFromPersonality(int defaultFollows)
            //Change this to take a default number of follows
        {
            foreach (Account account in this.accountList)
            {
                int nConnections = Convert.ToInt16(account.person.largeNetwork * defaultFollows);
                this.CreateRandomMutualFollows(account, nConnections);
            }
        }

        public void TimeSlotPasses(int time)
        {
            // Determine which users will check their news feed in this time slot
            double randomDouble = random.NextDouble();
            foreach(Account account in this.accountList)
            {
                if (account.person.freqUse > randomDouble)
                {
                    this.ViewFeed(this.accountList[account.ID], time);
                }

            }
            this.UpdateStatistics();
        }

        private void UpdateStatistics()
        {
            this.nSharedFakeNewsList.Add(this.nSharedFakeNews);
            foreach( News news in newsList)
            {
                news.nSharedList.Add(news.nShared);
                news.nViewedList.Add(news.nViewed);
            }
        }
        private void WriteConnectionToCSV(int from, int to)
        {
            var line = String.Format("{0},{1},{2}", 0, from, to); // so that the columns match from smallworld path
            followCSV.AppendLine(line);
        }
        public void SaveFollowCSV(string generalPath)
        {
            string[] lines = followCSV.ToString().Split(Environment.NewLine.ToCharArray());
            File.WriteAllLines(followCSVPath+this.name+".csv", lines);
            string[] allSmallWorld = File.ReadAllLines(smallWorldPath);
            File.AppendAllLines(generalPath+"follows.csv", allSmallWorld);

        }
    }
}

