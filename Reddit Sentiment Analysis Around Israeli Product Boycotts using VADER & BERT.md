```python
pip install datetime
```

    


```python
pip install transformers torch
```





```python
import praw
import pandas as pd
from datetime import datetime

# Reddit API credentials
CLIENT_ID = 'your client id name'
CLIENT_SECRET = 'your secret authentication code'
USER_AGENT = 'your user agent'

# Reddit API 
reddit = praw.Reddit(client_id=CLIENT_ID,
                     client_secret=CLIENT_SECRET,
                     user_agent=USER_AGENT)

# Possible search terms to use
broad_terms = ['boycott Israeli products', 
               'BDS movement', 
               'boycott Israeli-supporting brands',
               'pro-Israel boycott', 
               'boycott pro-Israel companies', 
               'anti-Israel boycott', 
               'brands supporting Israel', 
               'boycott brands supporting Israel', 
               'support for Israel products']

# Function to collect posts based on the search terms
def collect_posts(terms):
    posts_data = []
    for term in terms:
        for post in reddit.subreddit('all').search(term, limit=1000):
            # Convert timestamp to datetime for month-wise grouping
            post_time = datetime.utcfromtimestamp(post.created_utc)
            posts_data.append([post.title, post.selftext, post.score, post.num_comments, post_time, post.subreddit.display_name, term])
    return posts_data
broad_posts = collect_posts(broad_terms)

#Dataframe
df = pd.DataFrame(broad_posts, columns=['title', 'body', 'score', 'comments', 'created_utc', 'subreddit', 'search_term'])

# Group data with month
df['month'] = df['created_utc'].dt.to_period('M')

# Save data as CSV file
df.to_csv('reddit_boycott_data_monthwise.csv', index=False)
print("Data collection complete. Saved to reddit_boycott_data_monthwise.csv")

```


```python
import pandas as pd
impt = pd.read_csv('reddit_boycott_data_monthwise.csv')
impt
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>title</th>
      <th>body</th>
      <th>score</th>
      <th>comments</th>
      <th>created_utc</th>
      <th>subreddit</th>
      <th>search_term</th>
      <th>month</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Do you guys boycott israeli products?</td>
      <td>Genuine question, because with the amount of a...</td>
      <td>474</td>
      <td>242</td>
      <td>8/24/2021 16:52</td>
      <td>Palestine</td>
      <td>boycott Israeli products</td>
      <td>2021-08</td>
    </tr>
    <tr>
      <th>1</th>
      <td>guys should we boycott israeli products until ...</td>
      <td>personally i think i would want to boycott unt...</td>
      <td>48</td>
      <td>71</td>
      <td>12/10/2023 9:26</td>
      <td>Muslim</td>
      <td>boycott Israeli products</td>
      <td>2023-12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Burqa-clad women entering shops, forcing owner...</td>
      <td>NaN</td>
      <td>1424</td>
      <td>453</td>
      <td>11/1/2023 6:48</td>
      <td>IndiaSpeaks</td>
      <td>boycott Israeli products</td>
      <td>2023-11</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Canada's largest Protestant church approves bo...</td>
      <td>NaN</td>
      <td>1222</td>
      <td>638</td>
      <td>8/20/2012 12:29</td>
      <td>worldnews</td>
      <td>boycott Israeli products</td>
      <td>2012-08</td>
    </tr>
    <tr>
      <th>4</th>
      <td>A simple boycott of Israeli products is bad an...</td>
      <td>NaN</td>
      <td>1059</td>
      <td>49</td>
      <td>3/31/2024 18:37</td>
      <td>Palestine</td>
      <td>boycott Israeli products</td>
      <td>2024-03</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2019</th>
      <td>A conversation about the pro-Palestinian movement</td>
      <td>Something I’ve noticed in [my last post](https...</td>
      <td>25</td>
      <td>156</td>
      <td>7/25/2023 13:07</td>
      <td>IsraelPalestine</td>
      <td>support for Israel products</td>
      <td>2023-07</td>
    </tr>
    <tr>
      <th>2020</th>
      <td>Apple vs Android</td>
      <td>I can’t really find why Apple is on the boycot...</td>
      <td>12</td>
      <td>6</td>
      <td>8/24/2024 21:45</td>
      <td>BDS</td>
      <td>support for Israel products</td>
      <td>2024-08</td>
    </tr>
    <tr>
      <th>2021</th>
      <td>Is US foreign policy compromised, and what doe...</td>
      <td>For those of us who follow international polit...</td>
      <td>46</td>
      <td>21</td>
      <td>4/22/2024 9:10</td>
      <td>chomsky</td>
      <td>support for Israel products</td>
      <td>2024-04</td>
    </tr>
    <tr>
      <th>2022</th>
      <td>what are good yet affordable face cream/moistu...</td>
      <td>Hi everyone,\n\nI'm looking for recommendation...</td>
      <td>1</td>
      <td>0</td>
      <td>8/7/2024 11:13</td>
      <td>Hijabis</td>
      <td>support for Israel products</td>
      <td>2024-08</td>
    </tr>
    <tr>
      <th>2023</th>
      <td>Gaming Question</td>
      <td>I posted this on r/BoycottIsrael first, but I ...</td>
      <td>9</td>
      <td>4</td>
      <td>6/21/2024 1:31</td>
      <td>BDS</td>
      <td>support for Israel products</td>
      <td>2024-06</td>
    </tr>
  </tbody>
</table>
<p>2024 rows × 8 columns</p>
</div>




```python
import pandas as pd
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from transformers import pipeline
import nltk

