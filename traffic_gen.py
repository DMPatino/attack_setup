import requests
import random
import time

domains = [
    "http://google.com", "http://youtube.com", "http://facebook.com",
    "http://amazon.com", "http://twitter.com", "http://wikipedia.org",
    "http://instagram.com", "http://reddit.com", "http://ebay.com",
    "http://live.com", "http://netflix.com", "http://cnn.com",
    "http://microsoft.com", "http://walmart.com", "http://yelp.com",
    "http://espn.com", "http://bestbuy.com", "http://hulu.com",
    "http://target.com", "http://craigslist.org"
]

while True:
    domain = random.choice(domains)
    try:
        response = requests.get(domain)
        print(f"Visited {domain} - Status Code: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Error visiting {domain}: {e}")
    time.sleep(random.uniform(0.1, 1))  # Random sleep between requests
