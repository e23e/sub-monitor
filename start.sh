# Checking required Environment variables are present
if [[ -z "${TELEGRAM_TOKEN}" ]]; then
  echo "TELEGRAM_TOKEN not present, exiting"
  exit(1)
fi

if [[ -z "${TELEGRAM_CHAT_ID}" ]]; then
  echo "TELEGRAM_CHAT_ID not present, exiting"
  exit(1)
fi

# Delete old data if present
rm -rf ~/recon/subdomains.txt ~/recon/output/aquatone ~/recon/output/aquatone ~/recon/new_subdomains.txt

#create dirs if not exit
mkdir -p ~/recon/output/aquatone ~/recon/data

# Fetching new resolvers
wget https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -O ~/recon/data/resolvers.txt

# Download wordlist if not already downloaded
if [ ! -e ~/recon/data/wordlist.txt ]
then
    echo "Wordlist not found, downloading it"
    wget https://github.com/danielmiessler/SecLists/raw/master/Discovery/DNS/dns-Jhaddix.txt -O ~/recon/data/wordlist.txt
fi

# Subdomain Scanning
echo "Starting enumerating subdomains"
puredns bruteforce ~/recon/data/wordlist.txt -d ~/recon/data/domains.txt --rate-limit 10000 --rate-limit-trusted 100 -r ~/recon/data/resolvers.txt -w ~/recon/subdomains.txt;
echo "Completed enumerating subdomains"


#Seperating New domains
if [ ! -e ~/recon/data/state_subdomains.txt ]
then
#if file not found
    echo "Statefile not found, Creating"
    cp ~/recon/subdomains.txt ~/recon/data/state_subdomains.txt
else
    comm -2 -3 <(sort -i ~/recon/subdomains.txt) <(sort -i ~/recon/data/state_subdomains.txt) > ~/recon/new_subdomains.txt
    cat ~/recon/new_subdomains.txt >> ~/recon/data/state_subdomains.txt
fi

echo "Starting Screenshorting!"
cat ~/recon/new_subdomains.txt | aquatone -out ~/recon/output/aquatone
echo "Completed Screenshorting!"

python3 main.py