# Download VADER lexicon
nltk.download('vader_lexicon')


df = pd.read_csv('reddit_boycott_data_monthwise.csv')

# Fill missing 'body' entries with empty strings, combining 'title & 'body' col
df['body'] = df['body'].fillna('')
df['text'] = df['title'] + ' ' + df['body']

#Truncating the text to avoid long texts
df['text'] = df['text'].apply(lambda x: x[:500])

### VADER Sentiment Analysis ###
# Initialize VADER Sentiment Analyzer
sid = SentimentIntensityAnalyzer()

# A function to calculate sentiment using VADER
def get_sentiment_vader(text):
    scores = sid.polarity_scores(text)
    if scores['compound'] >= 0.05:
        return 'positive'
    elif scores['compound'] <= -0.05:
        return 'negative'
    else:
        return 'neutral'

# Apply VADER sentiment analysis to the 'text' (combination of title & body col) col
df['sentiment_vader'] = df['text'].apply(get_sentiment_vader)

### BERT Sentiment Analysis ###
# Load Hugging Face sentiment analysis pipeline (DistilBERT)
classifier = pipeline('sentiment-analysis')

#A function to get sentiment using DistilBERT
def get_sentiment_bert(text):
    try:
        result = classifier(text)[0]  # Get the first result as the label
        return result['label'].lower()  # Return 'positive' or 'negative'
    except:
        return 'neutral'  # If any error occurs, mark it as neutral

# Apply DistilBERT sentiment analysis to the 'text' column
df['sentiment_bert'] = df['text'].apply(get_sentiment_bert)

### Saving combined results to new CSV ###
output_file = 'reddit_boycott_vader_bert_sentiment.csv'
df.to_csv(output_file, index=False)

# Show the first few rows of the resulting dataframe
print(df[['title', 'text', 'sentiment_vader', 'sentiment_bert']].head())

```

    

                                                   title  \
    0              Do you guys boycott israeli products?   
    1  guys should we boycott israeli products until ...   
    2  Burqa-clad women entering shops, forcing owner...   
    3  Canada's largest Protestant church approves bo...   
    4  A simple boycott of Israeli products is bad an...   
    
                                                    text sentiment_vader  \
    0  Do you guys boycott israeli products? Genuine ...        negative   
    1  guys should we boycott israeli products until ...        negative   
    2  Burqa-clad women entering shops, forcing owner...        negative   
    3  Canada's largest Protestant church approves bo...        positive   
    4  A simple boycott of Israeli products is bad an...        negative   
    
      sentiment_bert  
    0       negative  
    1       negative  
    2       negative  
    3       negative  
    4       negative  
    
